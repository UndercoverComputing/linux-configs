# Sway
## Install Sway:

```
pacman -S sway polkit swaybg waybar xorg-xwayland xdg-utils fakeroot pulseaudio
```

You can start the UI manually with (but don't do that yet):

```
sway
```

Copy `config` file to your user's directory so you can enable your own changes:

```
mkdir .config/sway
cp /etc/sway/config .config/sway/
```

### Terminal

Install your preffered terminal emulator (foot, alacritty, whatever you want), I use alacritty:

```
pacman -S alacritty
```

Then edit your config file and change terminal executable

`nano ~/.config/sway/config`
```
# Your preferred terminal emulator
set $term alacritty
```

Now you can start `sway` and launch terminal by pressing `mod + Enter`

I have my terminal windows a bit transparent:


`mkdir ~/.config/alacritty/ && nano ~/.config/alacritty/alacritty.toml`
```
[window]
opacity = 0.85
```

Changes should be visible immediately.

### Popup command window

Create direcotory for your AUR repos and clone sway launcher there:

```
mkdir -p ~/repos/AUR/
cd ~/repos/AUR
git clone https://aur.archlinux.org/sway-launcher-desktop.git
```

Install `fzf` dependency and font-awesome for icons, then build and install sway launcher:

```
cd sway-launcher-desktop
pacman -S fzf ttf-font-awesome debugedit
makepkg --install
```

Configure sway to start using that as our launcher:


`nano ~/.config/sway/config`
```
set $menu dmenu_path | dmenu | xargs swaymsg exec -- # Comment out this line

# Put those lines below the commented out one
for_window [app_id="^launcher$"] floating enable, sticky enable, resize set 30 ppt 60 ppt, border pixel 10
set $menu exec $term --class=launcher -e /usr/bin/sway-launcher-desktop

```

### Lockscreen

Install required packages:

```
pacman -S swaylock swayidle
```

Edit your sway config, the power off/on option will just turn off your display after longer period. Adjust the times (in seconds) as needed. The last option ensures our computer is locked upon entering suspended state.

`nano ~/.config/sway/config`
```
exec swayidle -w \
         timeout 300 'swaylock -e -f -i ~/Pictures/lockscreen.jpg' \
         timeout 600 'swaymsg "output * power off"' resume 'swaymsg "output * power on"' \
         before-sleep 'swaylock -e -f -i ~/Pictures/lockscreen.jpg'
```

Add option for manual locking, in my case I'm going for `mod + L`, same as on Windows:


`nano ~/.config/sway/config`
```
### Key bindings
#
# Basics:
#
    # Lock screen
    bindsym $mod+l exec swaylock -e -f -i ~/Pictures/lockscreen.jpg -C ~/.config/swaylock/config
```

This keystroke collides with another one, so comment them out. Don't worry, you can still change focus with arrow keys:

```
nano ~/.config/sway/config

# Comment those out:
#bindsym $mod+$left focus left
#bindsym $mod+$down focus down
#bindsym $mod+$up focus up
#bindsym $mod+$right focus right
```

### Background

Then change the path in sway's config file:

`nano ~/.config/sway/config`
```
### Output configuration
#
# Default wallpaper (more resolutions are available in /usr/share/backgrounds/sway/)
output * bg ~/Pictures/bg.png fill
```

## Main changes:
### Volume control - added volume control via a script (`.config/sway/scripts/volume-up.sh`):
- Increases the volume by 5%, and limits it to 100%
- Decreasing volume works through the normal pactl command
### Extra keybinds:
- Brightness control
- Lock screen
- Extra keybinds to switch desktops
### Swaylock & Swayidle
`nano ~/.config/sway/config`
```
exec swayidle -w \
  timeout 300 'swaylock --config ~/.config/sway/swaylock/config' \
  timeout 600 'swaymsg "output * power off"' resume 'swaymsg "output * power on"' \
  before-sleep 'swaylock --config ~/.config/sway/swaylock/config'
```
Create directory:
```
`mkdir ~/.config/sway/swaylock/`
`nano ~/.config/sway/swaylock/config`
```
[My configuration](https://raw.githubusercontent.com/UndercoverComputing/linux-configs/refs/heads/main/x240/Arch/.config/sway/swaylock/config)
