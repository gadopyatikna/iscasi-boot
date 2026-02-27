cat > boot.ipxe << 'EOF'
#!ipxe

dhcp

set server-ip 192.168.0.136
set target-iqn iqn.2023-10.com.example:storage

echo Booting Linux over iSCSI...

kernel http://${server-ip}/vmlinuz-6.8.0-31-generic \
    ip=dhcp \
    root=/dev/sda2 \
    iscsi_target_name=${target-iqn} \
    iscsi_target_ip=${server-ip} \
    rw

initrd http://${server-ip}/initrd.img-6.8.0-31-generic

boot
EOF