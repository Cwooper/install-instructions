# Current Install Instructions
Cooper Morgan
05/03/2024

## Notes

- This program assumes that you have already added:
`deb http://deb.debian.org/debian/ bookworm main contrib non-free non-free-firmware`
to your `/etc/apt/sources.list`.

- Also make sure to run `sudo gpasswd -a $USER plugdev`
for openrazer driver to take effect

- Finish installing WWU VPN here: 
`https://support.cs.wwu.edu/home/access/wwu_vpn/linux_bsd/wwu_nm.html`

- Remember to add
`export PAGER=most`
to `~/.bashrc`

- Reboot the system after installing packages

## Current directory tree

```
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


https://github.com/Cwooper/305

https://gitlab.cs.wwu.edu/gibbonj9/csci347_s24

`mkdir vault`

`cd vault`

git clone

https://github.com/Cwooper/install-instructions

https://github.com/Cwooper/schedule-optimizer

https://github.com/cs-wwu/srg-synvis
v