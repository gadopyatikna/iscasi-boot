# make traget iscsi image
# parting
sudo parted /dev/sda --script mklabel gpt
sudo parted /dev/sda --script mkpart ESP fat32 1MiB 512MiB
sudo parted /dev/sda --script set 1 esp on
sudo mkfs.vfat -F32 /dev/sda1
sudo parted /dev/sda --script mkpart primary ext4 512MiB 100%
sudo mkfs.ext4 /dev/sda2

parted /dev/sda print
# Model: LIO-ORG disk01 (scsi)
# Disk /dev/sda: 10.7GB
# Sector size (logical/physical): 512B/512B
# Partition Table: gpt
# Disk Flags: 

# Number  Start   End     Size    File system  Name     Flags
#  1      1049kB  537MB   536MB   fat32        ESP      boot, esp
#  2      537MB   10.7GB  10.2GB  ext4         primary

# mount
sudo mount /dev/sda2 /mnt
sudo mkdir -p /mnt/boot/efi
sudo mount /dev/sda1 /mnt/boot/efi

# sda2 is the root partition, sda1 is the efi partition
# /dev/sda1 mounts into /boot/efi (who lives inside /dev/sda2 fs).

# grub
sudo grub-install \
  --target=arm64-efi \
  --efi-directory=/mnt/boot/efi \
  --boot-directory=/mnt/boot \
  --removable

# sudo mount /dev/sda2 /mnt
sudo apt install debootstrap
sudo debootstrap \
  --arch=arm64 \
  noble \
  /mnt \
  http://ports.ubuntu.com/

sudo mount --bind /dev  /mnt/dev
sudo mount --bind /proc /mnt/proc
sudo mount --bind /sys  /mnt/sys
sudo mount --bind /run  /mnt/run
sudo chroot /mnt

apt update
apt install linux-image-generic
apt install linux-image-arm64
# puts in /boot/vmlinuz-* 

apt install grub2-common
grub-mkconfig -o /boot/grub/grub.cfg

#iscsi
apt install open-iscsi
update-initramfs -u

# end
sudo umount /mnt/run
sudo umount /mnt/sys
sudo umount /mnt/proc
sudo umount /mnt/dev
# finish
sudo umount /mnt/boot/efi
sudo umount /mnt