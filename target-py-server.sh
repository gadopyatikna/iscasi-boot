losetup -Pf /iscsi-disks/disk01.img
mount /dev/loop0p2 /mnt
cd /mnt/boot
sudo python3 -m http.server --bind 0.0.0.0 80 
sha256sum ...image..