#!/bin/bash
source ./functions.sh

# Mein Arch Installationsscript

# Welcome Screen
clearScreen
myPrint "green" "************************************\n"
myPrint "green" "* Welcome to SchnuBby Arch Install *\n"
myPrint "green" "************************************\n"

# Keyboard Layout
keyboardLayout

# Important Notes
myPrint "red" "\nIMPORTANT\n"
printf "\t- You need to make your Partition Table manually\n"

# Partitioning
partition

# Installation
myPrint "green" "************************************\n"
myPrint "green" "* Installation will start now!     *\n"
myPrint "green" "************************************\n"

# EFI Boot checken
checkEFI
EFI=$?
if [ "${EFI}" == 0 ]
then
	printError "\nChecking EFI Boot...\n\n"
	myPrint "red" "Only EFI Boot is supported right now! Sorry!\n"
	myPrint "red" "The Installer will now exit!\n\n"
	exit
else
	printOK "\nChecking EFI Boot...\n\n"
fi

# Timezone
timezone

# Formatting drives
format

# Mounten
myMount

# Mirrors sortieren
mirrors

# Base Installation starten
baseInstall

# Fstab
makeFstab

# chroot
myChroot1