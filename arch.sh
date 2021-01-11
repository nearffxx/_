#!/bin/sh
# To install arch do:
# wget https://raw.githubusercontent.com/nearffxx/_/master/arch.sh -O arch.sh; sh arch.sh
# To test on qemu do:
# pacman -S qemu ovmf
# qemu-img create disk.img 10G
# qemu-system-x86_64 -bios /usr/share/ovmf/x64/OVMF_CODE.fd -enable-kvm -net nic -net user -m 1G -cdrom archlinux-2020.03.01-x86_64.iso -drive format=raw,file=disk.img

set -e

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
cryptsetup luksFormat /dev/sda2
cryptsetup open /dev/sda2 root
mkfs.btrfs /dev/mapper/root

# base setup
mount -onoatime,compress-force=zstd /dev/mapper/root /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
pacstrap /mnt base base-devel btrfs-progs linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab
sed -i "s/space_cache/space_cache,compress-force=zstd/g" /mnt/etc/fstab

# boot setup
echo '''sed -i "s/block filesystems/block encrypt filesystems/g" /etc/mkinitcpio.conf
sed -i "s/BINARIES=()/BINARIES=(\/usr\/bin\/btrfs)/g" /etc/mkinitcpio.conf
sed -i "s/MODULES=()/MODULES=(vfat)/g" /etc/mkinitcpio.conf
mkinitcpio -p linux
bootctl --path=/boot install

echo "title Arch Linux" > /boot/loader/entries/arch.conf
echo "linux /vmlinuz-linux" >> /boot/loader/entries/arch.conf
echo "initrd /initramfs-linux.img" >> /boot/loader/entries/arch.conf
echo "options cryptdevice=/dev/sda2:root:allow-discards root=/dev/mapper/root rw mitigations=off" >> /boot/loader/entries/arch.conf
''' | arch-chroot /mnt

# system setup
echo '''pacman -Syu --noconfirm sway swaylock waybar qutebrowser chromium termite rofi pavucontrol xorg-server-xwayland iw iwd dhcpcd
pacman -Syu --noconfirm zsh wget git yajl vim neovim python-neovim openssh p7zip htop jdk-openjdk python-pip pulseaudio pamixer acpilight
pacman -Syu --noconfirm systemd-swap noto-fonts noto-fonts-cjk ttf-font-awesome

sed -i "s/#zswap_enabled=1/zswap_enabled=0/g" /etc/systemd/swap.conf
sed -i "s/#zram_enabled=0/zram_enabled=1/g" /etc/systemd/swap.conf

systemctl enable iwd.service
systemctl enable dhcpcd.service
systemctl enable systemd-swap.service

sed -i "s/#en_US.UTF-8/en_US.UTF-8/g" /etc/locale.gen
locale-gen

sed -i "s/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/g" /etc/sudoers

cat <<EOT> /etc/udev/rules.d/99-lowbat.rules
# Suspend the system when battery level drops to 9% or lower
SUBSYSTEM=="power_supply", ATTR{status}=="Discharging", ATTR{capacity}=="[0-9]", RUN+="/usr/bin/systemctl suspend"
EOT

cat <<EOT> /etc/polkit-1/rules.d/49-nopasswd_global.rules
polkit.addRule(function(action, subject) {
    if (subject.isInGroup("wheel")) {
        return polkit.Result.YES;
    }
});
EOT

echo "static domain_name_servers=8.8.8.8 8.8.4.4" >> /etc/dhcpcd.conf
timedatectl set-timezone Europe/Rome
ntpd -qg
hwclock --systohc
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

mkdir -p .config
mkdir -p .config/mpv
mkdir -p .config/nvim
mkdir -p .config/sway
mkdir -p .config/gtk-3.0
mkdir -p .config/termite
mkdir -p .config/qutebrowser

cp /etc/sway/config .config/sway/config
echo "include config+*" >> .config/sway/config
sed -i "s/set \$term alacritty/set \$term termite/g" .config/sway/config
sed -i "s/position top/position bottom/g" .config/sway/config
sed -i "s/date +'%Y-%m-%d %l:%M:%S %p'/.config\/sway\/run.py/g" .config/sway/config
wget https://raw.githubusercontent.com/nearffxx/_/master/sway/config+ -O .config/sway/config+
wget https://raw.githubusercontent.com/nearffxx/_/master/sway/run.py -O .config/sway/run.py

wget https://raw.githubusercontent.com/nearffxx/_/master/vimrc -O .vimrc
wget https://raw.githubusercontent.com/nearffxx/_/master/zshrc -O .zshrc
wget https://raw.githubusercontent.com/nearffxx/_/master/tmux.conf -O .config/tmux.conf
wget https://raw.githubusercontent.com/nearffxx/_/master/mpv/mpv.conf -O .config/mpv/mpv.conf
wget https://raw.githubusercontent.com/nearffxx/_/master/nvim/init.vim -O .config/nvim/init.vim
wget https://raw.githubusercontent.com/nearffxx/_/master/termite/config -O .config/termite/config
wget https://raw.githubusercontent.com/nearffxx/_/master/gtk-3.0/gtk.css -O .config/gtk-3.0/gtk.css
wget https://raw.githubusercontent.com/nearffxx/_/master/qutebrowser/config.py -O .config/qutebrowser/config.py

git config --global user.email "_"                                                                                                                                    master * ] 8:07 PM
git config --global user.name "_"
git config --global pull.ff only

git clone https://github.com/robbyrussell/oh-my-zsh.git .oh-my-zsh
git clone https://github.com/VundleVim/Vundle.vim.git .config/nvim/bundle/Vundle.vim 
''' | arch-chroot /mnt


# set password
(echo 'passwd'; cat -) | arch-chroot /mnt
