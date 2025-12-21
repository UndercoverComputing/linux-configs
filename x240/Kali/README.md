# Kali

## Partitions:

Refer to https://www.youtube.com/watch?v=8N9jKWm-cKY

### Layout:

```pgsql
/dev/sda
├─ sda1  EFI System Partition  #  1.0GB  (Windows, Arch, Kali share this)
├─ sda2  MSR                   #  16.8MB   (Windows only – do not touch)
├─ sda3  NTFS                  #  68.7GB   (Windows C:)
├─ sda4  LUKS                  #  170.3GB  (Linux everything)
     └─ LVM VG: cryptroot
        ├─ swap     # 8GB (shared swap)
        ├─ home     # 80GB (shared /home)
        ├─ kali     # 41GB (Kali root /)
        └─ home     # 41GB (Arch root /)
```

### Create encrypted volume:

1. Choose **Configure encrypted volumes**
2. Agree to write any changes to the partition table
3. Choose **Create encrypted volumes**
4. Select the free space: **/dev/sda free #2** in this case.
5. Give it the name "cryptroot"
6. Agree to write any changes to the partition table
7. Choose "Finish"
8. Choose **Yes** to overwrite the partition

### Configure the Logical Volume Manager

1. Choose **Configure the Logical Volume Manager**
2. Agree to write any changes to the partition table
3. Select **Create volume group**
4. Give it the name `crypt`
5. Select **/dev/mapper/sda4_crypt**
6. Agree to write any changes to the partition table

**Do the below for `swap`, `home`, `kali`, and `arch`:**
1. Select **Create logical volume**
2. Choose `crypt`
3. Give it a name and allocate a size
4. Repeat

When done, choose **Finish**.

### Setup partitions/volumes

- **Windows EFI partition**  
  Use as: `EFI System Partition`  
  Bootable flag: `on`  

- **LV arch**  
  Use as: `do not use`  

- **LV kali**  
  Use as: `Ext4`  
  Moint point: `/`  
  Label: `Kali`  

- **LV swap**  
  Use as: `swap area`  

- **LV home**  
  Use as: `Ext4`  
  Mount point: `/home`  
  Label: `home`  

Once complete, scroll down and select **Finish partitioning and write changes to disk**
