#!/bin/bash

# Konstanten für Farben
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
NC='\033[0m'
RUNNING="[${YELLOW}  RUNNING ${NC}]"
MYOK="[${GREEN}    OK    ${NC}]"
ERROR="[${RED}  ERROR   ${NC}]"

# Partitionen
DISK=""
CFDISK="n"
BOOTPART=""
ROOTPART=""
SWAPPART=""

FILENAME=$(basename "$0")

# Functions
clearScreen() {
	bash -c clear
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

printRunning() {
	message="$1"
	printf "${RUNNING}   ${message}"
}

printOK() {
	message="$1"
	printf "${MYOK}   ${message}"
}

printError() {
	message="$1"
	printf "${ERROR}   ${message}"
}

# Work
clearScreen
myPrint "green" "   _____      __                ____  __                \n"
myPrint "green" "  / ___/_____/ /_  ____  __  __/ __ )/ /_  __  __       \n"
myPrint "green" "  \__ \/ ___/ __ \/ __ \/ / / / __  / __ \/ / / /       \n"
myPrint "green" " ___/ / /__/ / / / / / / /_/ / /_/ / /_/ / /_/ /        \n"
myPrint "green" "/____/\___/_/ /_/_/ /_/\__,_/_____/_.___/\__, /         \n"
myPrint "green" "    ___              __    ____         /____/      ____\n"
myPrint "green" "   /   |  __________/ /_  /  _/___  _____/ /_____ _/ / /\n"
myPrint "green" "  / /| | / ___/ ___/ __ \ / // __ \/ ___/ __/ __ \`/ / / \n"
myPrint "green" " / ___ |/ /  / /__/ / / // // / / (__  ) /_/ /_/ / / /  \n"
myPrint "green" "/_/  |_/_/   \___/_/ /_/___/_/ /_/____/\__/\__,_/_/_/   \n\n"

OPTION=$1
DISK=$2
CFDISK=$3
BOOTPART=$4
SWAPPART=$5
ROOTPART=$6
HOSTNAME=$7
USER=$8

if [ "${OPTION}" == "" ]
then
	printf "["
	myPrint "yellow" "1"
	printf "]: Install "
	myPrint "yellow" "Arch\n"
	
	printf "["
	myPrint "yellow" "2"
	printf "]: Install "
	myPrint "yellow" "Chroot\n"
	
	printf "["
	myPrint "yellow" "3"
	printf "]: Install "
	myPrint "yellow" "HyprDots\n"
	
	printf "["
	myPrint "yellow" "4"
	printf "]: Install "
	myPrint "yellow" "Config files\n\n"
	
	read OPTION
 fi

if [ "${OPTION}" == "" ]
then
	exit 0
fi

if [ "${OPTION}" == "1" ]
then
	clearScreen	
	myPrint "green" "    ____           __        _____            \n"
	myPrint "green" "   /  _/___  _____/ /_____ _/ / (_)___  ____ _\n"
	myPrint "green" "   / // __ \/ ___/ __/ __ \`/ / / / __ \/ __ \`/\n"
	myPrint "green" " _/ // / / (__  ) /_/ /_/ / / / / / / / /_/ / \n"
	myPrint "green" "/___/_/ /_/____/\__/\__,_/_/_/_/_/ /_/\__, /  \n"
	myPrint "green" "   /   |  __________/ /_             /____/   \n"
	myPrint "green" "  / /| | / ___/ ___/ __ \                     \n"
	myPrint "green" " / ___ |/ /  / /__/ / / /                     \n"
	myPrint "green" "/_/  |_/_/   \___/_/ /_/                      \n\n"
	
	bash -c "lsblk"
	
	if [ "${DISK}" == "" ]
	then
		myPrint "yellow" "\nEnter drive\n"
		read DISK
  	fi
	
	if [ "${DISK}" == "" ]
	then
		printError "No drive entered -> exit\n"
		exit 0
	fi
	
	if [ "${CFDISK}" == "" ]
	then
		myPrint "yellow" "\nStart cfdisk (y/N) ?\n"
		read CFDISK
  	fi
	
	if [ "${CFDISK}" == "y" ] || [ "${CFDISK}" == "Y" ]
	then
		bash -c "cfdisk ${DISK}"
	fi
	
	if [ "${BOOTPART}" == "" ]
	then
		myPrint "yellow" "\nEnter boot partition\n"
		read BOOTPART
  	fi
 
	if [ "${BOOTPART}" == "" ]
	then
		printError "No partition entered -> exit\n"
		exit 0
	fi
	
	if [ "${SWAPPART}" == "" ]
	then
		myPrint "yellow" "\nEnter swap partition\n"
		read SWAPPART
  	fi
 
	if [ "${SWAPPART}" == "" ]
	then
		printError "No partition entered -> exit\n"
		exit 0
	fi
	
	if [ "${ROOTPART}" == "" ]
	then
		myPrint "yellow" "\nEnter root partition\n"
		read ROOTPART
  	fi
 
	if [ "${ROOTPART}" == "" ]
	then
		printError "No partition entered -> exit\n"
		exit 0
	fi
	
	myPrint "green" "\nBoot partition: "
	printf "${WHITE}${BOOTPART}${NC}\n"
	myPrint "green" "Swap partition: "
	printf "${WHITE}${SWAPPART}${NC}\n"
	myPrint "green" "Root partition: "
	printf "${WHITE}${ROOTPART}${NC}\n\n"
	
 	myPrint "green" "Starting installation in 3..."
  	sleep 1
	printf "\r"
  	myPrint "green" "Starting installation in 2..."
  	sleep 1
	printf "\r"
 	myPrint "green" "Starting installation in 1...\n\n"
	sleep 1

	clearScreen	
	myPrint "green" "    ____           __        _____            \n"
	myPrint "green" "   /  _/___  _____/ /_____ _/ / (_)___  ____ _\n"
	myPrint "green" "   / // __ \/ ___/ __/ __ \`/ / / / __ \/ __ \`/\n"
	myPrint "green" " _/ // / / (__  ) /_/ /_/ / / / / / / / /_/ / \n"
	myPrint "green" "/___/_/ /_/____/\__/\__,_/_/_/_/_/ /_/\__, /  \n"
	myPrint "green" "   /   |  __________/ /_             /____/   \n"
	myPrint "green" "  / /| | / ___/ ___/ __ \                     \n"
	myPrint "green" " / ___ |/ /  / /__/ / / /                     \n"
	myPrint "green" "/_/  |_/_/   \___/_/ /_/                      \n\n"

  	#---------------Formatting Drives---------------	
	printRunning "Formatting ${WHITE}drives...${NC}"
	bash -c "mkfs.fat -F 32 ${BOOTPART} &>/dev/null"
	bash -c "mkswap ${SWAPPART} &>/dev/null"
	bash -c "swapon ${SWAPPART} &>/dev/null"
	bash -c "mkfs.ext4 ${ROOTPART} &>/dev/null"
	printf "\r"
	printOK "Formatting ${WHITE}drives...${NC}\n"
	#---------------Formatting Drives---------------	
	
	#---------------Mounting partitions---------------
	printRunning "Mounting ${WHITE}partitions...${NC}"
 	bash -c "mount --mkdir ${ROOTPART} /mnt"
	bash -c "mount --mkdir ${BOOTPART} /mnt/boot"
	printf "\r"
	printOK "Mounting ${WHITE}partitions...${NC}\n"
	#---------------Mounting partitions---------------

	#---------------Setting up pacman---------------
	printRunning "Setting up ${WHITE}pacman...${NC}"
	bash -c "pacman -Syy &>/dev/null"
	bash -c "pacman --noconfirm -S reflector &>/dev/null"
	bash -c "reflector --sort rate --latest 20 --protocol https --country Germany --save /etc/pacman.d/mirrorlist &>/dev/null"
	bash -c "sed -i '/ParallelDownloads/s/^#//' /etc/pacman.conf"
	printf "\r"
	printOK "Setting up ${WHITE}pacman...${NC}\n"
	#---------------Setting up pacman---------------

	#bash -c "archinstall --conf https://raw.githubusercontent.com/SchnuBby2205/ArchInstall/main/conf.json --creds https://raw.githubusercontent.com/SchnuBby2205/ArchInstall/main/creds.json"

 	#---------------Running base install---------------
	printRunning "Running ${WHITE}base install...${NC}"
	bash -c "pacstrap -K /mnt base base-devel linux-lts linux-firmware intel-ucode efibootmgr grub sudo git networkmanager lutris &>/dev/null"
  	bash -c "genfstab -U /mnt >> /mnt/etc/fstab"
   	bash -c "cp ./${FILENAME} /mnt"
	#myPrint "green" "\n\nRun ./ArchInstall option 2\n\n"
	printf "\r"
	printOK "Running ${WHITE}base install...${NC}\n"
 	#---------------Running base install---------------
   	bash -c "arch-chroot /mnt ./${FILENAME} 2 ${DISK} ${CFDISK} ${BOOTPART} ${SWAPPART} ${ROOTPART} ${HOSTNAME} ${USER}"
    	bash -c "umount -R /mnt &>/dev/null"

  	myPrint "green" "\nInstallation complete! Restart in 3..."
  	sleep 1
	printf "\r"
  	myPrint "green" "Installation complete! Restart in 2..."
  	sleep 1
	printf "\r"
 	myPrint "green" "Installation complete! Restart in 1...\n\n"
	sleep 1

      	bash -c "reboot"

fi

if [ "${OPTION}" == "2" ]
then
	#---------------Setting up localtime---------------
	printRunning "Setting up ${WHITE}localtime...${NC}"
     	bash -c "ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime &>/dev/null"
  	bash -c "hwclock --systohc &>/dev/null" 
	printf "\r"
	printOK "Setting up ${WHITE}localtime...${NC}\n"
	#---------------Setting up localtime---------------

	#---------------Setting up locale---------------
	printRunning "Setting up ${WHITE}locale...${NC}"
   	bash -c "sed -e '/de_DE.UTF-8/s/^#*//' -i /etc/locale.gen"	
    	bash -c "locale-gen &>/dev/null"
    	bash -c "echo LANG=de_DE.UTF-8 >> /etc/locale.conf"
     	bash -c "echo KEYMAP=de-latin1 >> /etc/vconsole.conf"
	printf "\r"
	printOK "Setting up ${WHITE}locale...${NC}\n"
	#---------------Setting up locale---------------

	#---------------Setting up GRUB---------------
	printRunning "Setting up ${WHITE}GRUB...${NC}"
       	bash -c "grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB &>/dev/null"
	bash -c "grub-mkconfig -o /boot/grub/grub.cfg &>/dev/null"
	printf "\r"
	printOK "Setting up ${WHITE}GRUB...${NC}\n"
	#---------------Setting up GRUB---------------      
	if [ "${HOSTNAME}" == "" ]
	then
		myPrint "yellow" "\nEnter your Hostname: "
		read HOSTNAME
  	fi
      	bash -c "echo ${HOSTNAME} >> /etc/hostname"
       	
	myPrint "yellow" "\nEnter your NEW root password\n\n"
	bash -c "passwd"

	if [ "${USER}" == "" ]
	then
		myPrint "yellow" "\nEnter your normal username: "
		read USER
	fi
 
	bash -c "useradd -mG wheel ${USER}"
	myPrint "yellow" "\nEnter your normal user password\n\n"
	bash -c "passwd ${USER}"	

 	bash -c "sed -e '/%wheel ALL=(ALL:ALL) ALL/s/^#*//' -i /etc/sudoers"

	#---------------Enabling services---------------
  	printf "\n"
   	printRunning "Enabling ${WHITE}services...${NC}"
 	bash -c "systemctl enable NetworkManager &>/dev/null"
	printf "\r"
	printOK "Enabling ${WHITE}services...${NC}\n"
	#---------------Enabling services---------------

   	bash -c "mv ./${FILENAME} /home/${USER}/"
    	bash -c "echo ./${FILENAME} 3 ${DISK} ${CFDISK} ${BOOTPART} ${SWAPPART} ${ROOTPART} ${HOSTNAME} ${USER} >> /home/${USER}/.bashrc"
 	#myPrint "green" "\n\nInstallation complete! run exit, umount -R /mnt then reboot!\n\n"
fi    

if [ "${OPTION}" == "3" ]
then
	clearScreen		
	myPrint "green" "    ____           __        _____             \n"
	myPrint "green" "   /  _/___  _____/ /_____ _/ / (_)___  ____ _ \n"
	myPrint "green" "   / // __ \/ ___/ __/ __ \`/ / / / __ \/ __ \`/ \n"
	myPrint "green" " _/ // / / (__  ) /_/ /_/ / / / / / / / /_/ /  \n"
	myPrint "green" "/___/_/ /_/____/\__/\__,_/_/_/_/_/ /_/\__, /   \n"
	myPrint "green" "    __  __                 ____      /____/    \n"
	myPrint "green" "   / / / /_  ______  _____/ __ \____  / /______\n"
	myPrint "green" "  / /_/ / / / / __ \/ ___/ / / / __ \/ __/ ___/\n"
	myPrint "green" " / __  / /_/ / /_/ / /  / /_/ / /_/ / /_(__  ) \n"
	myPrint "green" "/_/ /_/\__, / .___/_/  /_____/\____/\__/____/  \n"
	myPrint "green" "      /____/_/                                 \n\n"

	#---------------Setting up pacman---------------
	bash -c "pacman -Syy &>/dev/null"
	bash -c "sudo pacman --noconfirm -S reflector &>/dev/null"
 	printf "\n"
  	printRunning "Setting up ${WHITE}pacman...${NC}"
	bash -c "sudo reflector --sort rate --latest 20 --protocol https --country Germany --save /etc/pacman.d/mirrorlist &>/dev/null"
 	printf "\r"
	printOK "Setting up ${WHITE}pacman...${NC}\n"
	#---------------Setting up pacman---------------
	
	#---------------Setting up HyprDots---------------
	printRunning "Setting up ${WHITE}HyprDots...${NC}"
	bash -c "sudo pacman --noconfirm -S nano &>/dev/null"
	bash -c "git clone https://github.com/prasanthrangan/hyprdots ~/HyprDots &>/dev/null"
	cd ~/HyprDots/Scripts
	bash -c "nano ./custom_hypr.lst"
	bash -c "nano ./.extra/custom_flat.lst"
	bash -c "sudo pacman --noconfirm -Runs nano &>/dev/null"
	printf "\r"
	printOK "Setting up ${WHITE}HyprDots...${NC}\n"
	#---------------Setting up HyprDots---------------

 	myPrint "green" "\nStarting installation in 3..."
  	sleep 1
	printf "\r"
  	myPrint "green" "Starting installation in 2..."
  	sleep 1
	printf "\r"
 	myPrint "green" "Starting installation in 1...\n\n"
	sleep 1

 	#bash -c "sed -i 's/${FILENAME} 3 ${DISK} ${CFDISK} ${BOOTPART} ${SWAPPART} ${ROOTPART} ${HOSTNAME} ${USER}/${FILENAME} 4 ${DISK} ${CFDISK} ${BOOTPART} ${SWAPPART} ${ROOTPART} ${HOSTNAME} ${USER}/g' ~/.bashrc"
 	bash -c "sed -i '/${FILENAME}/d' ~/.bashrc"
	bash -c "echo exec-once=kitty ./${FILENAME} 4 ${DISK} ${CFDISK} ${BOOTPART} ${SWAPPART} ${ROOTPART} ${HOSTNAME} ${USER} >> /home/${USER}/HyprDots/Configs/.config/hypr/userprefs.conf"
 	
	#---------------Installing HyprDots---------------
  	cd ~/HyprDots/Scripts
	bash -c "./install.sh -drs"
	#---------------Installing HyprDots---------------

fi

if [ "${OPTION}" == "4" ]
then
 	clearScreen	
	myPrint "green" "    ____           __        _____                   \n"
	myPrint "green" "   /  _/___  _____/ /_____ _/ / (_)___  ____ _       \n"
	myPrint "green" "   / // __ \/ ___/ __/ __ \`/ / / / __ \/ __ \`/       \n"
	myPrint "green" " _/ // / / (__  ) /_/ /_/ / / / / / / / /_/ /        \n"
	myPrint "green" "/___/_/ /_/____/\__/\__,_/_/_/_/_/ /_/\__, /         \n"
	myPrint "green" "   ______            _____          _/____/_         \n"
	myPrint "green" "  / ____/___  ____  / __(_)___ _   / __(_) /__  _____\n"
	myPrint "green" " / /   / __ \/ __ \/ /_/ / __ \`/  / /_/ / / _ \/ ___/\n"
	myPrint "green" "/ /___/ /_/ / / / / __/ / /_/ /  / __/ / /  __(__  ) \n"
	myPrint "green" "\____/\____/_/ /_/_/ /_/\__, /  /_/ /_/_/\___/____/  \n"
	myPrint "green" "                       /____/                        \n\n"

 	if [ "${USER}" == "" ]
	then
		myPrint "yellow" "Enter your normal username: "
		read USER
	fi
	
	#---------------Installing Config files---------------
	sudo bash -c "sudo echo -e '\n[Autologin]\nRelogin=false\nSession=hyprland\nUser=${USER}' >> /etc/sddm.conf.d/sddm.conf"
	sudo bash -c "sudo echo -e '/dev/nvme0n1p4      	/programmieren     	ext4      	rw,relatime	0 1' >> /etc/fstab"
	sudo bash -c "sudo echo -e '/dev/nvme0n1p5      	/spiele     	ext4      	rw,relatime	0 1' >> /etc/fstab"
	printf "\n\n"
 	printRunning "Installing ${WHITE}Config files...${NC}"
	bash -c "sed -i '/${FILENAME}/d' /home/${USER}/.config/hypr/userprefs.conf"	
 	bash -c "mv ~/.config/hypr/userprefs.conf ~/.config/hypr/userprefs.bak"
	cd ~/.config
	bash -c "git clone https://github.com/SchnuBby2205/HyprDots ./.schnubbyconfig &>/dev/null"
	bash -c "ln -s ~/.config/.schnubbyconfig/Configs/.config/hypr/userprefs.conf ~/.config/hypr/userprefs.conf"
	if [ -d "~/.local/share/lutris" ]; then
		bash -c "mv ~/.local/share/lutris ~/.local/share/lutris_bak"
	fi
	bash -c "ln -s ~/.config/.schnubbyconfig/Configs/.local/share/lutris ~/.local/share/lutris"
 	bash -c "rm -rf ~/.config/code-flags.conf"
  	bash -c "touch ~/.config/code-flags.conf"
 	bash -c "sed -i 's/{:%I:%M %p}/{:%R 󰃭 %d·%m·%y}/g' ~/.config/waybar/modules/clock.jsonc"
  	bash -c "sed -i '/format-alt/d' ~/.config/waybar/modules/clock.jsonc"
	bash -c "sed -i '/timestr=%I:%M %p/c\timestr=%H:%M %p' ~/.config/swaylock/config"
	printf "\r"
	printOK "Installing ${WHITE}Config files...${NC}\n\n"
 	#---------------Installing Config files---------------

 	#---------------Installing gaming dependencies---------------
 	#bash -c "yay arch gaming meta"
  	bash -c 'yes | LANG=C yay --noprovides --answerdiff None --answerclean None --mflags "--noconfirm" arch gaming meta'
 	#bash -c "yay -S dxvk-bin"
  	bash -c 'yes | LANG=C yay --noprovides --answerdiff None --answerclean None --mflags "--noconfirm" dxvk-bin'
  	#bash -c "yay -S wine-ge-custom"
	bash -c "sudo pacman -Syu &>/dev/null"
	bash -c "sudo pacman --noconfirm -S wine-staging &>/dev/null"
	printRunning "Installing ${WHITE}gaming dependencies...${NC}"
	bash -c "sudo pacman --noconfirm -S --needed --asdeps giflib lib32-giflib gnutls lib32-gnutls v4l-utils lib32-v4l-utils libpulse \
	lib32-libpulse alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib sqlite lib32-sqlite libxcomposite \
	lib32-libxcomposite ocl-icd lib32-ocl-icd libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs \
	lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader sdl2 lib32-sdl2 lib32-gamemode &>/dev/null"
 	bash -c "sudo pacman --noconfirm -S --needed lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader &>/dev/null"
	printf "\r"
	printOK "Installing ${WHITE}gaming dependencies...${NC}\n"
 	#---------------Installing gaming dependencies---------------

  	bash -c "Hyde-install"
  
 	sudo bash -c "rm -rf ~/${FILENAME}"
  	sudo bash -c "sed -i '/\.\/${FILENAME} 4 ${DISK} ${CFDISK} ${BOOTPART} ${SWAPPART} ${ROOTPART} ${HOSTNAME} ${USER}/d' ~/.bashrc"
	
	myPrint "green" "\n\nToDos:\n"
	#myPrint "yellow" "- Hyde-install\n"
	#myPrint "yellow" "- Install wine Drivers and Dependencies\n"
	myPrint "yellow" "- Bonjour or https://new-tab.sophia-dev.io + uBlock Origin for Firefox\n\n"

	myPrint "green" "Hints:\n"
	myPrint "yellow" "- kdwalletmanager (set empty password)\n"
 	myPrint "yellow" "  (if Brave was installed instead of Firefox and Brave cant open the kdwallet.)\n"
	myPrint "yellow" "- Install newest GE-Proton through Lutris Wine Downloads\n"
 	myPrint "yellow" "  (if there are Problems with Games.)\n"
	myPrint "yellow" "- Set https://SchnuBby2205:[created access token]@github.com under $HOME/. git-credentials"
 	myPrint "yellow" "  (if you want to use git from the terminal.)\n\n"

 	myPrint "green" "You can reboot the System now!\n\n"

  	#-new-tab -url https://github.com/GloriousEggroll/wine-ge-custom \
   	#-new-tab -url https://github.com/lutris/docs/blob/master/InstallingDrivers.md \
    	#-new-tab -url https://github.com/lutris/docs/blob/master/WineDependencies.md \
	bash -c "firefox -new-tab -url https://addons.mozilla.org/de/firefox/addon/bonjourr-startpage/ \
	-new-tab -url https://raw.githubusercontent.com/SchnuBby2205/W11Settings/refs/heads/main/bonjourr%20settings.json \
	-new-tab -url https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/"

  	myPrint "green" "Installation is finished! The system will reboot one last time!\n\n"
   
  	myPrint "green" "Reboot in 3..."
  	sleep 1
	printf "\r"
  	myPrint "green" "Reboot in 2..."
  	sleep 1
	printf "\r"
 	myPrint "green" "Reboot in 1...\n\n"
	sleep 1

      	bash -c "reboot"
fi

exit 0
