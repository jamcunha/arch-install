#!/bin/env bash

pacman -S --noconfirm --needed git
mkdir /DELETE_AFTER/paru
git clone https://aur.archlinux.org/paru.git /DELETE_AFTER/paru && cd /DELETE_AFTER/paru
makepkg -si --noconfirm

exit
