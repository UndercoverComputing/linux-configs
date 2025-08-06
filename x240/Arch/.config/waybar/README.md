# Waybar
## Original configuration:
<a href="https://i.imgur.com/Qbj43Uz.png"><img src="https://i.imgur.com/Qbj43Uz.png" title="source: imgur.com" /></a>
[Config and Style](https://github.com/cjbassi/config/tree/master/.config/waybar)

## Setup:
Lots of examples are presented on the Waybar GitHub page https://github.com/Alexays/Waybar/wiki/Examples

The easiest way to start is to find an example and modify it to your needs.

First, create your waybar config directory:

```
mkdir ~/.config/waybar
```

Then, into that directory, download your chosen `config` and `style.css` files.

We need to tell Sway to start using Waybar, so edit your config file:

```
nano ~/.config/sway/config

# Comment out or delete entire bar section
bar {
  (...)
}

# Put this
bar swaybar_command waybar
```

Reload Sway with `Shift + mod + c` to see your new status bar.

## Stuff changed:
### Network status icons:
WiFi icon:
- Red by default
- White when connected to a WiFi network
- Hovering shows the WiFi name
- Pressing opens `nmtui`
Ethernet icon:
- Red by default
- White when connected to a wired network
- Uses a static interface set in ~/.config/waybar/scripts/ethernet-status.sh
Settings icon:
- Red by default
- White when connected to a VPN via Network Manager
- Pressing opens `nm-connection-editor`

## Setup scripts:
1. Make a folder for the scripts: `mkdir -p ~/.config/waybar/scripts`
2. Add the following scripts to the folder: `wifi-status.sh`, `ethernet-status.sh`, `vpn-status.sh`
3. Set your Ethernet interface in `ethernet-status.sh` - replace enp0s25 with your interface. 
