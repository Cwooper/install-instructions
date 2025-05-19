#!/bin/bash
# Script to set up Git global configuration

set -e

# Set Git global configuration for the real user
echo "Setting up Git configuration..."
sudo -u "$REAL_USER" git config --global user.name "Cwooper"
sudo -u "$REAL_USER" git config --global user.email "cwooperm@gmail.com"
sudo -u "$REAL_USER" git config --global core.editor "vim"

echo "Git configuration complete."
