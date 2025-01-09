#!/bin/bash

# Exit on any error
set -e

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root (with sudo)"
    exit 1
fi

# Store the original user who ran sudo
ORIGINAL_USER=$SUDO_USER
if [ -z "$ORIGINAL_USER" ]; then
    echo "Please run this script as sudo"
    exit 1
fi

# Install fish shell
echo "Installing fish shell..."
apt -y install fish

# Check if fish is in /etc/shells
if ! grep -q "^/usr/bin/fish$" /etc/shells; then
    echo "Adding fish to /etc/shells..."
    echo "/usr/bin/fish" >>/etc/shells
fi

# Change shell for the original user
echo "Changing default shell to fish for user $ORIGINAL_USER..."
chsh -s /usr/bin/fish "$ORIGINAL_USER"

# Create fish config directory if it doesn't exist
FISH_CONFIG_DIR="/home/$ORIGINAL_USER/.config/fish"
mkdir -p "$FISH_CONFIG_DIR"

# Create/update config.fish
CONFIG_FILE="$FISH_CONFIG_DIR/config.fish"
echo "Creating fish configuration at $CONFIG_FILE..."

# Remove greeting message
echo "# Remove greeting message" >"$CONFIG_FILE"
echo "set fish_greeting" >>"$CONFIG_FILE"
echo "" >>"$CONFIG_FILE"

# Process .bashrc exports
echo "# Environment variables (imported from .bashrc)" >>"$CONFIG_FILE"
BASHRC="/home/$ORIGINAL_USER/.bashrc"

# Function to convert bash export to fish syntax
convert_export() {
    local line="$1"
    # Extract variable name and value
    if [[ $line =~ ^export[[:space:]]+([^=]+)=(.*)$ ]]; then
        local var="${BASH_REMATCH[1]}"
        local value="${BASH_REMATCH[2]}"

        # Remove quotes if present
        value="${value#\"}"
        value="${value%\"}"
        value="${value#\'}"
        value="${value%\'}"

        # Output in fish syntax
        echo "set -x $var $value"
    fi
}

# Function to convert bash alias to fish syntax
convert_alias() {
    local line="$1"
    # Extract alias name and command
    if [[ $line =~ ^alias[[:space:]]+([^=]+)=(.*)$ ]]; then
        local name="${BASH_REMATCH[1]}"
        local command="${BASH_REMATCH[2]}"
        
        # Remove quotes if present
        command="${command#\"}"
        command="${command%\"}"
        command="${command#\'}"
        command="${command%\'}"
        
        # Output in fish syntax
        echo "alias $name '$command'"
    fi
}

# Read .bashrc and process exports
{
    comment=""
    echo "# Exported variables" >> "$CONFIG_FILE"
    echo "" >> "$CONFIG_FILE"
    
    while IFS= read -r line || [ -n "$line" ]; do
        # Skip empty lines
        if [[ -z "$line" ]]; then
            continue
        fi
        
        # Collect comments
        if [[ "$line" =~ ^[[:space:]]*# ]]; then
            if [ -n "$comment" ]; then
                comment="$comment\n$line"
            else
                comment="$line"
            fi
            continue
        fi
        
        # Process export lines
        if [[ "$line" =~ ^export[[:space:]] ]]; then
            # Write collected comments if any
            if [ -n "$comment" ]; then
                echo -e "$comment" >> "$CONFIG_FILE"
                comment=""
            fi
            
            # Convert and write the export
            converted=$(convert_export "$line")
            echo "$converted" >> "$CONFIG_FILE"
            echo "" >> "$CONFIG_FILE"
        # Process alias lines
        elif [[ "$line" =~ ^alias[[:space:]] ]]; then
            # Write collected comments if any
            if [ -n "$comment" ]; then
                echo -e "$comment" >> "$CONFIG_FILE"
                comment=""
            fi
            
            # Convert and write the alias
            converted=$(convert_alias "$line")
            echo "$converted" >> "$CONFIG_FILE"
            echo "" >> "$CONFIG_FILE"
        else
            # Reset comment collection for non-matching lines
            comment=""
        fi
    done
} < "$BASHRC"

# Fix permissions
chown -R "$ORIGINAL_USER:$ORIGINAL_USER" "$FISH_CONFIG_DIR"

echo "Fish shell setup complete! Please log out and log back in for changes to take effect."
