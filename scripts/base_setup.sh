#!/bin/env bash

ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
hwclock --systohc

sed -i "s/#en_US.UTF-8/en_US.UTF-8/g" /etc/locale.gen
# If you need more locales add other seds
# example:
sed -i "s/#en_GB.UTF-8/en_GB.UTF-8/g" /etc/locale.gen

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

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

if $DUALBOOT_OPT; then
  pacman -S --noconfirm --needed os-prober
  echo "GRUB_DISABLE_OS_PROBER=false" >> /etc/default/grub
  grub-mkconfig -o /boot/grub/grub.cfg
fi

