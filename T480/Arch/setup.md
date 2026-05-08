# Arch Setup:

## Firmware updates

1. Install required packages:
```bash
sudo pacman -S fwupd fwupd-efi shim
```

2. Sign fwupd:
```bash
sudo sbctl sign -s /usr/lib/fwupd/efi/fwupdx64.efi
sudo cp /usr/lib/fwupd/efi/fwupdx64.efi /usr/lib/fwupd/efi/fwupdx64.efi.signed
```

3. Sign shim:
```bash
pacman -Ql shim | grep -i efi
sudo cp /usr/share/shim/shimx64.efi /boot/EFI/systemd/shimx64.efi
sudo sbctl sign -s /boot/EFI/systemd/shimx64.efi
```

4. Check for updates:
```bash
sudo fwupdmgr get-updates
sudo fwupdmgr update
```

**Do NOT update Embedded Controller (EC)**.

## Disable power button
1. Edit `/etc/systemd/logind.conf`
   ```bash
   sudo nano /etc/systemd/logind.conf
   ```
3. Uncomment `HandlePowerKey` and set it to ignore
   ```bash
   HandlePowerKey=ignore
   ```

## Fish
```bash
sudo pacman -S fish
fish
```

bash profile instructions

## Applications
```bash
sudo pacman -S firefox man smartmontools dpkg fastfetch rsync kdiskmark ntfs-3g remmina freerdp btop stress flatpak hwinfo
yay -S brave-bin google-chrome modrinth-app-bin visual-studio-code-bin ipscan-bin jre25-openjdk
reboot
```

## Power / battery settings

1. Install TLP:
```bash
sudo pacman -S tlp
```

2. Enable TLP:
```bash
sudo systemctl enable --now tlp.service
```

3. Configure TLP:
```bash
sudo mv /etc/tlp.conf /etc/tlp.conf.bak
```

4. Create `/etc/tlp.conf` and add these lines:
```ini
# Charing thresholds
START_CHARGE_THRESH_BAT0=10
STOP_CHARGE_THRESH_BAT0=90
START_CHARGE_THRESH_BAT1=5
STOP_CHARGE_THRESH_BAT1=95

# other stuff
CPU_SCALING_GOVERNOR_ON_BAT=powersave
CPU_ENERGY_PERF_POLICY_ON_BAT=balance_power
USB_AUTOSUSPEND=1
```

5. Apply changes:
```bash
sudo tlp start
```

Check status with `sudo tlp-stat -b`.

## Fingerprint reader

1. Install open-fprintd and python-validity
```bash
yay -S open-fprintd python-validity
```

2. Start service:
```bash
sudo systemctl enable python3-validity 
sudo systemctl start python3-validity
sudo fprintd-delete USER_NAME
```

3. Get the device id with this bash script:
```bash
# Find exactly device ID
for device in /sys/bus/usb/devices/*; do
    if [ -f "$device/idVendor" ]; then
        vendor=$(cat "$device/idVendor" 2>/dev/null)
        product=$(cat "$device/idProduct" 2>/dev/null)
        if [ "$vendor" = "06cb" ] && [ "$product" = "009a" ]; then
            echo "Device found in: $(basename $device)"
            echo "Full path: $device"
        fi
    fi
done
```

4. Use the device id in this command, for example `1-9`.
```bash
echo 'on' | sudo tee /sys/bus/usb/devices/1-9/power/control
```

5. Enroll your **right index finger**:
```bash
fprintd-enroll
```

6. Modify `/etc/pam.d/sudo` and add these lines to the top:
```ini
auth sufficient pam_unix.so try_first_pass likeauth nullok
auth sufficient pam_fprintd.so timout=5
```

Now, when you run a `sudo` command, it will prompt for a password.
a) If you **type a password**, it authenticates immediately.
b) If you **press Enter** with a blank password, it will then trigger the fingerprint reader.

## Plymouth splash
1. Install plymouth
```bash
sudo pacman -S plymouth
```
2. Clone a repo
```bash
git clone https://github.com/gevera/plymouth_themes
cd plymouth_themes/thinkpad
```
3. Copy to Plymouth themes
```bash
sudo cp -vr think10 /usr/share/plymouth/themes/
```
4. Add `plymouth` to mkinitcpio HOOKS:
Edit `/etc/mkinitcpio.conf`:
```conf
HOOKS=(base systemd plymouth autodetect microcode modconf kms keyboard keymap sd-vconsole block sd-encrypt filesystems fsck)
```
Update initramfs:
```bash
sudo mkinitcpio -P
```

5. Add kernel perameters:
Edit `/boot/loader/entries/arch.conf` and add these to the end:
```conf
quiet loglevel=0 rd.systemd.show_status=auto rd.udev.log_priority=0 vt.global_cursor_default=0 splash
```

## lm_sensors
```bash
sudo pacman -S lm_sensors
sudo sensors-detect
```

## Wine
Install Wine:
```bash
sudo pacman -S wine winetricks zenity
winetricks corefonts
winetricks fontsmooth-rgb
```

## SMB:
Install `gvfs-smb`
```bash
sudo pacman -S gvfs-smb
```

In Thunar, open `smb://xxx.xxx.xxx.xxx/`

## Steam

Enable mirror:
```bash
sudo nano /etc/pacman.conf
```

Uncomment these **2 lines**:
```conf
[multilib]
Include = /etc/pacman.d/mirrorlist
```

Then install:
```bash
sudo pacman -Syu steam vulkan-intel lib32-vulkan-intel mesa lib32-mesa
```

## Powertop
```bash
sudo pacman -S powertop
sudo powertop
```