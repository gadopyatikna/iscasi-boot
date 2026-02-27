sudo apt install -y git build-essential gcc binutils make mtools xz-utils perl liblzma-dev
git clone iscsi-ipxe.git

cat > boot.ipxe << 'EOF'
#!ipxe

dhcp
set server-ip 192.168.0.136
set iscsitarget iqn.2023-10.com.example:storage
set initiator-name iqn.2004-10.com.ubuntu:01:33ca4aeade59

sanhook iscsi:${server-ip}:3260::0:${iscsitarget}
# sanboot --no-describe --drive 0x80 # automation step TODO

echo iSCSI login successful
shell
EOF

make bin-arm64-efi/ipxe.efi EMBED=boot.ipxe

# make fat 
mkdir -p efi/EFI/BOOT
cp bin-arm64-efi/ipxe.efi efi/EFI/BOOT/BOOTAA64.EFI

truncate -s 64M efi.img
mkfs.vfat efi.img
mkdir mnt
sudo mount -o loop efi.img mnt
sudo cp -r efi/EFI mnt/
sudo umount mnt

sudo apt install qemu-system-arm qemu-efi-aarch64

qemu-system-aarch64 \
  -machine virt \
  -cpu cortex-a72 \
  -m 1024 \
  -nographic \
  -bios /usr/share/AAVMF/AAVMF_CODE.fd \
  -drive if=virtio,format=raw,file=efi.img \
  -device virtio-net-pci,netdev=net0 \
  -netdev user,id=net0