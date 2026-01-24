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

## 1. Graphics

1. In virt-manager:

   a) Video
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

   Install dependencies:
   ```bash
   sudo pacman -S mesa virt-viewer spice-vdagent
   ```

3. On Windows:

     - Download [virtio-win.iso](https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/latest-virtio/virtio-win.iso)
     - Install `virtio-win-gt-x64` and `virtio-win-guest-tools`

## 2. Shared storage

1. On Arch
   Install dependencies:
   ```bash
   sudo pacman -S virtiofsd
   ```

   Create directory:
   ```bash
   mkdir ~/Windows
   ```

2. In virt-manager:

   a) Enabled shared memory  
     ```xml
     <memory unit="KiB">16777216</memory>
     <currentMemory unit="KiB">16777216</currentMemory>
     <memoryBacking>
       <source type="memfd"/>
       <access mode="shared"/>
     </memoryBacking>
     ```
   b) Add filesystem  
     ```xml
     <filesystem type="mount" accessmode="passthrough">
       <driver type="virtiofs"/>
       <source dir="~/Windows"/>
       <target dir="shared"/>
     </filesystem>
     ```

3. On Windows:  
    a) Download and install [WinSfp](https://winfsp.dev/rel/)  
    b) Open `services.msc` and modify `VirtIO-FS Service`  
    c) Start VirtIO-FS Service  
    d) Change **Startup Type** to **Automatic**  
