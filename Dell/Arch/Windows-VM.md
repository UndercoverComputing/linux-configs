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
