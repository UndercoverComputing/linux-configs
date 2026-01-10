```bash
cryptsetup open /dev/nvme0n1p6 cryptroot
mount /dev/mapper/cryptroot /mnt
mount /dev/nvme0n1p5 /mnt/boot
```