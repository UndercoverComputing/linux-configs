# Precision 5540
## Goals:
- Boot Windows 11 and Arch
- BitLocker on Windows
- Disk encryption on Arch
- Working secure boot

# Installation
## Step 1 - BIOS:

* Ensure Secure Boot is **disabled**

## Step 2 - Windows:

### Install Windows:
1. Install Windows 11:
    - Run the intaller  
    - Create a partition of 64GB  
    - Install
2. Update

### Verify Windows is correct:
From `msinfo32`:
* BIOS Mode: **UEFI**
* Secure Boot State: **Off** (for now)

Ensure there is no BitLocker yet.

That's it for now!

## Step 3 - Arch ISO (UEFI mode)

```bash
pacman -Sy
pacman -S archlinux-keyring
```

### 1. Ensure Arch booted in UEFI:
```bash
ls /sys/firmware/efi/efivars
```

### 2. Create Linux partition

Create a second EFI partition:
* Size: **1G**
* Type: **EFI System**

Create a partition using all the free space:
* Type: **Linux Filesystem**

### 3. Encrypt Arch partition (LUKS2)
```bash
mkfs.fat -F32 -n EFI /dev/nvme0n1p5
cryptsetup luksFormat /dev/nvme0n1p6
cryptsetup open /dev/nvme0n1p6 cryptroot
mkfs.ext4 /dev/mapper/cryptroot
```

### 4. Mount filesystems
```bash
mount /dev/mapper/cryptroot /mnt
mount --mkdir /dev/nvme0n1p5 /mnt/boot
```

### 5. Install base Arch system
```bash
pacstrap -i /mnt base base-devel linux-lts linux-firmware linux-lts-headers sudo intel-ucode nano git bluez bluez-utils networkmanager brightnessctl cryptsetup efibootmgr
```
Generate fstab:
```bash
genfstab -U /mnt >> /mnt/etc/fstab
```
Chroot:
```bash
arch-chroot /mnt
```

### 6. Setup swap space

**Create swapfile:**
```bash
fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
```

**Verify swap:**
```bash
swapon --show
```

**Make persistent:**
1. Open fstab:
    ```bash
    nano /etc/fstab
    ```

2. Add:
    ```
    /swapfile none swap defaults 0 0
    ```

**Tune swappiness:**
1. Create:
    ```bash
    nano /etc/sysctl.d/99-swappiness.conf
    ```

2. Add:
    ```conf
    vm.swappiness=10
    ```

### 7. Configure LUKS boot support
1. `/etc/mkinitcpio.conf` --> Add `sd-encrypt` to HOOKS before `filesystems`

2. Remove file not found error (https://bbs.archlinux.org/viewtopic.php?id=310236):
```bash
echo "#KEYMAP=us" > /etc/vconsole.conf
```

3. Recreate the initramfs image:
```bash
mkinitcpio -P
```

## Step 4 -  Arch setup

Change root password with `passwd` then add a new user:
```bash
passwd
useradd -m -g users -G wheel,storage,video,audio -s /bin/bash USER_NAME
passwd USER_NAME
```

Edit sudo file:
`EDITOR=nano visudo`
Uncomment `%wheel ALL=(ALL:ALL) ALL` and save the changes with CTRL + O and CTRL + X to Exit.

### Setup Timezone/Region
```bash
ln -sf /usr/share/zoneinfo/Pacific/Auckland /etc/localtime
timedatectl set-timezone Pacific/Auckland
timedatectl set-ntp true
```

### Setup System Language
```bash
nano /etc/locale.gen
```
Uncomment `en_US.UTF-8`

Generate locale file:
```bash
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
```

### Setup Host Name
```bash
echo "Precision5540" >> /etc/hostname
```

### Bootloader installation
1. Install systemd-boot:
   ```bash
   bootctl install
   ```

2. Create Arch’s boot entry:
   ```bash
   nano /boot/loader/entries/arch.conf
   ```

   Contents:
   ```conf
   title   Arch Linux
   linux   /vmlinuz-linux-lts
   initrd  /intel-ucode.img
   initrd  /initramfs-linux-lts.img
   options rd.luks.name=<UUID-of-nvme01np6>=cryptroot root=/dev/mapper/cryptroot rw mem_sleep=deep intel_iommu=on iommu=pt quiet loglevel=0 rd.systemd.show_status=auto rd.udev.log_priority=0 vt.global_cursor_default=0 splash
   ```

3. loader.conf:
   ```bash
   nano /boot/loader/loader.conf
   ```
   
   ```conf
   default arch
   timeout 5
   ```

3. Create EFI entry:
    ```bash
    sudo efibootmgr -c -d /dev/nvme0n1 -p 5 \
    -L "Arch Linux" \
    -l '\EFI\systemd\systemd-bootx64.efi'
    ```


### Enable services
```bash
systemctl enable bluetooth
systemctl enable NetworkManager
```

### Exit
Exit chroot by typing `exit` and unmount the partitions with `umount -lR /mnt`. Reboot with `reboot` and boot into Arch.

## Step 5 - BIOS secure booy (Audit Mode)

* Secure Boot: **Enabled**
* Mode: **Audit**

## Step 6 - Sign Arch binaries

Inside Arch, prepare secure boot:

### 1. Install tooling
```bash
sudo pacman -Syu sbctl
```

### 2. Create and enroll keys
```bash
sudo chattr -i /sys/firmware/efi/efivars/*
```

```bash
sudo sbctl create-keys
sudo sbctl enroll-keys -m
```

### 3. Show EFI images
```bash
sudo sbctl verify
```

### 4. Sign all EFI binaries
Sign all the images from the previous command:
```bash
sudo sbctl sign /boot/EFI/BOOT/BOOTX64.EFI
sudo sbctl sign /boot/EFI/systemd/systemd-bootx64.efi
sudo sbctl sign /boot/vmlinuz-linux
sudo sbctl sign /boot/vmlinuz-linux-lts
```

### Verify:
```bash
sudo sbctl verify
```

It must show ZERO unsigned files.

## Step 7 - BIOS secure boot (Deployed)

* Secure Boot: **Enabled**
* Mode: **Deployed**

## Step 8 - Verify secure boot

```bash
sudo dmesg | grep -i secure
```

## Step 9 - BitLocker

1. Boot into Windows
2. Enable BitLocker

Rember to backup the BitLocker key