#!/bin/env bash

# Update system clock
timedatectl set-ntp true

# Enable parallel downloads
sed -i "s/#ParallelDownloads/ParallelDownloads/" /etc/pacman.conf

## Partitioning and mounting should be done before running the script ##
#
# Boot has to be mounted in /boot/efi
#

pacstrap /mnt base linux linux-firmware --noconfirm --needed

genfstab -U /mnt >> /mnt/etc/fstab

