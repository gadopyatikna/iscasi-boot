apt install open-iscsi
iscsiadm -m discovery -t sendtargets -p 192.168.0.136
iscsiadm -m node -T iqn.2023-10.com.example:storage -p 192.168.0.136 --login