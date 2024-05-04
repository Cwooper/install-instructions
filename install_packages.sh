#!/bin/bash
# Cooper Morgan
# Run this program with sudo
# This will `sudo apt install` all packages in packages.txt

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Check if packages.txt exists
if [ ! -f "packages.txt" ]; then
    echo "packages.txt not found!"
    exit 1
fi

# Check if sources.list exists
sources_list="/etc/apt/sources.list"
if [ ! -f "$sources_list" ]; then
    echo "sources.list not found!"
    exit 1
fi

# Update the OS first
apt update -y

# Read packages from packages.txt and reinstall them
while IFS= read -r line
do
    # Skip empty lines and comment lines
    if [[ -z "$line" || "$line" == \#* ]]; then
        continue
    fi
    
    package=$(echo "$line" | awk '{print $1}') # Extract the package name (in case there are extra parameters)
    
    # Install package silently and check exit status
    apt -qq install -y "$package"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}$package installed successfully.${NC}"
    else
        echo -e "${RED}$package installation failed.${NC}"
    fi
done < "packages.txt"

apt -qq autoremove -y

echo "All packages installed or attempted to install."
