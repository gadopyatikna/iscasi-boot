# make traget iscsi image
# parting
sudo parted /dev/sda --script mklabel gpt
sudo parted /dev/sda --script mkpart ESP fat32 1MiB 512MiB
sudo parted /dev/sda --script set 1 esp on
sudo mkfs.vfat -F32 /dev/sda1

sudo parted /dev/sda --script mkpart primary ext4 512MiB 100%
sudo mkfs.ext4 /dev/sda2

# mount
sudo mount /dev/sda2 /mnt
sudo mkdir -p /mnt/boot/efi
sudo mount /dev/sda1 /mnt/boot/efi

# grub
sudo grub-install \
  --target=arm64-efi \
  --efi-directory=/mnt/boot/efi \
  --boot-directory=/mnt/boot \
  --removable

# make UEFI iPXE image
rm -r mnt

make bin-arm64-efi/ipxe.efi EMBED=boot.ipxe

dd if=/dev/zero of=efi.img bs=1M count=64
mkfs.vfat efi.img
mkdir mnt
sudo mount -o loop efi.img mnt
sudo cp -r efi/EFI mnt/
sudo umount mnt

sudo umount -R /mnt

qemu-system-aarch64 \
  -machine virt \
  -cpu cortex-a72 \
  -m 1024 \
  -nographic \
  -bios /usr/share/AAVMF/AAVMF_CODE.fd \
  -drive if=virtio,format=raw,file=efi.img \
  -device virtio-net-pci,netdev=net0 \
  -netdev user,id=net0

sudo umount -R /mnt 2>/dev/null

