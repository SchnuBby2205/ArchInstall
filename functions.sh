#!/bin/bash

# TODO kopieren von github repo nach /mnt

# Konstanten für Farben
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'
RUNNING="[${YELLOW}  RUNNING ${NC}]"
MYOK="[${GREEN}    OK    ${NC}]"
ERROR="[${RED}  ERROR   ${NC}]"

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
	printf "\n"
	printOK "Partitioning ${DRIVE} with ${PARTTOOL}\n"
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

printOK() {
	message="$1"
	printf "${MYOK}   ${message}"
}
printRunning() {
	message="$1"
	printf "${RUNNING}   ${message}"
}
printError() {
	message="$1"
	printf "${ERROR}   ${message}"
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
	myPrint "yellow" "\nEnter your Keyboard Layout (default = de-latin1): "
	read KEYBOARDLAYOUT
	if [ "${KEYBOARDLAYOUT}" == "" ]
	then
		KEYBOARDLAYOUT="de-latin1"
	fi
	printf "\n"
	printRunning "Setting keyboard layout"
	bash -c "loadkeys ${KEYBOARDLAYOUT} &>/dev/null"
	printf "\r"
	printOK "Setting keyboard layout\n"
}

keyboardLayout2() {
	myPrint "yellow" "\nEnter your Keyboard Layout (default = de-latin1): "
	read KEYBOARDLAYOUT
	if [ "${KEYBOARDLAYOUT}" == "" ]
	then
		KEYBOARDLAYOUT="de-latin1"
	fi
}

timezone() {
	myPrint "yellow" "Enter your Timezone (default = Europe/Berlin): "
	read TIMEZONE
	if [ "${TIMEZONE}" == "" ]
	then
		TIMEZONE="Europe/Berlin"
	fi
	printf "\n"
	printRunning "Setting timezone (with ntp)"
	bash -c "timedatectl set-timezone \"${TIMEZONE}\" &>/dev/null"
	bash -c "timedatectl set-ntp true &>/dev/null"
	printf "\r"
	printOK "Setting timezone (with ntp)\n\n"
}

timezone2() {
	myPrint "yellow" "Enter your Timezone (default = Europe/Berlin): "
	read TIMEZONE
	if [ "${TIMEZONE}" == "" ]
	then
		TIMEZONE="Europe/Berlin"
	fi
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
	
	printRunning "Formating EFI parition (${EFIPART})..."
	bash -c "mkfs.fat -F 32 ${EFIPART} &>/dev/null"
	printf "\r"
	printOK "Formating EFI parition (${EFIPART})...\n"
	
	printRunning "Formating ROOT parition (${ROOTPART})..."
	bash -c "mkfs.ext4 ${ROOTPART} &>/dev/null"
	printf "\r"
	printOK "Formating ROOT parition (${ROOTPART})...\n"
	
	printRunning "Making swapfile (${SWAPPART})..."
	bash -c "mkswap ${SWAPPART} &>/dev/null"
	printf "\r"
	printOK "Making swapfile (${SWAPPART})...\n"
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
	
	printRunning "Mounting ROOT parition (${ROOTMOUNT})..."
	bash -c "mount ${ROOTPART} ${ROOTMOUNT} &>/dev/null"
	printf "\r"
	printOK "Mounting ROOT parition (${ROOTMOUNT})...\n"

	printRunning "Mounting EFI parition (${EFIMOUNT})..."
	bash -c "mount --mkdir ${EFIPART} ${EFIMOUNT} &>/dev/null"
	printf "\r"
	printOK "Mounting EFI parition (${EFIMOUNT})...\n"

	printRunning "Enabling swapfile (${SWAPPART})..."
	bash -c "swapon ${SWAPPART} &>/dev/null"	
	printf "\r"
	printOK "Enabling swapfile (${SWAPPART})...\n"
}

