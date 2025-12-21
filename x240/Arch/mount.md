```bash
cryptsetup open /dev/sda4 cryptroot
vgscan
vgchange -ay
mount /dev/mapper/crypt-arch /mnt
mount /dev/mapper/crypt-home /mnt/home
mount /dev/sda1 /mnt/boot
swapon /dev/mapper/crypt-swap
```
