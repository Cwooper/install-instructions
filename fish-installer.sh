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
    echo "/usr/bin/fish" >> /etc/shells
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

cat > "$CONFIG_FILE" << 'EOL'
# Remove greeting message
set fish_greeting

# Environment variables
# Go variables
set -x GOPATH $HOME/.go
set -x PATH $PATH $GOPATH/bin
set -x PATH $PATH /usr/local/go/bin

# Zed
set -x PATH $PATH $HOME/.local/bin

# Most man pager
set -x PAGER $(which most)

# Local scripts
set -x PATH $PATH $HOME/.scripts
EOL

# Fix permissions
chown -R "$ORIGINAL_USER:$ORIGINAL_USER" "$FISH_CONFIG_DIR"

echo "Fish shell setup complete! Please log out and log back in for changes to take effect."
