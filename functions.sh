#!/bin/bash

# Konstanten für Farben
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Partitionen
EFIPART=""
ROOTPART=""
SWAPPART=""

# Mountpunkte
EFIMOUNT=""
ROOTMOUNT=""
SWAPMOUNT=""

# Timezone
TIMEZONE=""

# Keyboard Layout
KEYBOARDLAYOUT=""

# Functions
clearScreen() {
	bash -c clear
}

partition() {
	PARTTOOL=""
	DRIVE=""

    myPrint "yellow" "\nUse [1]: fdisk or [2]: cfdisk (default = fdisk) ? "
	read PARTTOOL

	if [ "${PARTTOOL}" == "" ]
	then
		PARTTOOL="1"
	fi
	
	if [ "${PARTTOOL}" == "1" ]
	then
		PARTTOOL="fdisk"
	fi
	if [ "${PARTTOOL}" == "2" ]
	then
		PARTTOOL="cfdisk"
	fi

	while [[ "${DRIVE}" == "" ]]
	do
	   myPrint "yellow" "Enter you Drive to partition: "
	   read DRIVE
	done

	myPrint "red" "\n${DRIVE} will be partitioned with ${PARTTOOL} now!\n"
	bash -c "${PARTTOOL} ${DRIVE}"
	printf "Partitioning ${DRIVE} with ${PARTTOOL}\t"
	printf "[" 
	myPrint "green" "OK"
	printf "]\n"
	printf "\nInstallation will start in 5 seconds."
	sleep 1 
	printf "\rInstallation will start in 4 seconds."
	sleep 1 
	printf "\rInstallation will start in 3 seconds."
	sleep 1 
	printf "\rInstallation will start in 2 seconds."
	sleep 1 
	printf "\rInstallation will start in 1 seconds."
	sleep 1 
	clearScreen
}

myPrint() {
	color="$1"
	message="$2"
	if [ "${color}" == "green" ]
	then
		printf "${GREEN}${message}${NC}"
	fi
	if [ "${color}" == "red" ]
	then
		printf "${RED}${message}${NC}"
	fi
	if [ "${color}" == "yellow" ]
	then
		printf "${YELLOW}${message}${NC}"
	fi
}

checkEFI() {
	_EFI=$(cat /sys/firmware/efi/fw_platform_size 2>/dev/null)
	if [[ "${_EFI}" != "64" && "${_EFI}" != "32" ]]
	then
		# Hier wieder 0 zurückgeben bei fehler.
		return 0
	else
		return 1
	fi
}

keyboardLayout() {
	myPrint "yellow" "Enter your Keyboard Layout (default = de-latin1): "
	read KEYBOARDLAYOUT
	if [ "${KEYBOARDLAYOUT}" == "" ]
	then
		KEYBOARDLAYOUT="de-latin1"
	fi
	bash -c "loadkeys ${KEYBOARDLAYOUT}"
	printf "\nSetting keyboard layout\t\t"
	printf "[" 
	myPrint "green" "OK"
	printf "]\n\n"
}

timezone() {
	myPrint "yellow" "Enter your Timezone (default = Europe/Berlin): "
	read TIMEZONE
	if [ "${TIMEZONE}" == "" ]
	then
		TIMEZONE="Europe/Berlin"
	fi
	bash -c "timedatectl set-timezone \"${TIMEZONE}\""
	bash -c "timedatectl set-ntp true"
	printf "\nSetting timezone (with ntp)\t"
	printf "[" 
	myPrint "green" "OK"
	printf "]\n\n"
}

