#!/bin/bash
# Script to install packages from packages.ini

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES_FILE="$SCRIPT_DIR/../configs/packages.ini"

# Check if packages file exists
if [ ! -f "$PACKAGES_FILE" ]; then
    echo "Error: packages.ini not found at $PACKAGES_FILE"
    exit 1
fi

# Initialize an array to store failed packages
failed_packages=()

# Read packages from packages.ini and install them
while IFS= read -r line; do
    # Skip empty lines and comment lines
    if [[ -z "$line" || "$line" == \#* ]]; then
        continue
    fi
    
    # Extract the package name (first word in the line)
    package=$(echo "$line" | awk '{print $1}')
    
    echo "Installing $package..."
    apt install -y "$package"
    
    if [ $? -ne 0 ]; then
        echo "Warning: $package installation failed."
        failed_packages+=("$package")
    fi
done < "$PACKAGES_FILE"

# Install Discord .deb if it was downloaded
if [ -f "/tmp/discord.deb" ]; then
    echo "Installing Discord..."
    apt install -y /tmp/discord.deb || failed_packages+=("discord")
fi

# Clean up
apt autoremove -y
apt clean

# Report failed packages
if [ ${#failed_packages[@]} -ne 0 ]; then
    echo "The following packages failed to install:"
    for failed_package in "${failed_packages[@]}"; do
        echo "  - $failed_package"
    done
fi

echo "Package installation complete."
