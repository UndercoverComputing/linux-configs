# Windows VM
## VM Manager
```bash
sudo pacman -S libvirt virt-manager qemu-full dnsmasq dmidecode
sudo systemctl enable --now libvirtd.service virtlogd.service
sudo usermod -aG libvirt $USER
sudo virsh net-autostart default
sudo virsh net-start default
```

Reboot and start it with `virt-manager`

## Graphics

1. In virt-manager:
  a) Video:
    - Change video model to **Virtio**
    - Check the box for **3D acceleration**
  b) Display
    - Go to Display, and make sure Type: **Spice server**
    - Set listen type to **None**
    - Check OpenGL and select the Intel render (the NVIDIA one stops it from starting)
  c) Firmware / CPU
    - Go to Overview -> Firmware, make sure it’s set to UEFI.
    - CPU Mode: Go to Processor -> CPU Model, choose Host-passthrough.

2. On Arch:
   Install dependancies:

   ```bash
   sudo pacman -S mesa virt-viewer spice-vdagent
   ```

3. On Windows:
     - Download [virtio-win.iso ](https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/latest-virtio/)
     - Install virtio-win-guest-tools
