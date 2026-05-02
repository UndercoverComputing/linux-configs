# Debian instructions, based off Arch instructions. NOT completed.

---

## Goals:
- Boot Windows 11 and Debian 13
- BitLocker on Windows
- Disk encryption on Debian
- Working secure boot

# Installation
## Step 1 - BIOS:

* Ensure Secure Boot is **disabled**

## Step 2 - Windows:

### Install Windows:
1. Install Windows 11:
    - Run the installer  
    - Create a partition of 64GB  
    - Install
2. Update

### Verify Windows is correct:
From `msinfo32`:
* BIOS Mode: **UEFI**
* Secure Boot State: **Off** (for now)

Ensure there is no BitLocker yet.

That's it for now!

## Step 3 - Debian ISO (UEFI mode)

Boot the Debian 13 installer (netinst).

### 1. Setup Debian

Setup Debian as you normally would, until you reach the disk partitioner. Select the **manual** partitioning method.

### 2. Create EFI partition

- Create a second EFI partition:  
  Size: `1G`  
  Type: `EXT4`  
  Mount point: `/boot`
  Bootable flag: `on`  

### 3. Create encrypted volume:

1. Choose **Configure encrypted volumes**
2. Agree to write any changes to the partition table
3. Choose **Create encrypted volumes**
4. Select the free space: **/dev/nvme0n1 free #2** in this case.
5. Give it the name "cryptroot"
6. Select **Done setting up the partition**
7. Agree to write any changes to the partition table
8. Choose "Finish"
9. Choose **Yes** to fully wipe the partition
10. Enter a secure passphrase

### 4. Configure the Logical Volume Manager:

1. Choose **Configure the Logical Volume Manager**
2. Agree to write any changes to the partition table
3. Select **Create volume group**
4. Give it the name `crypt`
5. Select **/dev/mapper/nvme0n1p6_crypt**

**Do the below for `root` and `swap`:**
1. Select **Create logical volume**
2. Choose `crypt`
3. Give it a name and allocate a size
4. Repeat

When done, choose **Finish**.

### 5. Setup partitions/volumes

- **LV root**  
  Use as: `Ext4`  
  Moint point: `/`  

- **LV swap**  
  Use as: `swap area`  

Once complete, scroll down and select **Finish partitioning and write changes to disk**

### 6. Install base Debian system

During installation:

* Uncheck all desktop environments
* Only select **standard system utilities**

## Step 4 - Debian setup

Check secure boot is enabled:
```bash
sudo dmesg | grep -i secure
```

Login as root and install required packages:
```bash
apt update
apt install sudo git nano curl
```

Add user to sudo:
```bash
usermod -aG sudo username
```

## Step 5 - BitLocker

1. Boot into Windows
2. Enable BitLocker

Remember to backup the BitLocker key

## Step 6 - Setup Debian

Next steps: sway.md