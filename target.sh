apt install targetcli-fb
targetcli ls

# backstores
# iscsi

sudo mkdir -p /iscsi-disks
sudo truncate -s 10G /iscsi-disks/disk01.img

sudo targetcli
/backstores/fileio create disk01 /iscsi-disks/disk01.img 10G
# /iscsi-disks/disk01.img exists, using its size (10737418240 bytes) instead
# Created fileio disk01 with size 10737418240

/iscsi create iqn.2023-10.com.example:storage
# Created target iqn.2023-10.com.example:storage.
# Created TPG 1.
# Global pref auto_add_default_portal=true
# Created default portal listening on all IPs (0.0.0.0), port 3260.

/iscsi/iqn.2023-10.com.example:storage/tpg1/luns create /backstores/fileio/disk01

#auth off TODO FIX atuh 0 makes RO disk by default, auth via initiator
/iscsi/iqn.2023-10.com.example:storage/tpg1 set attribute authentication=0
/iscsi/iqn.2023-10.com.example:storage/tpg1 set attribute generate_node_acls=1

# test availability 
sudo ss -ltnp | grep 3260
apt install open-iscsi
iscsiadm -m discovery -t sendtargets -p 0.0.0.0
systemctl status target
systemctl enable target
systemctl start target 

# ro lab issue
sudo dmesg | grep -i sda