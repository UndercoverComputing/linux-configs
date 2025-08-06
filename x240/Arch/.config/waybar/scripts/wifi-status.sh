#!/bin/bash

SSID=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2)

if [ -n "$SSID" ]; then
    echo "{\"text\": \"  \", \"tooltip\": \"Wi-Fi: $SSID\", \"class\": \"wifi-on\"}"
else
    echo "{\"text\": \"  \", \"tooltip\": \"No Wi-Fi connected\", \"class\": \"wifi-off\"}"
fi
