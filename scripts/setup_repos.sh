#!/bin/bash
# Script to add repositories

set -e

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Ensure we have necessary tools
if ! command_exists wget || ! command_exists curl; then
    apt update
    apt install -y wget curl
fi

# Chrome repository
echo "Adding Google Chrome repository..."
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor > /etc/apt/trusted.gpg.d/google-chrome.gpg
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list

# VS Code repository
echo "Adding VS Code repository..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/microsoft.gpg
echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list

# Spotify repository
echo "Adding Spotify repository..."
curl -sS https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg | gpg --dearmor > /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" > /etc/apt/sources.list.d/spotify.list

# Discord (download .deb file)
echo "Downloading Discord..."
wget -O /tmp/discord.deb "https://discord.com/api/download?platform=linux&format=deb" || true

# Update package lists
echo "Updating package lists..."
apt update

echo "Repository setup complete."
