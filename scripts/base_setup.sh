#!/bin/env bash

ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
hwclock --systohc

sed -i "s/#en_US.UTF-8/en_US.UTF-8/g" /etc/locale.gen
# If you need more locales add other seds
# example:
sed -i "s/#en_GB.UTF-8/en_GB.UTF-8/g" /etc/locale.gen

locale-gen

# Set the language of choice (needed to be uncommented on locale.gen)
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

# In case you need to change the keyboard layout
# echo "KEYMAP=de-latin1" >> /etc/vconsole.conf

echo $HOST_NAME >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1 localhost" >> /etc/hosts
echo "127.0.1.1 $HOST_NAME" >> /etc/hosts

echo "root:$ROOT_PASSWD" | chpasswd

