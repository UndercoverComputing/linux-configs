# SwayFX
## Install SwayFX

```bash
yay -S swayfx swaylock-effects swayidle
sudo pacman -S polkit swaybg waybar xorg-xwayland xdg-utils fakeroot pulseaudio mpv imv
```

You can start the UI manually (don’t do this yet):

```bash
sway
```

---

## Copy Config

```bash
mkdir -p ~/.config/sway
cp /etc/sway/config ~/.config/sway/
```

This lets you make your own changes.

---

## SwayFX-Specific Features

Using a `~/.config/sway/swayfx.conf`

---

### Terminal

Install your preferred terminal emulator (foot, alacritty, whatever you want), I use alacritty:

```bash
sudo pacman -S alacritty
```

Then edit your config file and change the terminal executable

`nano ~/.config/sway/config`
```conf
# Your preferred terminal emulator
set $term alacritty
```

Now you can start `sway` and launch the terminal by pressing `mod + Enter`

I have my terminal windows a bit transparent:


`mkdir ~/.config/alacritty/ && nano ~/.config/alacritty/alacritty.toml`
```conf
[window]
opacity = 0.85
```

Changes should be visible immediately.

### Application launcher

Create a directory for your AUR repos and clone the sway launcher there:

```bash
cd ~/repos/AUR
```

Install `fzf` dependency, then install sway launcher:

```bash
sudo pacman -S fzf ttf-font-awesome debugedit
yay -S sway-launcher-desktop
```

Configure sway to start using that as the launcher:

`nano ~/.config/sway/config`
```conf
set $menu wmenu-run -- # Comment out this line

# Put those lines below the commented out one
for_window [app_id="^launcher$"] floating enable, sticky enable, resize set 30 ppt 60 ppt, border pixel 10
set $menu exec $term --class=launcher -e /usr/bin/sway-launcher-desktop
```

### Lockscreen
**Setup keybinds**

Edit your sway config, the power off/on option will just turn off your display after a longer period. Adjust the times (in seconds) as needed. The last option ensures our computer is locked upon entering suspended state.

`nano ~/.config/sway/config`
```conf
exec swayidle -w \
         timeout 300 'swaylock --config ~/.config/sway/swaylock/config' \
         timeout 600 'swaymsg "output * power off"' resume 'swaymsg "output * power on"' \
         before-sleep 'swaylock --config ~/.config/sway/swaylock/config'
```

Add option for manual locking, in my case, I'm going for `mod + L`, same as on Windows. Add this to the bottom of your `nano ~/.config/sway/config`:

```conf
### Key bindings
# Lock screen
bindsym $mod+l exec swaylock --config ~/.config/sway/swaylock/config 
```

This keystroke collides with another one, so comment them out. Don't worry, you can still change focus with the arrow keys:

`nano ~/.config/sway/config`
```conf
# Comment these out

# Move your focus around
#bindsym $mod+$left focus left
#bindsym $mod+$down focus down
#bindsym $mod+$up focus up
#bindsym $mod+$right focus right
```

Also add a keybind to put the system to sleep:

`nano ~/.config/sway/config`
```conf
# Sleep keybind
bindsym Ctrl+Alt+Delete exec systemctl suspend
```

**Now to setup swaylock**
Install required packages:
```bash
sudo pacman -S swaylock swayidle
yay -S swaylock-effects
```

Create a directory for swaylock:
`mkdir ~/.config/sway/swaylock`

Blur an image:
```bash
sudo pacman -S imagemagick
magick ~/Pictures/Source.png -blur 0x10 ~/Pictures/Destination.png
```

