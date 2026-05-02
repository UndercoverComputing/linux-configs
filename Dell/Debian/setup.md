# Debian Setup:

### Applications
```bash
sudo apt update
sudo apt install man smartmontools dpkg nm-connection-editor fastfetch rsync kdiskmark ntfs-3g flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
sudo reboot
```

### Firefox

```bash
flatpak install flathub org.mozilla.firefox
```

### Brave

```bash
curl -fsS https://dl.brave.com/install.sh | sh
```

### Google Chrome

```bash
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb
```

### Visual Studio Code

```bash
sudo apt install software-properties-common apt-transport-https curl

curl -sSL https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -

echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list

sudo apt update
sudo apt install code
```

### Plymouth splash
1. Install plymouth
   ```bash
   sudo pacman -S plymouth
   ```
2. Clone a repo
   ```bash
   git clone https://github.com/gevera/plymouth_themes
   cd plymouth_themes/dell
   ```
3. Copy to Plymouth themes
   ```bash
   sudo cp -vr dell10 /usr/share/plymouth/themes/
   ```
4. Add `plymouth` to mkinitcpio HOOKS:
   Edit `/etc/mkinitcpio.conf`:
   ```conf
   HOOKS=(base systemd plymouth autodetect microcode modconf kms keyboard keymap sd-vconsole block sd-encrypt filesystems fsck)
   ```
   Update initramfs:
   ```bash
   sudo mkinitcpio -P
   ```

### Disable power button
1. Edit `/etc/systemd/logind.conf`
   ```bash
   sudo nano /etc/systemd/logind.conf
   ```
3. Uncomment `HandlePowerKey` and set it to ignore
   ```bash
   HandlePowerKey=ignore
   ```

### Audio
```bash
sudo apt install pipewire pipewire-pulse pavucontrol
sudo reboot
```

### NVIDIA Drivers
```bash
sudo pacman -S --needed linux-lts-headers
sudo pacman -S --needed nvidia-dkms nvidia-utils nvidia-settings nvidia-prime
sudo mkinitcpio -P
sudo reboot
```

### lm_sensors
```bash
sudo apt install lm-sensors
sudo sensors-detect
```

### Portal
1. Install `xdg`
```bash
sudo pacman -S xdg-utils xdg-desktop-portal-wlr xdg-desktop-portal xdg-desktop-portal-gtk
```

2. Create a file called `~/.config/mimeapps.list`
```conf
[Default Applications]
text/plain=code.desktop
inode/directory=thunar.desktop
image/png=imv.desktop
application/pdf=firefox.desktop
x-scheme-handler/http=firefox.desktop
x-scheme-handler/https=firefox.desktop
```
[View full file](https://raw.githubusercontent.com/UndercoverComputing/linux-configs/refs/heads/main/Dell/Arch/.config/mimeapps.list)

### Wine
Install Wine:
```bash
sudo pacman -Syu wine
```

### SMB:
Install `gvfs-smb`
```bash
sudo pacman -S gvfs-smb
```

In Thunar, open `smb://xxx.xxx.xxx.xxx/`

### Windows VM
[Instruction link](https://github.com/UndercoverComputing/linux-configs/blob/main/Dell/Arch/Windows-VM.md)

### Modrinth
1. Install FUSE: `sudo pacman -S fuse`
2. Edit the Modrinth desktop entry `/usr/share/applications/modrinth-app.desktop` and add `prime-run ` before `modrinth-app` in the `Exec` line.

## Setup Debian

Next steps: setup.md