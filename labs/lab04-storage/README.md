# Lab 4 — Partition, mirror, fail, recover

Pair: Amirgali A.+ Kelis A. · Date: 10 November 2026 · Hypervisor: VirtualBox

## Windows

```text
Get-Disk | Select Number, FriendlyName, PartitionStyle, Size

Number FriendlyName   PartitionStyle Size
0      VBOX HARDDISK  GPT           68719476736
1      VBOX HARDDISK  GPT            1073741824

Get-Volume | Where FileSystemLabel -eq 'LAB04'

DriveLetter FileSystemLabel FileSystemType DriveType HealthStatus OperationalStatus SizeRemaining       Size
E           LAB04           NTFS           Fixed     Healthy      OK                    989.98 MB 1007.93 MB
```

The new 1 GB virtual disk is Disk 1, initialized as GPT and formatted as NTFS with the label `LAB04`; Windows assigned it drive letter `E:`. GPT is appropriate for modern UEFI systems and keeps a backup copy of the partition table.

## Linux — layout before

```text
amirgali@lab1:~$ lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS
NAME                      SIZE TYPE FSTYPE      MOUNTPOINTS
loop0                    66.8M loop squashfs   /snap/core24/1643
loop1                     1.5M loop squashfs   /snap/hwctl/123
loop2                     1.5M loop squashfs   /snap/hwctl/131
loop3                    50.1M loop squashfs   /snap/snapd/27710
sda                       25G disk
├─sda1                     1G part vfat        /boot/efi
├─sda2                     2G part ext4        /boot
└─sda3                  21.9G part LVM2_member
  └─ubuntu--vg-ubuntu--lv  11G lvm  ext4        /
sdb                        1G disk
sdc                        1G disk
sdd                        1G disk
sr0                     1024M rom
```

## Linux — layout after

```text
amirgali@lab1:~$ lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS
NAME                      SIZE TYPE FSTYPE            MOUNTPOINTS
loop0                      1.5M loop squashfs         /snap/hwctl/123
loop1                     66.8M loop squashfs         /snap/core24/1643
loop2                     50.1M loop squashfs         /snap/snapd/27710
loop3                      1.5M loop squashfs         /snap/hwctl/131
sda                       25G  disk
├─sda1                     1G  part vfat              /boot/efi
├─sda2                     2G  part ext4              /boot
└─sda3                  21.9G  part LVM2_member
  └─ubuntu--vg-ubuntu--lv 11G lvm  ext4               /
sdb                        1G  disk
└─sdb1                  1022M part linux_raid_member
  └─md0                  1021M raid1 ext4              /mnt/mirror
sdc                        1G  disk
└─sdc1                  1022M part linux_raid_member
sdd                        1G  disk
└─sdd1                  1022M part linux_raid_member
  └─md0                  1021M raid1 ext4              /mnt/mirror
sr0                     1024M rom
```

The RAID 1 array is `/dev/md0`, mounted at `/mnt/mirror`. It was initially created from `/dev/sdb1` and `/dev/sdc1`; after the failure and rebuild, `/dev/sdd1` replaced `/dev/sdc1`.

## What I did

Commands used, in order:

```bash
# Partition the three added virtual disks for RAID
for d in sdb sdc sdd; do sudo parted -s /dev/$d mklabel gpt mkpart primary 1MiB 100% set 1 raid on; done

# Install mdadm and create the RAID 1 mirror
sudo apt install -y mdadm
sudo mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1

# Create filesystem, mount it, and make it writable by the current user
sudo mkfs.ext4 -L mirror /dev/md0
sudo mkdir -p /mnt/mirror
sudo mount /dev/md0 /mnt/mirror
sudo chown $USER: /mnt/mirror

# Create test files (proof line used the student's name and current date)
echo "Lab 4 proof file — Amirgali — $(date)" > /mnt/mirror/proof.txt
head -c 20M /dev/urandom > /mnt/mirror/random.bin

# Save baseline checksums
cd /mnt/mirror && sha256sum proof.txt random.bin

# Simulate one member failure and remove it
sudo mdadm /dev/md0 --fail /dev/sdc1
sudo mdadm /dev/md0 --remove /dev/sdc1

# Verify files/checksums while degraded
cat /mnt/mirror/proof.txt
cd /mnt/mirror && sha256sum proof.txt random.bin

# Add the third partition and rebuild
sudo mdadm /dev/md0 --add /dev/sdd1
cat /proc/mdstat
sudo mdadm --detail /dev/md0

# Register the array for assembly at boot
sudo mdadm --detail --scan | sudo tee -a /etc/mdadm/mdadm.conf
sudo update-initramfs -u

# The array was mounted again for the final layout check
sudo mount /dev/md0 /mnt/mirror
findmnt /mnt/mirror
lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS
```

## Three states

| State | What `/proc/mdstat` showed | Evidence file |
|---|---|---|
| Healthy | `[2/2] [UU]`; `mdadm --detail` showed `State : clean`, two active devices, `/dev/sdb1` and `/dev/sdc1` | `evidence/array-healthy.txt` |
| Degraded | `[2/1] [U_]`; `mdadm --detail` showed `State : clean, degraded`, with `/dev/sdb1` active and the other slot removed | `evidence/array-degraded.txt` |
| Rebuilt | `[2/2] [UU]`; `/dev/sdb1` and `/dev/sdd1` active; `State : clean` | `evidence/array-rebuilt.txt` — final output provided |

## Checksums before and after the failure

Baseline output from `sha256sum proof.txt random.bin`:

```text
8c755594d885cda718c48573d57daa41772d76a5d9245d4f2a8d707074c930e9  proof.txt
7bcca60323a495e98a5e1f60500fe29736d2b5caec2fe4f8228537ed43067963  random.bin
```

After-failure output from `evidence/checksum-after-failure.txt`:

```text
8c755594d885cda718c48573d57daa41772d76a5d9245d4f2a8d707074c930e9  proof.txt
7bcca60323a495e98a5e1f60500fe29736d2b5caec2fe4f8228537ed43067963  random.bin
```
Checksums before and after the failure: match 

## RAID is not a backup

RAID 1 keeps a copy of data on another disk, so it can keep the volume available when one member disk fails. It does not protect against deleting or overwriting a file: that change is copied to both mirror members. A separate backup is still needed to recover earlier versions or data lost for other reasons.

## What did not work the first time

The final 'findmnt' check returned no output because /dev/md0 was not mounted at that point. I mounted it with sudo mount /dev/md0 /mnt/mirror and confirmed the mount.

## Submission evidence checklist

- `lsblk-before.txt`
- `array-healthy.txt`
- `array-degraded.txt`
- `checksum-before.txt`
- `checksum-after-failure.txt`
- `array-rebuilt.txt`

