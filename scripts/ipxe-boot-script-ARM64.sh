cat > boot.ipxe << 'EOF'
#!ipxe

dhcp

set server-ip 192.168.0.136
set target-iqn iqn.2023-10.com.example:storage
set root-uuid 8e7904a8-848c-4fff-8a8c-75b1098e407b

echo Booting kernel via iSCSI...

kernel http://${server-ip}/vmlinuz-6.8.0-31-generic \
    ip=dhcp \
    root=UUID=${root-uuid} \
    rootfstype=ext4 \
    netroot=iscsi:${server-ip}::::${target-iqn} \
    iscsi_initiator=iqn.2004-10.com.ubuntu:01:33ca4aeade59 \
    rw

initrd http://${server-ip}/initrd.img-6.8.0-31-generic

boot
EOF