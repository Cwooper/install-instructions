# Current Install Instructions

Cooper Morgan
05/03/2024

## Notes

- This program assumes that you have already added:
`deb http://deb.debian.org/debian/ bookworm main contrib non-free non-free-firmware`
to your `/etc/apt/sources.list`.

- Finish installing [WWU VPN](https://support.cs.wwu.edu/home/access/wwu_vpn/linux_bsd/wwu_nm.html).
Install the config file here: <https://support.cs.wwu.edu/_downloads/7ad3a095a821c8ce0ce5e847bc57b48a/CSCI-VPN.ovpn>

- Add SSH key from WWU

- Remember to add
`export PAGER=most`
to `~/.bashrc`

- Reboot the system after installing packages

## Manual App Installs

- vscode
- discord
- spotify
- chrome
- godot

## Current directory tree

```tree
home/cwooper
├── 305
├── 347
└── vault
    ├── schedule-optimizer
    ├── srg-synvis
    └── install-instructions
        ├── install_packages.sh
        ├── packages.txt
        └── tree.md
```

## Current Directories

git clone

<https://github.com/Cwooper/305>

<https://gitlab.cs.wwu.edu/gibbonj9/csci347_s24>

`mkdir vault`

`cd vault`

git clone

<https://github.com/Cwooper/install-instructions>

<https://github.com/Cwooper/schedule-optimizer>

<https://github.com/cs-wwu/srg-synvis>

## First Time Boot Debian

Select recovery mode. Press `e`for edit settings, Add `nomodeset` on `linux` line.

- `systemctl start NetworkManager`
- add `main contrib non-free` to `sources.list`
- `apt update`
- `apt -y install nvidia-driver`
- `apt -y install openrazer_daemon`
- `gpasswd -a cwooper plugdev`
- `reboot -f`

Setup

- `su`, `sudo visudo`
- add `cwooper` to sudo group
- `sudo apt install git`
- Manually install apps
- Run `./install_packages.sh` for package installations.
- `sudo reboot -f`

Customization

- Set all to dark mode
- `nano ~/.bashrc`
- add `export PAGER=most` and save
- open `tweaks` to turn off mouse acceleration
- enable `Dash to Dock` extension and customize
- Sign-in to every thing
- Install WWU VPN
