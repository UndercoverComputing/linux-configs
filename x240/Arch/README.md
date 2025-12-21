# Thinkpad X240 Arch configuration
## Goals:
- Boot Arch alongside Windows and Kali

# Installation
### First steps:
```
pacman -Sy
pacman -S archlinux-keyring
```

### Open encrypted volume

```bash
cryptsetup open /dev/sda4 cryptroot
vgscan
vgchange -ay
```

Verify:  
`ls /dev/mapper/` should return `crypto-Arch crypto-Kali crypto-SWAP crypto-home cryptroot`

### Verify Kali user ids

**Mount the partitions**

```bash
mount /dev/mapper/crypto-Kali /mnt
mount /dev/mapper/crypto-home /mnt/home
mount /dev/sda1 /mnt/boot
```

**Get the ids**

```bash
arch-chroot /mnt
id kali
```

**Example output:**

```bash
uid=1000(kali) gid=1000(kali) groups=1000(kali),...
```

**Exit safely**

```bash
exit
umount -lR /mnt
```

### Mount Arch

**Format Arch partition**

As the Arch Linux volume was not formatted during the Kali install, do it here.

```bash
mkfs.ext4 -L Arch /dev/mapper/crypto-Arch
```

**Mount the partitions**

```bash
mount /dev/mapper/crypto-Arch /mnt
mount --mkdir /dev/mapper/crypto-home /mnt/home
mount --mkdir /dev/sda1 /mnt/boot
swapon /dev/mapper/crypto-SWAP
```

### Installing the base system
```bash
pacstrap -i /mnt base base-devel linux-lts linux-firmware linux-lts-headers sudo intel-ucode nano git bluez bluez-utils networkmanager brightnessctl lvm2 cryptsetup
```

### Generate File System Table (FSTAB)
```bash
genfstab -U /mnt >> /mnt/etc/fstab
```

### CHROOT To Newley Installed system
```bash
arch-chroot /mnt
```
![alt text](Arch-Chroot-800x144.webp)

### Setup Timezone/Region
```bash
ln -sf /usr/share/zoneinfo/Pacific/Auckland /etc/localtime
sudo timedatectl set-timezone Pacific/Auckland
timedatectl set-ntp true
```

### Setup System Language
```bash
nano /etc/locale.gen
```
Uncomment `en_US.UTF-8 UTF-8`

Generate locale file:
```bash
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
```

### Setup Host Name
```bash
echo "archX240" >> /etc/hostname
```

Change root password with `passwd` then add a new user with this command:
```bash
useradd -u 1000 -g users -G wheel,storage,video,audio -d /home/kali -s /bin/bash USER_NAME
passwd USER_NAME
```

Edit sudo file:
`EDITOR=nano visudo`
Uncomment `%wheel ALL=(ALL:ALL) ALL` and save the changes with CTRL + O and CTRL + X to Exit.

### Configure initramfs for LUKS + LVM

1. `/etc/mkinitcpio.conf` --> Add `sd-encrypt` and `lvm2` to HOOKS before `filesystems`

2. Remove file not found error (https://bbs.archlinux.org/viewtopic.php?id=310236):
```bash
echo "#KEYMAP=us" > /etc/vconsole.conf
```

3. Recreate the initramfs image:
```bash
mkinitcpio -P
```

### Grub installation
1. Install the required services:
   ```bash
   pacman -S grub efibootmgr dosfstools mtools os-prober
   ```

2. Enable OS Prober:
   Scroll to the bottom of `/etc/default/grub` and uncomment `GRUB_DISABLE_OS_PROBER`. 

3. Configure for encryption:
   - `GRUB_CMDLINE_LINUX=""` and replace it with:
     
      ```bash
      GRUB_CMDLINE_LINUX="rd.luks.name=<UUID-of-sda4>:cryptroot root=/dev/mapper/crypto-Arch rw"
      ```

4. Add Kali entry
   `/etc/grub.d/40_custom`
   ```bash
   menuentry "Kali Linux" {
    insmod part_gpt
    insmod fat
    insmod ext2
    insmod luks
    insmod lvm
    set root='hd0,gpt1'
    linux /vmlinuz-linux-lts rd.luks.name=<UUID-of-sda4>:cryptroot root=/dev/mapper/crypto-Kali rw
    initrd /intel-ucode.img /initramfs-linux-lts.img
   }
   ```

5. Save the file and install grub:
   ```bash
   grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=Arch
   grub-mkconfig -o /boot/grub/grub.cfg
   ```

### Enable services
```bash
systemctl enable bluetooth
systemctl enable NetworkManager
```

### Exit
Exit chroot by typing `exit` and unmount the partitions with `umount -lR /mnt`. Reboot with `reboot` and boot into Arch.