format() {
	while [ "${EFIPART}" == "" ]
	do
		myPrint "yellow" "Enter your EFI partition: "
		read EFIPART
	done
	while [ "${ROOTPART}" == "" ]
	do
		myPrint "yellow" "Enter your ROOT partition: "
		read ROOTPART
	done
	while [ "${SWAPPART}" == "" ]
	do
		myPrint "yellow" "Enter your SWAP partition: "
		read SWAPPART
	done
		
	printf "\nEFI partition  =\t"
	myPrint "green" "${EFIPART}\n"
	printf "ROOT partition =\t"
	myPrint "green" "${ROOTPART}\n"
	printf "SWAP partition =\t"
	myPrint "green" "${SWAPPART}\n\n"	
	
	printf "Formating EFI parition (${EFIPART})...\n"
	bash -c "mkfs.fat -F 32 ${EFIPART}"
	printf "Formating ROOT parition (${ROOTPART})...\n"
	bash -c "mkfs.ext4 ${ROOTPART}"
	printf "Making swapfile (${SWAPPART})...\n"
	bash -c "mkswap ${SWAPPART}"
}

myMount() {
	myPrint "yellow" "\nEnter your EFI mountpoint (default = /mnt/boot): "
	read EFIMOUNT
	if [ "${EFIMOUNT}" == "" ]
	then
		EFIMOUNT="/mnt/boot"
	fi

	myPrint "yellow" "Enter your ROOT mountpoint (default = /mnt): "
	read ROOTMOUNT
	if [ "${ROOTMOUNT}" == "" ]
	then
		ROOTMOUNT="/mnt"
	fi
		
	printf "\nEFI mountpoint  =\t"
	myPrint "green" "${EFIMOUNT}\n"
	printf "ROOT mountpount =\t"
	myPrint "green" "${ROOTMOUNT}\n\n"
	
	printf "Mounting EFI parition (${EFIMOUNT})...\n"
	bash -c "mount --mkdir ${EFIPART} ${EFIMOUNT}"
	printf "Mounting ROOT parition (${ROOTMOUNT})...\n"
	bash -c "mount ${ROOTPART} ${ROOTMOUNT}"
	printf "Enabling swapfile (${SWAPPART})...\n"
	bash -c "swapon ${SWAPPART}"	
}

mirrors() {
	COUNTRY=""
	myPrint "yellow" "\nEnter your country for the mirrorlist (default = Germany): "
	read COUNTRY
	if [ "${COUNTRY}" == "" ]
	then
		COUNTRY="Germany"
	fi
	printf "\nSorting mirrors..."
	bash -c "reflector -c ${COUNTRY} -a 6 --save /etc/pacman.d/mirrorlist"
	printf "\t\t["
	myPrint "green" "OK"
	printf "]\n"
	
	printf "Updating pacman..."
	bash -c "pacman -Syyy"
	printf "\t\t["
	myPrint "green" "OK"
	printf "]\n"	
}

baseInstall() {
	PROZ=""
	myPrint "yellow" "\nEnter your processor manufactorer (intel or amd - default = intel): "
	read PROZ
	if [ "${PROZ}" == "" ]
	then
		PROZ="intel-ucode"
	fi
	if [ "${PROZ}" == "intel" ]
	then
		PROZ="intel-ucode"
	fi
	if [ "${PROZ}" == "amd" ]
	then
		PROZ="amd-ucode"
	fi	
	
	printf "\nProcessor  =\t\t"
	myPrint "green" "${PROZ}\n"
	
	printf "\nRunning base install in 5 seconds."
	sleep 1 
	printf "\rRunning base install in 4 seconds."
	sleep 1 
	printf "\rRunning base install in 3 seconds."
	sleep 1 
	printf "\rRunning base install in 2 seconds."
	sleep 1 
	printf "\rRunning base install in 1 seconds."
	sleep 1 
	clearScreen

	myPrint "green" "************************************\n"
	myPrint "green" "* Starting base installation       *\n"
	myPrint "green" "************************************\n"	
	printf "\nRunning pacstrap...\t\t\t"
	bash -c "pacstrap -K /mnt base linux linux-firmware sudo ${PROZ}"
	printf "["
	myPrint "green" "OK"
	printf "]"
}

makeFstab() {
	printf "\nCreating Fstab...\t\t\t"
	bash -c "genfstab -U /mnt >> /mnt/etc/fstab"
	printf "["
	myPrint "green" "OK"
	printf "]"
}