Create a config file with the following contents:
`nano ~/.config/sway/swaylock/config`
```conf
daemonize
show-failed-attempts
clock
image=/Pictures/lock_screen.jpg # Blurred lock screen image
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

### Background

Then change the path in sway's config file:

`nano ~/.config/sway/config`
```conf
### Output configuration
#
# Default wallpaper (more resolutions are available in /usr/share/backgrounds/sway/)
output * bg ~/Pictures/bg.png fill
```

## Setup:

### Invert touchpad scrolling
`~/.config/sway/config`
Add this to `### -- Input configuration --`
```conf
input * {
  natural_scroll enabled
}
```

### PCMan File Manager
```bash
sudo pacman -S pcmanfm
```

### GNOME Keyring
1. Install dependancies: `sudo pacman -S gnome-keyring libsecret`

2. Create `start-keyring.sh`
`nano ~/.config/sway/scripts/start-keyring.sh`
```bash
#!/usr/bin/env bash
# Start GNOME Keyring
eval $(/usr/bin/gnome-keyring-daemon --start)
export SSH_AUTH_SOCK
export GPG_AGENT_INFO
```

### Screenshots
Install dependancies:
```bash
sudo pacman -S grim slurp wl-clipboard
yay -S wayfreeze-git
```

Create config:
`~/.config/sway/scripts/screenshot.sh`
```bash
#!/bin/bash

# Output directory
output_dir="$HOME/Pictures/Screenshots"
mkdir -p "$output_dir"

# Filename in GNOME-style format with 'Sway' prefix
timestamp=$(date +"%Y-%m-%d %H-%M-%S")
outfile="$output_dir/Sway Screenshot from $timestamp.png"

# Freeze the screen, hide cursor, and run screenshot commands
wayfreeze --hide-cursor --after-freeze-cmd "
  region=\$(slurp)
  if [ -z \"\$region\" ]; then
    # Unfreeze if user cancels selection (e.g. presses Escape)
    killall wayfreeze
    exit 0
  fi

  grim -g \"\$region\" \"$outfile\"
  wl-copy < \"$outfile\"
  notify-send 'Screenshot Saved' '$outfile'

  # Always unfreeze after completion
  killall wayfreeze
"
```

### Screen recorder
Install dependancies:
```bash
sudo pacman -S wf-recorder jq swayimg
```

Create scripts:
`~/.config/sway/scripts/record.sh`
```bash
#!/bin/bash

# Output directory
output_dir="$HOME/Videos/Screencasts"
mkdir -p "$output_dir"

# Filename with underscores
timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
outfile="$output_dir/Sway_Screencast_from_${timestamp}.mp4"

# If wf-recorder is already running, exit to avoid duplicates
if pgrep -x wf-recorder > /dev/null; then
  notify-send "Screen Recording" "Already running"
  exit 0
fi

# Select region
region=$(slurp)
if [ -z "$region" ]; then
  notify-send "Screen Recording" "Cancelled"
  exit 0
fi

# Start recording
notify-send "Screen Recording" "Recording started..."
wf-recorder -g "$region" -f "$outfile" -a &
echo $! > /tmp/wf-recorder.pid
```

`~/.config/sway/scripts/stop_record.sh`
```bash
#!/bin/bash

# Gracefully stop wf-recorder
if pgrep -x wf-recorder > /dev/null; then
  pkill -INT -x wf-recorder
  sleep 1  # wait a bit for flush
  outfile=$(ls -t "$HOME/Videos/Screencasts"/Sway_Screencast_from_*.mp4 2>/dev/null | head -n 1)
  if [ -n "$outfile" ]; then
    notify-send "Screen Recording" "Recording saved to $outfile"
  else
    notify-send "Screen Recording" "Recording stopped"
  fi
else
  notify-send "Screen Recording" "No active recording found"
fi
```

### Dark Theme
`~/.config/gtk-3.0/settings.ini`:
```ini
[Settings]
gtk-application-prefer-dark-theme=1
```
```bash
dbus-send --session --dest=org.kde.GtkConfig \
    --type=method_call /GtkConfig org.kde.GtkConfig.setGtkTheme \
    "string:Breeze-dark-gtk"
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
