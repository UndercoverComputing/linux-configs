# SwayFX installation

```bash
yay -S swayfx swaylock-effects swayidle wayfreeze-git p7zip-gui sway-launcher-desktop
sudo pacman -S wev gtklock gtklock-powerbar-module ttf-jetbrains-mono-nerd alacritty gammastep fzf ttf-font-awesome debugedit thunar thunar-archive-plugin xarchiver polkit polkit-gnome swaybg waybar xorg-xwayland xdg-utils xdg-desktop-portal-wlr xdg-desktop-portal xdg-desktop-portal-gtk fakeroot mpv imv imagemagick gnome-keyring libsecret grim slurp wl-clipboard cliphist fuzzel wtype wf-recorder jq swayimg mousepad pipewire-jack pipewire pipewire-pulse pavucontrol bc wtype nm-connection-editor swaync qt5ct qt6ct kvantum inotify-tools
```

## Have Sway open on boot

### 1. Create a systemd override:
```bash
sudo mkdir -p /etc/systemd/system/getty@tty1.service.d
sudo nano /etc/systemd/system/getty@tty1.service.d/override.conf
```

### 2. Put this inside:
```ini
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin USER_NAME --noclear %I $TERM
```

### 3. Create the systemd user service

```bash
mkdir -p ~/.config/systemd/user
nano ~/.config/systemd/user/sway.service
```

Paste this:
```ini
[Unit]
Description=Sway Wayland Compositor
Documentation=man:sway(1)
BindsTo=graphical-session.target
After=graphical-session.target

[Service]
Type=simple
ExecStart=/usr/bin/sway
Restart=on-failure
RestartSec=1

# Environment (Wayland + apps)
Environment=QT_QPA_PLATFORM=wayland
Environment=MOZ_ENABLE_WAYLAND=1
Environment=MOZ_WEBRENDER=1
Environment=XDG_SESSION_TYPE=wayland
Environment=XDG_CURRENT_DESKTOP=sway

[Install]
WantedBy=default.target
```

### 4. Enable lingering

This allows user services to run even on TTY login:

```bash
sudo loginctl enable-linger USER_NAME
```

### 5. Enable the service

```bash
systemctl --user daemon-reload
systemctl --user enable sway.service
```

### 6. Reboot

```bash
sudo reboot
```

## Audio
```bash
sudo pacman -S 
sudo reboot
```

## Fingerprint reader for lock screen

1. Modify `/etc/pam.d/swaylock` and replace it with this:
```ini
auth sufficient pam_unix.so try_first_pass nullok
auth sufficient pam_fprintd.so
```

2. Modify `/etc/pam.d/swaylock` and replace it with this:
```ini
auth sufficient pam_unix.so try_first_pass
auth sufficient pam_fprintd.so timeout=10
auth required pam_deny.so

account include system-auth
session include sustem-auth
```

a) If you **type a password**, it authenticates immediately.
b) If you **press Enter** with a blank password, it will then trigger the fingerprint reader.






