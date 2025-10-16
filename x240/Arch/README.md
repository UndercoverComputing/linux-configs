# Thinkpad X240 Arch Linux configuration
## Partitions
- Shared /home partition
- Shared 4GB Linux SWAP partition
- Windows 10, Debian 12, and Arch Linux partitions intact
- Shared 1GB boot partition - all 3 OSes come up on grub

## Problems:
### Fix Chrome password manager:
1. Install dependencies:
   `sudo pacman -S gnome-keyring libsecret`
2. Create this script in `~/.config/sway/scripts/start-keyring.sh`:
   ```
   #!/usr/bin/env bash
   # Start GNOME Keyring
   eval $(/usr/bin/gnome-keyring-daemon --start)
   export SSH_AUTH_SOCK
   export GPG_AGENT_INFO
   ```
3. Make it executable:
   `chmod +x ~/.config/sway/scripts/start-keyring.sh`
4. Call it from Sway config:
   `exec_always --no-startup-id ~/.config/sway/scripts/start-keyring.sh`
