# Backup notes

## USB:

**Mount:**

```bash
sudo mount -o uid=XXXX,gid=XXX,umask=022 /dev/sdX1 /mnt/usb
```

Replace `1000` with your user id and `984` with the group id.

**Confirm:**

```bash
ls -ld /mnt/usb
touch /mnt/usb/test && rm /mnt/usb/test
```

You should see:

```bash
user group
```

**Copy everything:**

```bash
rsync -a --progress \
~/Documents \
~/Downloads \
~/Pictures \
~/Videos \
~/.config \
/mnt/usb/
```
