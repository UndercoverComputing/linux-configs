# Waybar
## Example config: 🤖 [mechabar](https://github.com/sejjy/mechabar)
![Social Preview](https://raw.githubusercontent.com/sejjy/mechabar/main/.github/assets/catppuccin-mocha.png)

## Installation
1. Remove old directory (if there is one):
	```bash
	rm -rf ~/.config/waybar
	```
2. Clone the repository:
	```bash
	git clone https://github.com/sejjy/mechabar.git ~/.config/waybar
	```

3. Run the [install](https://github.com/sejjy/mechabar/blob/main/install.sh) script:
	```bash
	~/.config/waybar/install.sh
	```

> [! IMPORTANT]
> I had a problem with the install script where it failed to install some audio packages. I had to remove pulseaudio and some other stuff, and install pipewire

### Sway config:
Comment out the existing `bar` section, and put this instead:
```conf
bar swaybar_command waybar
```

### Install fonts:
```bash
sudo pacman -S ttf-jetbrains-mono-nerd
```

Modify sway config:
```conf
font pango:JetBrainsMono Nerd Font Mono 9
```

### Network configurator
  1. `sudo pacman -S nm-connection-editor`
  2. Edit waybar so that: pressing the Network icon opens nmtui, and pressing the vpn icon opens nm-connection-editor.

### Modify waybar config
I had to make **alot** of changes to the waybar config. Custom VPN module, css changes, converted hyprland modules to sway modules, changed termperature sensor, etc. Updated changes on my github.
