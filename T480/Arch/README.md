# Thinkpad T480
## Goals:
- Boot Windows 11 and Arch
- BitLocker on Windows
- Disk encryption on Arch
- Working secure boot
- Full support with T480 features (fingerprint reader, etc)

# Installation

## Step 1 - Windows:

**Ensure `Secure Boot` is disabled.**

### Install Windows:
1. Install Windows 11:
    - Run the installer  
    - Create a partition of 64GB  
    - Install
2. Update

## Step 2 - Arch ISO

```bash
pacman -Sy
pacman -S archlinux-keyring
```

### 1. Create partitions

```bash
cfdisk /dev/nvme0n1
```

Create a second EFI partition:
* Size: **1G**
* Type: **EFI System**

Create a partition using all the free space:
* Type: **Linux Filesystem**

1. Select `[ Write ]`
2. Type "yes" and press enter
3. Select `[ Quit ]`

### 2. Encrypt Arch partition (LUKS2)
```bash
mkfs.fat -F32 /dev/nvme0n1p5
cryptsetup luksFormat /dev/nvme0n1p6
cryptsetup open /dev/nvme0n1p6 cryptroot
mkfs.ext4 /dev/mapper/cryptroot
```

### 3. Mount filesystems
```bash
mount /dev/mapper/cryptroot /mnt
mount --mkdir /dev/nvme0n1p5 /mnt/boot
```

### 4. Install base Arch system
```bash
pacstrap -i /mnt base base-devel linux-lts linux-firmware linux-lts-headers sudo intel-ucode nano git wget bluez bluez-utils networkmanager brightnessctl cryptsetup efibootmgr
```
Generate fstab:
```bash
genfstab -U /mnt >> /mnt/etc/fstab
```
Chroot:
```bash
arch-chroot /mnt
```

### 5. Setup swap space

**Create swapfile:**
```bash
fallocate -l 32G /swapfile
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

### 6. Configure kernel modules
1. `/etc/mkinitcpio.conf` --> Add `sd-encrypt` to HOOKS before `filesystems`.

2. `/etc/mkinitcpio.conf` --> Add `atkbd` to MODULES.

3. Recreate the initramfs image:
```bash
mkinitcpio -P
```

## Step 3 - Basic Arch setup

### Add a user

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
echo "T480" >> /etc/hostname
```

### Enable services
```bash
systemctl enable bluetooth
systemctl enable NetworkManager
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
   options rd.luks.name=<UUID-of-nvme01np6>=cryptroot root=/dev/mapper/cryptroot rw intel_iommu=on iommu=pt
   ```

3. loader.conf:
   ```bash
   nano /boot/loader/loader.conf
   ```
   
    Uncomment `timeout 3`

4. Create EFI entry:
    ```bash
    sudo efibootmgr -c -d /dev/nvme0n1 -p 5 \
    -L "Arch Linux" \
    -l '\EFI\systemd\systemd-bootx64.efi'
    ```

### Exit
Exit chroot by typing `exit` and unmount the partitions with `umount -lR /mnt`. Reboot with `reboot` and boot into Arch.

## Step 4 - BIOS secure boot (Setup Mode)

* Secure Boot: **Enabled**
* Mode: **Setup**

## Step 5 - Sign Arch binaries

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
sudo sbctl sign /boot/vmlinuz-linux-lts
```

### Verify:
```bash
sudo sbctl verify
```

It must show ZERO unsigned files.

Now **reboot** and enter BIOS again.

## Step 6 - BIOS secure boot (Custom mode)

Make sure this is the secure boot state:

* Secure Boot: **Enabled**
* Mode: **Custom**

## Step 7 - Verify secure boot

Boot back into Arch, and run this command to verify secure boot is enabled.

```bash
sudo dmesg | grep -i secure
```

It should output `Secure boot enabled`.

## Step 9 - BitLocker

1. Boot into Windows
2. Enable BitLocker

Rember to backup the BitLocker key.

## Step 10 - Setup Arch

Install `yay`:

```bash
mkdir -p ~/repos/AUR/
cd ~/repos/AUR
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
yay -Syu --sudoloop --save
```

---

Next steps: [Desktop setup](https://github.com/UndercoverComputing/linux-configs/blob/main/T480/Arch/sway.md)

