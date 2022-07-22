#!/bin/env bash

DIR="$(pwd)"

export TIMEZONE=$(curl https://ipapi.co/timezone)
export NAME="name"
export HOSTNAME="hostname"
export PASSWD="passwd"
export ROOT_PASSWD=$PASSWD

bash $DIR/scripts/pre_chroot.sh

cp -r $DIR /mnt/root/DELETE_AFTER

arch-chroot /mnt $HOME/DELETE_AFTER/scripts/base_setup.sh

