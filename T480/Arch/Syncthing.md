# Syncthing

## Installation
1. Install:
```bash
sudo pacman -S syncthing
```

2. Enable the service:
```bash
sudo systemctl enable --now syncthing@user
```

## Syncthing setup:
1. Setup authentication:
    a) Go to **Settings** > **GUI**
    b) Set a username and password
    c) Enable **Use HTTPS for GUI**

2. Change connection settings:
    a) Go to **Settings** > **Connections**
    b) Disable **Enable Relaying**

3. Add a device:
    a) Add using the **Device ID**
    b) Use **quick://vpn-ip:22000**

4. Add a folder:
    a) When the folder is sharde, ensure **Ignore Permissions** is checked.