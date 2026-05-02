```bash
cryptsetup open /dev/nvme0n1p6 cryptroot
vgscan
vgchange -ay
mount /dev/mapper/crypt-root /mnt
mount /dev/nvme0n1p5 /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot/efi
swapon /dev/mapper/crypt-swap
```

```bash
for dir in /dev /dev/pts /proc /sys /run; do mount --bind "$dir" "/mnt$dir"; done
mount --bind /etc/resolv.conf /mnt/etc/resolv.conf
mkdir -p /mnt/sys/firmware/efi/efivars
mount -t efivarfs efivarfs /mnt/sys/firmware/efi/efivars
```

```bash
chroot /mnt /bin/bash
```
