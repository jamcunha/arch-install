#!/bin/env bash

DIR="$(pwd)"

############
## NEEDED ##
############

export TIMEZONE=$(curl https://ipapi.co/timezone)
export NAME="name"
export HOST_NAME="hostname"
export PASSWD="passwd"
export ROOT_PASSWD=$PASSWD
export KB_LAYOUT=""
export LOC="en_US.UTF-8"
export DUALBOOT_OPT=true # true to have dualboot option, else false
export WIFI_OPT=false # true if wifi is needed
export BT_OPT=false # true if bluetooth is needed
export NTFS_OPT=false # true if nfts filesystem support is needed

##############
## OPTIONAL ##
##############

# AUR helper available: "paru"
export AUR_OPT=""
# Login display manager available: "lightdm"
export LDM_OPT=""
# Graphics driver available: "nvidia"
export GD_OPT=""

bash $DIR/scripts/pre_chroot.sh

cp -r $DIR /mnt/DELETE_AFTER

arch-chroot /mnt bash /DELETE_AFTER/scripts/base_setup.sh

