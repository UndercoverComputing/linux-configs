# Precision 5540
## Goals:
- Boot Windows and Arch
- Shared exFAT partition for sharing files

# Installation
### First steps:
```
pacman -Sy
pacman -S archlinux-keyring
```

### Partitioning the drive:
**512GB SSD**
- I had to reinstall Windows, and shrunk it to around 160GB because the partitions were messy.

After that, I had these partitions:
```bash
/dev/nvme0n1p1 - 100M EFI System
/dev/nvme0n1p2 - 16M Microsoft reserved
/dev/nvme0n1p3 - 160.9G Microsoft basic data
/dev/nvme0n1p4 - 509M Windows recovery environment
```
- I created the following Linux partitions:
```bash
/dev/nvme0n1p5 - 1G EFI System
/dev/nvme0n1p6 - 16G Linux swap
/dev/nvme0n1p7 - 200G Linux filesystem (/home)
/dev/nvme0n1p8 - 98G Linux filesystem (Arch root)
```
- Formatting the partitions:
```bash
mkfs.fat -F32 -n EFI /dev/nvme0n1p5
mkswap -L swap /dev/nvme0n1p6
mkfs.ext4 -L home /dev/nvme0n1p7
mkfs.ext4 -L Arch /dev/nvme0n1p8
```
- Mounting the partitions:
```bash
mount /dev/nvme0n1p8 /mnt
mkdir /mnt/boot /mnt/home
mount /dev/nvme0n1p5 /mnt/boot
mount /dev/nvme0n1p7 /mnt/home
swapon /dev/nvme0n1p6
```
### Installing the base system
```bash
pacstrap -i /mnt base base-devel linux-lts linux-firmware linux-lts-headers sudo intel-ucode nano git bluez bluez-utils networkmanager brightnessctl
```

### Generate File System Table (FSTAB)
```bash
genfstab -U /mnt >> /mnt/etc/fstab
```

- Reminder that Windows will not show up when first installing GRUB.

### CHROOT To Newley Installed system
```bash
arch-chroot /mnt
```
![alt text](Arch-Chroot-800x144.webp)

Change root password with `passwd` then add a new user with this command:
```bash
useradd -m -g users -G wheel,storage,video,audio -s /bin/bash USER_NAME
passwd USER_NAME
```

Edit sudo file:
`EDITOR=nano visudo`
Uncomment `%wheel ALL=(ALL:ALL) ALL` and save the changes with CTRL + O and CTRL + X to Exit.

### Setup Timezone/Region
```bash
ln -sf /usr/share/zoneinfo/Pacific/Auckland /etc/localtime
hwclock --systohc
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
echo "Precision5540" >> /etc/hostname
```

### Grub-Installation
Install the required services:
```bash
pacman -S grub efibootmgr dosfstools mtools os-prober
```
Enable OS Prober:
Scroll to the bottom of `/etc/default/grub` and uncomment `GRUB_DISABLE_OS_PROBER`. Save the file and update grub:
```bash
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
```
- OS Prober may not find Windows. Instructions below.

### Enable services
```bash
systemctl enable bluetooth
systemctl enable NetworkManager
```

### Exit
Exit chroot by typing `exit` and unmount the partitions with `umount -lR /mnt`

## Add Windows to GRUB:
### Option 1: OS Prober
Install the required services:
```bash
pacman -S grub efibootmgr dosfstools mtools os-prober
```
Enable OS Prober:
Scroll to the bottom of `/etc/default/grub` and uncomment `GRUB_DISABLE_OS_PROBER`. Save the file and update grub:
```bash
grub-mkconfig -o /boot/grub/grub.cfg
```

### Option 2 (if option 1 doesn't work)
Enable OS Prober:
Scroll to the bottom of `/etc/default/grub` and comment `GRUB_DISABLE_OS_PROBER`. Save the file and update grub.

Edit `/etc/grub.d/40_custom` and add this at the bottom:
```conf
menuentry "Windows Boot Manager" {
    insmod part_gpt
    insmod fat
    search --no-floppy --fs-uuid --set=root A65D-C69F # Windows EFI Partition (usually 100M)
    chainloader /EFI/Microsoft/Boot/bootmgfw.efi
}
```
And update GRUB:
```bash
grub-mkconfig -o /boot/grub/grub.cfg
```

## Arch Setup:

### Flatpak:
```bash
sudo pacman -S flatpak
sudo reboot
```

### Yay
```bash
mkdir -p ~/repos/AUR/
cd ~/repos/AUR
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```
