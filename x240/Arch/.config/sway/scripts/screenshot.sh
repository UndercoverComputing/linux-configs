#!/bin/bash

# Output directory
output_dir="$HOME/Pictures/Screenshots"
mkdir -p "$output_dir"

# Filename in GNOME-style format with 'Sway' prefix
timestamp=$(date +"%Y-%m-%d %H-%M-%S")
outfile="$output_dir/Sway Screenshot from $timestamp.png"

# Select area with slurp
region=$(slurp)
[ -z "$region" ] && exit 1

# Capture screenshot
grim -g "$region" "$outfile"

# Copy to clipboard
wl-copy < "$outfile"
