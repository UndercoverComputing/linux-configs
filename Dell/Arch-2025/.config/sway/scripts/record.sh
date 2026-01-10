#!/bin/bash

output_dir="$HOME/Videos/Screencasts"
mkdir -p "$output_dir"

timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
outfile="$output_dir/Sway_Screencast_from_${timestamp}.mp4"

if pgrep -x wf-recorder > /dev/null; then
  notify-send "Screen Recording" "Already running"
  exit 0
fi

region=$(slurp)
if [ -z "$region" ]; then
  notify-send "Screen Recording" "Cancelled"
  exit 0
fi

# Extract coordinates
IFS=',x+' read -r X Y W H <<< "${region//[+x]/,}"

# Create a transparent PNG with a shaded box as overlay indicator
tmp_overlay="/tmp/sway_record_overlay.png"
convert -size "${W}x${H}" xc:none -fill "rgba(255,0,0,0.15)" -draw "rectangle 0,0 $W,$H" "$tmp_overlay"

# Show overlay using swayimg (non-blocking)
swayimg "$tmp_overlay" --geometry "${W}x${H}+${X}+${Y}" --stay-on-top --no-input &
overlay_pid=$!

notify-send "Screen Recording" "Recording started..."
wf-recorder -g "$region" -f "$outfile" -a &
rec_pid=$!

# Save PIDs so stop script can clean up
echo $rec_pid > /tmp/wf-recorder.pid
echo $overlay_pid > /tmp/wf-overlay.pid
