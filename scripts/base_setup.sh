#!/bin/env bash

ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
hwclock --systohc

sed -i "s/#$LOC/$LOC/" /etc/locale.gen
locale-gen

echo "LANG=$LOC" >> /etc/locale.conf

if [[ ! $KB_LAYOUT == "" ]]; then
  echo "KEYMAP=$KB_LAYOUT" >> /etc/vconsole.conf
fi

echo $HOST_NAME >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1 localhost" >> /etc/hosts
echo "127.0.1.1 $HOST_NAME" >> /etc/hosts

echo "root:$ROOT_PASSWD" | chpasswd

# Install microcode for Intel and AMD cpu
cpu_type=$(lscpu | grep "Vendor ID:" | cut -d ":" -f 2)
cpu_type=$(echo $cpu_type)

if [[ $cpu_type == "AuthenticAMD" ]]; then
  pacman -S --noconfirm --needed amd-ucode
elif [[ $cpu_type == "GenuineIntel" ]]; then
  pacman -S --noconfirm --needed intel-ucode
fi

# Boot manager
pacman -S --noconfirm --needed grub efibootmgr
pacman -S --noconfirm --needed dosfstools # Dont know where to put it

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB

if $DUALBOOT_OPT; then
  pacman -S --noconfirm --needed os-prober
  sed -i "s/#GRUB_DISABLE_OS_PROBER=false/GRUB_DISABLE_OS_PROBER=false/" /etc/default/grub
fi

grub-mkconfig -o /boot/grub/grub.cfg

# Network setup

pacman -S --noconfirm --needed networkmanager dhclient dialog avahi
systemctl enable NetworkManager
systemctl enable avahi-daemon

if $WIFI_OPT; then
  pacman -S --noconfirm --needed wpa_supplicant
fi

if $BT_OPT; then
  pacman -S --noconfirm --needed bluez bluez-utils
  systemctl enable bluetooth
fi

if $NTFS_OPT; then
  pacman -S --noconfirm --needed ntfs-3g
fi

# Base packages
pacman -S --noconfirm --needed xdg-utils xdg-user-dirs usbutils binutils linux-headers base-devel xorg

# Audio settings (may need after install config)
pacman -S --noconfirm --needed alsa-utils alsa-plugins pipewire pipewire-alsa pipewire-jack pipewire-pulse pavucontrol

if [[ $GD_OPT == "nvidia" ]]; then
  pacman -S --noconfirm --needed nvidia nvidia-utils lib32-nvidia-utils
fi

# Add user

useradd -m $NAME
echo "$NAME:$PASSWD" | chpasswd
usermod -aG wheel $NAME

# Add sudo with no password (If needed to install some package as user during the script [TO BE CHANGE AFTER IN THE SCRIPT])
sed -i "s/# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/" /etc/sudoers

#
# Post setup stuff
#


if [[ $AUR_OPT == "paru" ]]; then
    su $NAME -c "bash ./post_setup/paru.sh"
fi

if [[ $LDM_OPT == "lightdm" ]]; then
  pacman -S --noconfirm --needed lightdm lightdm-gtk-greeter
  systemctl enable lightdm
fi

exit

