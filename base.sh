#!/bin/env bash

## WARNING: Still not tested ##

#############
# Variables #
#############

# User name
name="name"

# User passwd
user_passwd="passwd"

# Root passwd (Default is equal to user passwd)
root_passwd=$user_passwd

# Hostname
hostname="hostname"

#################
# Start Install #
#################

# Update system clock
timedatectl set-ntp true

# Enable parallel downloads
sed -i "s/#ParallelDownloads/ParallelDownloads" /etc/pacman.conf

## Partitioning and mounting should be done before running the script ##

pacstrap /mnt base linux linux-firmware --noconfirm --needed

genfstab -U /mnt >> /etc/fstab

arch-chroot /mnt

## To find you region and city run timedatectl list-timezones and the format is (Region/City)
ln -sf /usr/share/zoneinfo/Region/City /etc/localtime
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

echo $hostname >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1 localhost" >> /etc/hosts
echo "127.0.1.1 $hostname" >> /etc/hosts

echo "root:$root_passwd" | chpasswd

