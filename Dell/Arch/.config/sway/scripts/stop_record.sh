#!/bin/bash

if pgrep -x wf-recorder > /dev/null; then
  pkill -INT -x wf-recorder
  sleep 1
  outfile=$(ls -t "$HOME/Videos/Screencasts"/Sway_Screencast_from_*.mp4 2>/dev/null | head -n 1)
  notify-send "Screen Recording" "Recording saved to $outfile"
else
  notify-send "Screen Recording" "No active recording found"
fi

# Kill overlay if still running
if [ -f /tmp/wf-overlay.pid ]; then
  kill "$(cat /tmp/wf-overlay.pid)" 2>/dev/null
  rm /tmp/wf-overlay.pid
fi
