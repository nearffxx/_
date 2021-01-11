#!/bin/sh
# To install arch do:
# wget https://raw.githubusercontent.com/nearffxx/_/master/arch.sh -O arch.sh; sh arch.sh
# To test on qemu do:
# pacman -S qemu ovmf arch-install-scripts
# qemu-img create disk.img 10G
# qemu-system-x86_64 -enable-kvm -bios /usr/share/ovmf/x64/OVMF_CODE.fd -boot d -net nic -net user -m 1G -cdrom archlinux-*.iso -drive format=raw,file=/dev/sdb -display none -serial stdio

set -e

wipefs -af /dev/sda

# disk setup
echo '''g
n
1

+256M
t
1
n
2


w
''' | fdisk /dev/sda
fdisk -l /dev/sda
mkfs.msdos -F32 /dev/sda1
mkfs.f2fs -f /dev/sda2
mount -onoatime,discard /dev/sda2 /mnt

#mkfs.btrfs /dev/sda2
#mount -onoatime,compress-force=zstd /dev/sda2 /mnt

mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
pacstrap /mnt base base-devel f2fs-tools btrfs-progs linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab
echo "tmpfs /var/log tmpfs defaults 0 0" >> /mnt/etc/fstab
#sed -i "s/space_cache/space_cache/g" /mnt/etc/fstab

# boot setup
echo '''sed -i "s/BINARIES=()/BINARIES=(\/usr\/bin\/btrfs)/g" /etc/mkinitcpio.conf
sed -i "s/MODULES=()/MODULES=(ehci_pci usb_storage hid_generic ohci_pci usbhid vfat)/g" /etc/mkinitcpio.conf
sed -i "s/PRESETS=('default' 'fallback')/PRESETS=('default')/g" /etc/mkinitcpio.d/linux.preset
mkinitcpio -p linux
bootctl --path=/boot install

echo "title Arch Linux" > /boot/loader/entries/arch.conf
echo "linux /vmlinuz-linux" >> /boot/loader/entries/arch.conf
echo "initrd /initramfs-linux.img" >> /boot/loader/entries/arch.conf
echo -n "options rw mitigations=off root=" >> /boot/loader/entries/arch.conf
blkid --output full /dev/sda2 | cut -d' ' -f 2 >> /boot/loader/entries/arch.conf
''' | arch-chroot /mnt

# system setup
echo '''pacman -Syu --noconfirm zsh wget git vim openssh p7zip htop python-pip systemd-swap dhcpcd

sed -i "s/#zswap_enabled=1/zswap_enabled=0/g" /etc/systemd/swap.conf
sed -i "s/#zram_enabled=0/zram_enabled=1/g" /etc/systemd/swap.conf

ssh-keygen -A

systemctl enable sshd.service
systemctl enable dhcpcd.service
systemctl enable systemd-swap.service

sed -i "s/#en_US.UTF-8/en_US.UTF-8/g" /etc/locale.gen
locale-gen

sed -i "s/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/g" /etc/sudoers

mkdir -p /root/.ssh
curl https://github.com/nearffxx.keys > /root/.ssh/authorized_keys

echo "static domain_name_servers=8.8.8.8 8.8.4.4" >> /etc/dhcpcd.conf
''' | arch-chroot /mnt

# user setup
echo '''
useradd -m -G wheel user -s /bin/zsh
su user
cd

git clone https://aur.archlinux.org/package-query.git
(cd package-query/ && makepkg -si --noconfirm)
rm -rf package-query

git clone https://aur.archlinux.org/yaourt.git
(cd yaourt/ && makepkg -si --noconfirm)
rm -rf yaourt

git config --global user.email "_"
git config --global user.name "_"
git config --global pull.ff only

''' | arch-chroot /mnt

# set password    
echo -e 'passwd\nroot\nroot' | arch-chroot /mnt
echo -e 'passwd user\nuser\nuser' | arch-chroot /mnt
