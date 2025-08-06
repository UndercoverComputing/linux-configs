#!/bin/bash

if nmcli -t con show --active | grep -q ':vpn'; then
    echo '{"text": "  ", "tooltip": "Open Network Manager", "class": "vpn-on"}'
else
    echo '{"text": "  ", "tooltip": "Open Network Manager", "class": "vpn-off"}'
fi
