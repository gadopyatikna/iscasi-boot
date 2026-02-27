sanboot # no args already baked into startup sccript
# from grub
set root=(hd0,gpt2)
set prefix=(hd0,gpt2)/boot/grub
insmod normal
normal

# 
vim /etc/default/grub
GRUB_DISABLE_OS_PROBER=true
update-grub

blkid
cat /etc/fstab

update-initramfs -u -k all
cat /boot/grub/grub.cfg | grep root=

# TODO
#!ipxe
# dhcp
# kernel http://.../vmlinuz root=iscsi:...
# initrd http://.../initrd.img
# boot