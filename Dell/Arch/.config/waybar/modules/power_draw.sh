#!/bin/bash

BAT="/sys/class/power_supply/BAT0"
AC="/sys/class/power_supply/AC"

current=$(cat "$BAT/current_now")
voltage=$(cat "$BAT/voltage_now")
power_w=$(awk "BEGIN {printf \"%.2f\", ($current/1000000) * ($voltage/1000000)}")

ac_online=$(cat "$AC/online")

if [ "$ac_online" -eq 1 ]; then
    icon="⚡"
else
    icon="🔋"
fi

echo "$icon ${power_w}W"
