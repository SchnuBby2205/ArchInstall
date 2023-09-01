#!/bin/bash
source ./functions.sh

# Mein Arch Installationsscript

# Welcome Screen
clearScreen
myPrint "green" "*************************\n"
myPrint "green" "* Entering postinstall  *\n"
myPrint "green" "*************************\n\n"

#installYAY

#installYAYPrograms

#installPrograms

bash -c "sudo sed -i '/\[multilib\]/,/Include/''s/^#//' /etc/pacman.conf"
bash -c "sudo pacman -Syy"
