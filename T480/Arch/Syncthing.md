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
    a) When the folder is shared, ensure **Ignore Permissions** is checked.

## Backup dotfiles

### Linux:

1. Create a shared folder and change the **Folder Type** to **Send Only**.

### Windows:

1. Add the folder
2. Change the **Folder Type** to **Recieve Only**.
3. Use **Staggered File Versioning**.
