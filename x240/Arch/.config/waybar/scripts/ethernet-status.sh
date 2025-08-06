#!/bin/bash

# Check if interface enp0s25 is connected
STATE=$(nmcli dev status | awk '$1 == "enp0s25" { print $3 }')

if [ "$STATE" = "connected" ]; then
    echo "{\"text\": \"  \", \"class\": \"eth-on\"}"
else
    echo "{\"text\": \"  \", \"class\": \"eth-off\"}"
fi
