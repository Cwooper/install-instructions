# Debian Setup Scripts

A modular approach to automating Debian post-installation setup.

## Structure

```sh
.
├── configs
│   └── packages.ini      # List of packages to install
├── scripts
│   ├── install_packages.sh  # Installs packages from packages.ini
│   ├── setup_fish.sh        # Sets up fish shell
│   ├── setup_git.sh         # Sets up Git configuration
│   └── setup_repos.sh       # Adds repositories
└── setup.sh                 # Main script
```

## Usage

1. First, clone this repository:

   ```sh
   git clone https://github.com/yourusername/debian-setup.git
   cd debian-setup
   ```

2. Make all scripts executable:

   ```sh
   chmod +x setup.sh
   chmod +x scripts/*.sh
   ```

3. Run the setup script as root:

   ```sh
   sudo ./setup.sh
   ```

### Options

The main script supports several options:

- `-h, --help`: Show help message
- `-v, --verbose`: Enable verbose output
- `--no-repos`: Skip adding repositories
- `--no-packages`: Skip installing packages
- `--no-fish`: Skip setting up fish shell
- `--no-git`: Skip Git configuration

Example:

```sh
sudo ./setup.sh --no-fish
```

## Customization

- Edit `configs/packages.ini` to modify the list of packages to install
- Modify individual scripts in the `scripts/` directory to customize their behavior

## Requirements

- Debian 13 (Trixie) or newer
- Root privileges for installation
