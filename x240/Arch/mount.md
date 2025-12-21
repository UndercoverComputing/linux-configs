```bash
cryptsetup open /dev/sda4 cryptroot
vgscan
vgchange -ay
mount /dev/mapper/crypto-Arch /mnt
mount /dev/mapper/crypto-home /mnt/home
mount /dev/sda1 /mnt/boot
swapon /dev/mapper/crypto-SWAP
```
