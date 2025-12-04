# SwayFX
## Install SwayFX

```bash
yay -S swayfx
sudo pacman -S polkit swaybg waybar xorg-xwayland xdg-utils fakeroot pulseaudio
```

You can start the UI manually (don’t do this yet):

```bash
swayfx
```

---

## Copy Config

```bash
mkdir -p ~/.config/sway
cp /etc/sway/config ~/.config/sway/
```

This lets you make your own changes.

---

## Terminal

Install your preferred terminal (I use `foot`):

```bash
sudo pacman -S foot
```

Edit your SwayFX config to set it as your terminal:

```conf
# ~/.config/sway/swayfx.conf
set $term foot
```

**Terminal opacity** (example for `foot`):

```bash
mkdir -p ~/.config/foot/
nano ~/.config/foot/foot.ini
```

```ini
[window]
opacity = 0.85
```

---

## Application Launcher

1. Clone and install `sway-launcher-desktop`:

```bash
cd ~/repos/AUR
git clone https://aur.archlinux.org/sway-launcher-desktop.git
cd sway-launcher-desktop
sudo pacman -S fzf ttf-font-awesome debugedit
makepkg -si
```

2. Configure SwayFX to use it:

```conf
# ~/.config/sway/swayfx.conf

# Launcher
for_window [app_id="^launcher$"] floating enable, sticky enable, resize set 30 ppt 60 ppt, border none, opacity 0.75
set $menu exec $term --class=launcher -e /usr/bin/sway-launcher-desktop
```

> `border none` + `opacity 0.75` gives a glassy effect.

---

## Lockscreen

Install lockscreen packages:

```bash
sudo pacman -S swaylock swayidle imagemagick
yay -S swaylock-effects
```

Configure `swayidle` in your SwayFX config:

```conf
exec swayidle -w \
         timeout 300 'swaylock --config ~/.config/sway/swaylock/config' \
         timeout 600 'swaymsg "output * power off"' resume 'swaymsg "output * power on"' \
         before-sleep 'swaylock --config ~/.config/sway/swaylock/config'
```

Add a manual lock keybind:

```conf
# Lock screen (Mod + L)
bindsym $mod+l exec swaylock --config ~/.config/sway/swaylock/config
```

Add sleep keybind:

```conf
bindsym Ctrl+Alt+Delete exec systemctl suspend
```

---

### Swaylock Config Example

`~/.config/sway/swaylock/config`:

```conf
daemonize
show-failed-attempts
clock
image=/home/$USER/Pictures/lock_screen.jpg
font="Inter"

indicator
indicator-radius=100
indicator-thickness=10

ring-color=1793D1
key-hl-color=383c4a
text-color=dde6ed
line-color=100f36

datestr=%a, %B %e
timestr=%I:%M %p
ignore-empty-password
```

---

## Background / Wallpaper

```conf
# ~/.config/sway/swayfx.conf
output * bg ~/Pictures/bg.png fill
```

---

## Input Configuration (Touchpad, etc.)

```conf
input * {
  natural_scroll enabled
}
```

---

## PCMan File Manager

```bash
sudo pacman -S pcmanfm
```

---

## GNOME Keyring

1. Install dependencies:

```bash
sudo pacman -S gnome-keyring libsecret
```

2. Create a start script:

```bash
mkdir -p ~/.config/sway/scripts
nano ~/.config/sway/scripts/start-keyring.sh
```

```bash
#!/usr/bin/env bash
eval $(/usr/bin/gnome-keyring-daemon --start)
export SSH_AUTH_SOCK
export GPG_AGENT_INFO
```

---

## Screenshots

Install dependencies:

```bash
sudo pacman -S grim slurp wl-clipboard
```

Create a screenshot script:

```bash
nano ~/.config/sway/scripts/screenshot.sh
```

```bash
#!/bin/bash
output_dir="$HOME/Pictures/Screenshots"
mkdir -p "$output_dir"
timestamp=$(date +"%Y-%m-%d %H-%M-%S")
outfile="$output_dir/SwayFX Screenshot from $timestamp.png"

wayfreeze --hide-cursor --after-freeze-cmd "
  region=\$(slurp)
  if [ -z \"\$region\" ]; then
    killall wayfreeze
    exit 0
  fi

  grim -g \"\$region\" \"$outfile\"
  wl-copy < \"$outfile\"
  notify-send 'Screenshot Saved' '$outfile'
  killall wayfreeze
"
```

---

## Screen Recorder

Install:

```bash
sudo pacman -S wf-recorder jq swayimg
```

Recording script:

```bash
nano ~/.config/sway/scripts/record.sh
```

```bash
#!/bin/bash
output_dir="$HOME/Videos/Screencasts"
mkdir -p "$output_dir"
timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
outfile="$output_dir/SwayFX_Screencast_${timestamp}.mp4"

if pgrep -x wf-recorder > /dev/null; then
  notify-send "Screen Recording" "Already running"
  exit 0
fi

region=$(slurp)
if [ -z "$region" ]; then
  notify-send "Screen Recording" "Cancelled"
  exit 0
fi

notify-send "Screen Recording" "Recording started..."
wf-recorder -g "$region" -f "$outfile" -a &
echo $! > /tmp/wf-recorder.pid
```

Stop script:

```bash
nano ~/.config/sway/scripts/stop_record.sh
```

```bash
#!/bin/bash
if pgrep -x wf-recorder > /dev/null; then
  pkill -INT -x wf-recorder
  sleep 1
  outfile=$(ls -t "$HOME/Videos/Screencasts"/SwayFX_Screencast_*.mp4 2>/dev/null | head -n 1)
  if [ -n "$outfile" ]; then
    notify-send "Screen Recording" "Saved to $outfile"
  else
    notify-send "Screen Recording" "Stopped"
  fi
else
  notify-send "Screen Recording" "No active recording found"
fi
```

---

## Volume / Brightness Keybinds

```conf
# Volume
bindsym --locked XF86AudioMute exec pactl set-sink-mute @DEFAULT_SINK@ toggle
bindsym --locked XF86AudioLowerVolume exec pactl set-sink-volume @DEFAULT_SINK@ -5%
bindsym --locked XF86AudioRaiseVolume exec pactl set-sink-volume @DEFAULT_SINK@ +5%
bindsym --locked XF86AudioMicMute exec pactl set-source-mute @DEFAULT_SOURCE@ toggle

# Brightness
bindsym --locked XF86MonBrightnessDown exec brightnessctl set 5%-
bindsym --locked XF86MonBrightnessUp exec brightnessctl set 5%+
```

---

## SwayFX-Specific Features (Blur, Shadows, Rounded Corners)

```conf
# ~/.config/sway/swayfx.conf

# Rounded corners
corner_radius 10

# Shadows
shadows enable
shadows_on_csd enable
shadow_color #000000AA
shadow_blur_radius 20

# Blur
blur enable
blur_xray enable
blur_passes 4
blur_radius 4

# Semi-transparent windows (except launcher)
for_window [app_id=".*"] opacity 0.95
for_window [app_id="^launcher$"] floating enable, sticky enable, resize set 30 ppt 60 ppt, border none, opacity 0.75
```

## Main changes:
### Volume control - added volume control via a script (`.config/sway/scripts/volume-up.sh`):
- Increases the volume by 5%, and limits it to 100%
- Decreasing volume works through the normal pactl command
### Extra keybinds:
- Brightness control
- Lock screen
- Extra keybinds to switch desktops

### Get keys:
Use `wev` to find out what a key is.