myChroot() {
	printf "\nEntering chroot on ${ROOTMOUNT}...\t\t"
	bash -c "arch-chroot ${ROOTMOUNT}"
	printf "["
	myPrint "green" "OK"
	printf "]"
	
	printf "\nSetting timezone ${TIMEZONE}...\t"
	bash -c "ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime"
	bash -c "hwclock --systohc"
	printf "["
	myPrint "green" "OK"
	printf "]\n"
	
	myPrint "yellow" "\nEnter your locale (default = de_DE.UTF-8): "
	read LOCALE
	if [ "${LOCALE}" == "" ]
	then
		LOCALE="de_DE.UTF-8"
	fi
	printf "\nSetting locale.gen ${LOCALE}...\t"
	bash -c "sed -e '/${LOCALE}/s/^#*//' -i /etc/locale.gen"
	bash -c "locale-gen"
	printf "["
	myPrint "green" "OK"
	printf "]"

	printf "\nSetting locale.conf ${LOCALE}...\t"
	bash -c "echo \"LANG=${LOCALE}\" >> /etc/locale.conf"
	printf "["
	myPrint "green" "OK"
	printf "]"

	printf "\nSetting keymap ${KEYBOARDLAYOUT}...\t\t"
	bash -c "echo \"KEYMAP=${KEYBOARDLAYOUT}\" >> /etc/vconsole.conf"
	printf "["
	myPrint "green" "OK"
	printf "]\n\n"

	myPrint "yellow" "Enter your hostname (default = arch): "
	read HOSTNAME
	if [ "${HOSTNAME}" == "" ]
	then
		HOSTNAME="arch"
	fi
	printf "\nSetting hostname ${HOSTNAME}...\t\t"
	bash -c "echo "${HOSTNAME}" >> /etc/hostname"
	printf "["
	myPrint "green" "OK"
	printf "]"

	printf "\nSetting hosts...\t\t\t"
	bash -c "echo \"127.0.0.1\tlocalhost\n\" >> /etc/hosts"
	bash -c "echo \"::1\tlocalhost\n\" >> /etc/hosts"
	bash -c "echo \"127.0.1.1\t${HOSTNAME}.localdomain\t${HOSTNAME}\" >> /etc/hosts"
	printf "["
	myPrint "green" "OK"
	printf "]"

	printf "\nCreating initramfs...\t"
	bash -c "mkinitcpio -P"
	printf "["
	myPrint "green" "OK"
	printf "]"
	
	bash -c "passwd"
		
	printf "\nInstalling base programs...\t"
	bash -c "pacmans -S grub efibootmgr os-prober ntfs-3g networkmanager dialog mtools dosfstools base-devel linux-headers git pulseaudio --noconfirm --needed"
	printf "["
	myPrint "green" "OK"
	printf "]"

	printf "\nConfiguring GRUB...\t"
	bash -c "grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB"
	printf "["
	myPrint "green" "OK"
	printf "]"

	printf "\nWriting GRUB config...\t"
	bash -c "grub-mkconfig -o /boot/grub/grub.cfg"
	printf "["
	myPrint "green" "OK"
	printf "]"

	printf "\nEnabling networkmanager...\t"
	bash -c "systemctl enable NetworkManager"
	printf "["
	myPrint "green" "OK"
	printf "]"
	
	myPrint "yellow" "\n\nEnter your normal username (default = schnubby): "
	read USER
	if [ "${USER}" == "" ]
	then
		USER="schnubby"
	fi
	
	printf "\nCreating new user...\t"
	bash -c "useradd -mG wheel ${USER}"
	printf "["
	myPrint "green" "OK"
	printf "]"

	printf "\nSetting password for new user...\t"
	bash -c "passwd ${USER}"
	printf "["
	myPrint "green" "OK"
	printf "]"
	
	printf "\nSetting sudo for new user...\t"
	bash -c "sed -e '/%wheel ALL=(ALL) ALL/s/^#*//' -i /etc/sudoers"
	printf "["
	myPrint "green" "OK"
	printf "]"
	
	bash -c "exit"
	bash -c "umount -R /mnt"

	myPrint "green" "\n\n*************************************************************\n"
	myPrint "green" "* Installation is done - System will reboot now!            *\n"
	myPrint "green" "*************************************************************\n"

}	