mirrors() {
	COUNTRY=""
	myPrint "yellow" "\nEnter your country for the mirrorlist (default = Germany): "
	read COUNTRY
	if [ "${COUNTRY}" == "" ]
	then
		COUNTRY="Germany"
	fi
	printf "\n"
	printRunning "Sorting mirrors..."
	bash -c "reflector -c ${COUNTRY} -a 6 --save /etc/pacman.d/mirrorlist &>/dev/null"
	printf "\r"
	printOK "Sorting mirrors...\n"

	printRunning "Updating pacman..."
	bash -c "pacman -Syyy &>/dev/null"
	printf "\r"
	printOK "Updating pacman...\n"
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
	myPrint "green" "************************************\n\n"	
	myPrint "red" "IMPORTANT\n"
	printf "\t- This step will take a few minutes!\n\n"
	printRunning "Running pacstrap..."
	bash -c "pacstrap -K /mnt base linux linux-firmware sudo ${PROZ} &>/dev/null"
	printf "\r"
	printOK "Running pacstrap..."
}

makeFstab() {
	printf "\n"
	printRunning "Creating fstab..."
	bash -c "genfstab -U /mnt >> /mnt/etc/fstab"
	printf "\r"
	printOK "Creating fstab...\n"

	printf "\nEntering chroot on ${ROOTMOUNT} in 5 seconds."
	sleep 1 
	printf "\rEntering chroot on ${ROOTMOUNT} in 4 seconds."
	sleep 1 
	printf "\rEntering chroot on ${ROOTMOUNT} in 3 seconds."
	sleep 1 
	printf "\rEntering chroot on ${ROOTMOUNT} in 2 seconds."
	sleep 1 
	printf "\rEntering chroot on ${ROOTMOUNT} in 1 seconds."
	sleep 1 
	clearScreen
}

myChroot1() {
	printf "\n\n"
	myPrint "green" "*********************\n"
	myPrint "green" "* Entering chroot   *\n"
	myPrint "green" "*********************\n"

	myPrint "red" "\nIMPORTANT\n"
	printf "\t- Type cd ArchInstall\n"
	printf "\t- Type ./chrootinstall.sh\n\n"
	
	#printf "\nEntering chroot on ${ROOTMOUNT}...\t\t"
	cd ..
	mv "ArchInstall/" "${ROOTMOUNT}"
	bash -c "arch-chroot ${ROOTMOUNT}"
}

