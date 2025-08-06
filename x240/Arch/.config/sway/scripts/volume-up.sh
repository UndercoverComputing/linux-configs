#!/bin/bash

# Get the current volume percent of the default sink (without the % sign)
current_volume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1 | tr -d '%')

# If volume is already 100 or more, do nothing
if [ "$current_volume" -ge 100 ]; then
  exit 0
fi

# Otherwise increase volume by 5%
pactl set-sink-volume @DEFAULT_SINK@ +5%
