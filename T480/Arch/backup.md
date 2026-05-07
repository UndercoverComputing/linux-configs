# Backup

## Restore these:
```bash
~/.config/alacritty
~/.config/environment.d
~/.config/fish
~/.config/fuzzel
~/.config/gammastep
~/.config/gtk-3.0
~/.config/gtk-4.0
~/.config/gtklock
~/.config/mimeapps.list
~/.config/sway
~/.config/swaync
~/.config/systemd
~/.config/waybar
~/.bashrc
~/.bash_profile
~/Downloads
~/Pictures
~/Videos
/etc/NetworkManager/system-connections/
```

## Backup folder (for syncthing)

1. Create directory:
```bash
mkdir ~/dotbackup
```

2. Create a script that automatically creates symlinks:
`~/.config/sway/scripts/dotbackup.sh`
```bash
#!/bin/bash

DOTBACKUP="$HOME/dotbackup"
CONFIG="$HOME/.config"

mkdir -p "$CONFIG"

link_item () {
    name="$1"
    src="$DOTBACKUP/$name"
    dest="$CONFIG/$name"

    # If source exists > ensure symlink exists
    if [ -e "$src" ]; then
        rm -rf "$dest"
        ln -s "$src" "$dest"
        echo "linked $name"
    else
        # If source is gone > remove symlink if it exists
        if [ -L "$dest" ]; then
            rm -f "$dest"
            echo "removed symlink $name (missing source)"
        fi
    fi
}

# initial sync (create + clean broken links)
for item in "$CONFIG"/*; do
    name=$(basename "$item")
    link_item "$name"
done

# also ensure dotbackup items are linked
for item in "$DOTBACKUP"/*; do
    [ -e "$item" ] || continue
    link_item "$(basename "$item")"
done

# watch for changes (create/update/delete)
inotifywait -m \
    -e create \
    -e moved_to \
    -e modify \
    -e delete \
    "$DOTBACKUP" |
while read -r path event file; do
    link_item "$file"
done
```

3. Add to sway config:
```ini
exec --no-startup-id ~/.config/sway/scripts/dotbackup.sh
```

4. Move config files into the directory. Example:
```bash
mv ~/.config/alacritty ~/dotbackup
```
