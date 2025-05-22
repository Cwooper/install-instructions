#!/bin/bash
# Main setup script for Debian post-installation

# Set strict error handling
set -e
set -o pipefail

# Variables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="/tmp/debian_setup_$(date +%Y%m%d_%H%M%S).log"
REAL_USER="${SUDO_USER:-$USER}"
HOME_DIR="$(getent passwd "$REAL_USER" | cut -d: -f6)"

# Default options
INSTALL_REPOS=true
INSTALL_PACKAGES=true
SETUP_FISH=true
SETUP_GIT=true

# Function to display help
show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo "Automate the setup of a Debian system."
    echo ""
    echo "Options:"
    echo "  -h, --help                Show this help message and exit"
    echo "  -v, --verbose            Enable verbose output"
    echo "  --no-repos               Skip adding repositories"
    echo "  --no-packages            Skip installing packages"
    echo "  --no-fish                Skip setting up fish shell"
    echo "  --no-git                 Skip Git configuration"
    echo ""
    echo "Examples:"
    echo "  $0                       Run all setup steps"
    echo "  $0 --no-fish             Run all steps except fish shell setup"
    echo ""
}

# Parse command line arguments
parse_args() {
    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            -h|--help)
                show_help
                exit 0
                ;;
            -v|--verbose)
                export VERBOSE=true
                ;;
            --no-repos)
                INSTALL_REPOS=false
                ;;
            --no-packages)
                INSTALL_PACKAGES=false
                ;;
            --no-fish)
                SETUP_FISH=false
                ;;
            --no-git)
                SETUP_GIT=false
                ;;
            *)
                echo "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
        shift
    done
}

# Function to check if we're running as root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root"
        exit 1
    fi
}

# Main script execution
main() {
    # Check if running as root
    check_root
    
    # Parse command line arguments
    parse_args "$@"
    
    # Export user info for subscripts
    export REAL_USER HOME_DIR
    
    # Run setup components
    if [[ "$INSTALL_REPOS" == true ]]; then
        echo "Setting up repositories..."
        "$SCRIPT_DIR/scripts/setup_repos.sh"
    fi
    
    if [[ "$INSTALL_PACKAGES" == true ]]; then
        echo "Installing packages..."
        "$SCRIPT_DIR/scripts/install_packages.sh"
    fi
    
    if [[ "$SETUP_FISH" == true ]]; then
        echo "Setting up fish shell..."
        "$SCRIPT_DIR/scripts/setup_fish.sh"
    fi
    
    if [[ "$SETUP_GIT" == true ]]; then
        echo "Setting up Git..."
        "$SCRIPT_DIR/scripts/setup_git.sh"
    fi
    
    echo "Setup complete! Please reboot your system."
}

# Call the main function with all arguments
main "$@"
