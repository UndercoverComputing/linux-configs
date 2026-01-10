#!/bin/bash

BAT="/sys/class/power_supply/BAT0"
AC="/sys/class/power_supply/AC"

# Read battery info
capacity=$(cat "$BAT/capacity")
status=$(cat "$BAT/status")   # Charging / Discharging / Full
current=$(cat "$BAT/current_now")
voltage=$(cat "$BAT/voltage_now")
power_w=$(awk "BEGIN {printf \"%.2f\", ($current/1000000) * ($voltage/1000000)}")

# Determine battery icon
if [[ "$status" == "Charging" ]]; then
    # Charging icons (battery-charging-10 .. battery-charging-100)
    if (( capacity <= 10 )); then icon="󰢜";
    elif (( capacity <= 20 )); then icon="󰂆";
    elif (( capacity <= 30 )); then icon="󰂇";
    elif (( capacity <= 40 )); then icon="󰂈";
    elif (( capacity <= 50 )); then icon="󰢝";
    elif (( capacity <= 60 )); then icon="󰂉";
    elif (( capacity <= 70 )); then icon="󰢞";
    elif (( capacity <= 80 )); then icon="󰂊";
    elif (( capacity <= 90 )); then icon="󰂋";
    else icon="󰂅"; fi
else
    # Discharging / Full icons (battery-empty .. battery-full)
    if (( capacity <= 10 )); then icon="󰁺";      # battery-empty
    elif (( capacity <= 20 )); then icon="󰁻";    # battery-10
    elif (( capacity <= 30 )); then icon="󰁼";    # battery-20
    elif (( capacity <= 40 )); then icon="󰁽";    # battery-30
    elif (( capacity <= 50 )); then icon="󰁾";    # battery-40
    elif (( capacity <= 60 )); then icon="󰁿";    # battery-50
    elif (( capacity <= 70 )); then icon="󰂀";    # battery-60
    elif (( capacity <= 80 )); then icon="󰂁";    # battery-70
    elif (( capacity <= 90 )); then icon="󰂂";    # battery-80
    else icon="󰁹"; fi                             # battery-100
fi

# Print formatted output
echo "$icon ${capacity}% (${power_w}W)"