myChroot2() {
	keyboardLayout2
	timezone2
	
	printf "\n"
	printRunning "Setting timezone ${TIMEZONE}..."
	bash -c "ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime"
	bash -c "hwclock --systohc"
	printf "\r"
	printOK "Setting timezone ${TIMEZONE}...\n"

	myPrint "yellow" "\nEnter your locale (default = de_DE.UTF-8): "
	read LOCALE
	if [ "${LOCALE}" == "" ]
	then
		LOCALE="de_DE.UTF-8"
	fi
	
	printf "\n"
	printRunning "Setting locale.gen ${LOCALE}..."
	bash -c "sed -e '/${LOCALE}/s/^#*//' -i /etc/locale.gen"
	bash -c "locale-gen &>/dev/null"
	printf "\r"
	printOK "Setting locale.gen ${LOCALE}...\n"

	printRunning "Setting locale.conf ${LOCALE}..."
	bash -c "echo \"LANG=${LOCALE}\" >> /etc/locale.conf"
	printf "\r"
	printOK "Setting locale.conf ${LOCALE}...\n"

	printRunning "Setting keymap ${KEYBOARDLAYOUT}..."
	bash -c "echo \"KEYMAP=${KEYBOARDLAYOUT}\" >> /etc/vconsole.conf"
	printf "\r"
	printOK "Setting keymap ${KEYBOARDLAYOUT}...\n"

	myPrint "yellow" "\nEnter your hostname (default = arch): "
	read HOSTNAME
	if [ "${HOSTNAME}" == "" ]
	then
		HOSTNAME="arch"
	fi
	printf "\n"
	printRunning "Setting hostname ${HOSTNAME}..."
	bash -c "echo "${HOSTNAME}" >> /etc/hostname"
	printf "\r"
	printOK "Setting hostname ${HOSTNAME}...\n"

	printRunning "Setting hosts..."
	bash -c "echo \"127.0.0.1\tlocalhost\n\" >> /etc/hosts"
	bash -c "echo \"::1\tlocalhost\n\" >> /etc/hosts"
	bash -c "echo \"127.0.1.1\t${HOSTNAME}.localdomain\t${HOSTNAME}\" >> /etc/hosts"
	printf "\r"
	printOK "Setting hosts...\n"

	printRunning "Creating initramfs..."
	bash -c "mkinitcpio -P &>/dev/null"
	printf "\r"
	printOK "Creating initramfs...\n"
	
	myPrint "yellow" "\nEnter your NEW root password:\n\n"
	bash -c "passwd"
		
	printf "\n"
	printRunning "Installing base programs..."
	bash -c "pacman -S grub efibootmgr os-prober ntfs-3g networkmanager dialog mtools dosfstools base-devel linux-headers git pulseaudio --noconfirm --needed &>/dev/null"
	printf "\r"
	printOK "Installing base programs...\n"

	printRunning "Configuring GRUB..."
	bash -c "grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB &>/dev/null"
	printf "\r"
	printOK "Configuring GRUB...\n"

	printRunning "Writing GRUB config..."
	bash -c "grub-mkconfig -o /boot/grub/grub.cfg &>/dev/null"
	printf "\r"
	printOK "Writing GRUB config...\n"

	printRunning "Enabling networkmanager..."
	bash -c "systemctl enable NetworkManager &>/dev/null"
	printf "\r"
	printOK "Enabling networkmanager...\n"
	
	myPrint "yellow" "\nEnter your normal username (default = schnubby): "
	read USER
	if [ "${USER}" == "" ]
	then
		USER="schnubby"
	fi
	printf "\n"
	bash -c "useradd -mG wheel ${USER}"
	bash -c "passwd ${USER}"
	
	printf "\n"
	printRunning "Setting sudo for new user..."
	bash -c "sed -e '/%wheel ALL=(ALL:ALL) ALL/s/^#*//' -i /etc/sudoers"
	printf "\r"
	printOK "Setting sudo for new user...\n"
	
	cd ..
	bash -c "mv ArchInstall/ /home/${USER}"
	bash -c "chown -R ${USER}:${USER} /home/${USER}/ArchInstall"


	printf "\nFinishing installation in 5 seconds."
	sleep 1 
	printf "\rFinishing installation in 4 seconds."
	sleep 1 
	printf "\rFinishing installation in 3 seconds."
	sleep 1 
	printf "\rFinishing installation in 2 seconds."
	sleep 1 
	printf "\rFinishing installation in 1 seconds."
	sleep 1 
	clearScreen

	myPrint "green" "******************************\n"
	myPrint "green" "* Installation is done !     *\n"
	myPrint "green" "******************************\n"

	myPrint "red" "\nIMPORTANT\n"
	printf "\t- Type \"exit\" or press CTRL+D\n"
	printf "\t- Type \"umount -R /mnt\"\n"
	printf "\t- Type \"reboot\"\n"
	printf "\t- After reboot login with the new user\n"
	printf "\t- Type ArchInstall/postinstall.sh\n\n"
}	

installYAY() {
	bash -c "git clone https://aur.archlinux.org/yay.git &>/dev/null"
	cd yay/
	bash -c "makepkg --noconfirm --needed -si &>/dev/null"
	printf "\n"
	printRunning "Installing YAY..."
	cd ..
	printf "\r"
	printOK "Installing YAY...\n"
}

installYAYPrograms() {
	printRunning "Installing pulseaudio-control..."
	bash -c "yay -S pulseaudio-control --noconfirm --needed &>/dev/null"
	printf "\r"
	printOK "Installing pulseaudio-control...\n"

	printRunning "Installing jonaburg-picom..."
	bash -c "yay -S picom-jonaburg-git --noconfirm --needed &>/dev/null"
	printf "\r"
	printOK "Installing jonaburg-picom...\n"

	printRunning "Installing nerd-fonts..."
	bash -c "yay -S nerd-fonts --noconfirm --needed &>/dev/null"
	printf "\r"
	printOK "Installing nerd-fonts...\n"

	printRunning "Installing fontAwesome..."
	bash -c "yay -S ttf-font-awesome --noconfirm --needed &>/dev/null"
	printf "\r"
	printOK "Installing fontAwesome...\n"
}

installPrograms() {
	printRunning "Installing additional programs..."
	bash -c "sudo pacman -S alacritty awesome fish polybar rofi --noconfirm --needed &>/dev/null"
	printf "\r"
	printOK "Installing additional programs...\n\n"

	bash -c "curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish"
	printOK "\n"
}