#!/bin/bash
# Script to set up fish shell

set -e

# Install fish shell
echo "Installing fish shell..."
apt install -y fish

# Check if fish is already in /etc/shells
if ! grep -q "^/usr/bin/fish$" /etc/shells; then
    echo "Adding fish to /etc/shells..."
    echo "/usr/bin/fish" >> /etc/shells
fi

# Set fish as default shell for the real user
echo "Changing default shell to fish for user $REAL_USER..."
chsh -s /usr/bin/fish "$REAL_USER"

# Create fish config directory
FISH_CONFIG_DIR="$HOME_DIR/.config/fish"
mkdir -p "$FISH_CONFIG_DIR"

# Create minimal fish config
echo "# Fish configuration
set fish_greeting  # Disable greeting
set -x EDITOR vim" > "$FISH_CONFIG_DIR/config.fish"

# Fix permissions
chown -R "$REAL_USER:$REAL_USER" "$FISH_CONFIG_DIR"

echo "Fish shell setup complete."
