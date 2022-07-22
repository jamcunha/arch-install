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

# Boot manager
pacman -S grub efibootmgr --noconfirm --needed
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB

