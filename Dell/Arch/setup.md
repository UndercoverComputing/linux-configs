# Arch Setup:

### Yay
```bash
mkdir -p ~/repos/AUR/
cd ~/repos/AUR
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

### Applications
```bash
sudo pacman -S firefox man smartmontools dpkg nm-connection-editor fastfetch rsync kdiskmark
yay -S brave-bin google-chrome modrinth-app-bin visual-studio-code-bin
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
sudo pacman -S pipewire pipewire-pulse pavucontrol
sudo reboot
```

### Flatpak:
```bash
sudo pacman -S flatpak
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
sudo pacman -S lm_sensors
sudo sensors-detect
```

### powertop
```bash
sudo pacman -S powertop
sudo powertop
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
