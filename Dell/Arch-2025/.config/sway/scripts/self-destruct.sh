#!/usr/bin/env bash

# Exit sway safely so we can show the fake destruction in TTY
swaymsg exit &> /dev/null

# Wait a second to let sway exit
sleep 2

# Switch to a TTY (optional)
chvt 2 2>/dev/null || true

# Clear the screen
clear

# Hide cursor
tput civis

# Start fake destruction loop
end=$((SECONDS+15))
while [ $SECONDS -lt $end ]; do
    printf "[%s] ERROR: %s\n" "$(date '+%H:%M:%S')" "$(
        shuf -n1 <<EOF
Kernel panic - not syncing: Attempted to kill init!
Segmentation fault at 0x00000000
systemd[1]: Failed to start user service.
EXT4-fs error (device sda2): ext4_find_entry: inode corrupted
Xorg: Fatal IO error 11 (Resource temporarily unavailable)
Failed to mount /dev/null: Invalid argument
OOM killer activated: killing process sway(1312)
FATAL: unable to recover root filesystem
pacman: database corrupted, reverting to empty state
Arch meltdown initiated: purging /usr
EOF
    )"
    sleep 0.1
done

# Show fake shutdown
for i in {5..1}; do
    echo "Shutting down in $i..."
    sleep 1
done

echo "Power off."
tput cnorm
sleep 1
clear
exit 0