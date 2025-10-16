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
