#!/bin/bash

# Konstanten für Farben
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
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

OPTION=""
printf "["
myPrint "yellow" "1"
printf "]: Install "
myPrint "yellow" "Arch\n"

printf "["
myPrint "yellow" "2"
printf "]: Install "
myPrint "yellow" "HyprDots\n"

printf "["
myPrint "yellow" "3"
printf "]: Install "
myPrint "yellow" "Config files\n\n"

read OPTION

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
	
	bash -c lsblk
	
	myPrint "yellow" "\nEnter drive\n"
	read DISK
	
	if [ "${DISK}" == "" ]
	then
		printError "No drive entered -> exit\n"
		exit 0
	fi
	
	myPrint "yellow" "\nStart cfdisk (y/N) ?\n"
	read CFDISK
	
	if [ "${CFDISK}" == "y" ] || [ "${CFDISK}" == "Y" ]
	then
		bash -c cfdisk ${DISK}
	fi
	
	myPrint "yellow" "\nEnter root partition\n"
	read ROOTPART
	if [ "${ROOTPART}" == "" ]
	then
		printError "No partition entered -> exit\n"
		exit 0
	fi
	
	myPrint "yellow" "\nEnter boot partition\n"
	read BOOTPART
	if [ "${BOOTPART}" == "" ]
	then
		printError "No partition entered -> exit\n"
		exit 0
	fi
	
	myPrint "yellow" "\nEnter swap partition\n"
	read SWAPPART
	if [ "${SWAPPART}" == "" ]
	then
		printError "No partition entered -> exit\n"
		exit 0
	fi
	
	myPrint "green" "\nRoot partition: "
	myPrint "yellow" "${ROOTPART}\n"
	myPrint "green" "Boot partition: "
	myPrint "yellow" "${BOOTPART}\n"
	myPrint "green" "Swap partition: "
	myPrint "yellow" "${SWAPPART}\n\n"
	
	#-----------------------------------------------------------
	printRunning "Formatting Drives"
	
	bash -c "mkfs.fat -F 32 ${BOOTPART} &>/dev/null"
	printf "\r"
	printRunning "Formatting Drives (25%%)"
	bash -c "mkfs.ext4 ${ROOTPART} &>/dev/null"
	printf "\r"
	printRunning "Formatting Drives (50%%)"
	bash -c "mkswap ${SWAPPART} &>/dev/null"
	printf "\r"
	printRunning "Formatting Drives (75%%)"
	bash -c "swapon ${SWAPPART} &>/dev/null"
	
	printf "\r"
	printOK "Formatting Drives      \n"
	#-----------------------------------------------------------
	
	#-----------------------------------------------------------
	printRunning "Mounting partitions"

 	bash -c "mount --mkdir ${ROOTPART} /mnt &>/dev/null"
 	printf "\r"
	printRunning "Mounting partitions (50%%)"
	bash -c "mount --mkdir ${BOOTPART} /mnt/boot &>/dev/null"

	printf "\r"
	printOK "Mounting partitions      \n"
	#-----------------------------------------------------------

	#-----------------------------------------------------------
	printRunning "Setting up pacman"

	bash -c "pacman -S reflector &>/dev/null"
	printf "\r"
	printRunning "Setting up pacman (25%%)"
	bash -c "reflector --sort rate --latest 20 --protocol https --save /etc/pacman.d/mirrorlist &>/dev/null"
	printf "\r"
	printRunning "Setting up pacman (50%%)"
	#bash -c "pacman -S nano &>/dev/null"
	printf "\r"
	printRunning "Setting up pacman (75%%)"
	bash -c "sed -i '/ParallelDownloads/s/^#//' /etc/pacman.conf"

	printf "\r"
	printOK "Setting up pacman      \n\n"
	#-----------------------------------------------------------

 	myPrint "green" "Starting installation in 3..."
  	sleep 1
	printf "\r"
  	myPrint "green" "Starting installation in 2..."
  	sleep 1
	printf "\r"
 	myPrint "green" "Starting installation in 1..."
	sleep 1
	bash -c "archinstall --conf https://raw.githubusercontent.com/SchnuBby2205/ArchInstall/main/conf.json --creds https://raw.githubusercontent.com/SchnuBby2205/ArchInstall/main/creds.json"
	bash -c "cp ./ArchInstall.sh /mnt/home/schnubby/ &>/dev/null"
fi

if [ "${OPTION}" == "2" ]
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

	#-----------------------------------------------------------
	printRunning "Setting up pacman"

	bash -c "yes | sudo pacman -S reflector &>/dev/null"
	printf "\r"
	printRunning "Setting up pacman (25%%)"
	bash -c "sudo reflector --sort rate --latest 20 --protocol https --save /etc/pacman.d/mirrorlist &>/dev/null"
	printf "\r"
	printRunning "Setting up pacman (50%%)"
	#bash -c "sed -i '/ParallelDownloads/s/^#//' /etc/pacman.conf"

	printf "\r"
	printOK "Setting up pacman      \n"
	#-----------------------------------------------------------
	
	#-----------------------------------------------------------
	printRunning "Setting up HyprDots"

	bash -c "yes | sudo pacman -S nano &>/dev/null"
	printf "\r"
	printRunning "Setting up HyprDots (25%%)"
	bash -c "git clone https://github.com/prasanthrangan/hyprdots ~/Hyprdots &>/dev/null"
	printf "\r"
	printRunning "Setting up HyprDots (50%%)"
	cd ~/HyprDots/Scripts
	printf "\r"
	printRunning "Setting up HyprDots (75%%)"
	bash -c "nano custom_hypr.lst"
	bash -c "nano ./.extra/custom_flat.lst"
	cd ..
	bash -c "sudo pacman -Runs nano &>/dev/null"

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
	printOK "Setting up pacman      \n"
	printOK "Setting up hyprDots\n\n"
	#-----------------------------------------------------------
	
 	myPrint "green" "Starting installation in 3..."
  	sleep 1
	printf "\r"
  	myPrint "green" "Starting installation in 2..."
  	sleep 1
	printf "\r"
 	myPrint "green" "Starting installation in 1..."
	sleep 1
	bash -c "./install.sh -drs"

fi

if [ "${OPTION}" == "3" ]
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
	
	#-----------------------------------------------------------
	printRunning "Installing Config files"

	#bash -c "sudo rm -rf ~/.config/hypr/userprefs.conf &>/dev/null"
	bash -c "mv ~/.config/hypr/userprefs.conf ~/.config/hypr/userprefs.bak"
	printf "\r"
	printRunning "Installing Config files (15%%)"
	#bash -c "curl -o ~/.config/hypr/userprefs.conf https://raw.githubusercontent.com/SchnuBby2205/hyprdots/refs/heads/main/Configs/.config/hypr/userprefs.conf &>/dev/null"
	cd ~/.config
	bash -c "git clone https://github.com/SchnuBby2205/HyprDots ./.schnubbyconfig &>/dev/null"
	bash -c "ln -s ~/.config/.schnubbyconfig/Configs/.config/hypr/userprefs.conf ~/.config/hypr/userprefs.conf"
	bash -c "mv ~/.local/share/lutris ~/.local/share/lutris_bak"
	bash -c "ln -s ~/.config/.schnubbyconfig/Configs/.local/share/lutris ~/.local/share/lutris"
	printf "\r"
	printRunning "Installing Config files (30%%)"
	#bash -c "nano .config/code-flags.conf"
 	bash -c "rm -rf ~/.config/code-flags.conf &>/dev/null"
  	bash -c "touch ~/.config/code-flags.conf &>/dev/null"
   
	#bash -c "nano .config/waybar/modules/clock.jsonc"
 	bash -c "sed -i '/{:%I:%M %p}/c\{:%R 󰃭 %d·%m·%y}' ~/.config/waybar/modules/clock.jsonc"
  
	#bash -c "nano .config/swaylock/config"
	bash -c "sed -i '/timestr=%I:%M %p/c\timestr=%H:%M %p' ~/.config/swaylock/config"
  
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
	printRunning "Installing Config files (45%%)"
	bash -c "yay arch gaming meta &>/dev/null"
	printf "\r"
	printRunning "Installing Config files (60%%)"
	bash -c "sudo echo -e '\n[Autologin]\nRelogin=false\nSession=hyprland\nUser=schnubby' >> /etc/sddm.conf.d/sddm.conf"
	printf "\r"
	printRunning "Installing Config files (75%%)"
	bash -c "sudo echo -e '/dev/nvme0n1p4      	/programmieren     	ext4      	rw,relatime	0 1' >> /etc/fstab"
	bash -c "sudo echo -e '/dev/nvme0n1p5      	/spiele     	ext4      	rw,relatime	0 1' >> /etc/fstab"

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
	printOK "Installing Config files\n\n"
	#-----------------------------------------------------------	
	
	myPrint "green" "ToDos:\n"
	myPrint "yellow" "- Hyde-install\n"
	#myPrint "yellow" "- Install newest GE-Proton to /home/schnubby/.local/share/lutris/runners/wine/\n"
	myPrint "yellow" "- Install Drivers and wine Dependencies\n"
	myPrint "yellow" "- Bonjour or https://new-tab.sophia-dev.io + uBlock Origin for Firefox\n\n"
	myPrint "yellow" "- Set https://SchnuBby2205:[created access token]@github.com under $HOME/. git-credentials"

	myPrint "green" "Hints:\n"
	myPrint "yellow" "- kdwalletmanager (set empty password) if Brave cant open the wallet\n"
	myPrint "yellow" "- sddm-config-git if autologin doesnt work\n\n"
	#myPrint "yellow" "- Set Play > Configure DLL Override key: location.dll value: disabled for Hearthstone in Lutris\n\n"

	bash -c "firefox https://github.com/GloriousEggroll/wine-ge-custom"
  	bash -c "firefox https://github.com/lutris/docs/blob/master/InstallingDrivers.md"
   	bash -c "firefox https://github.com/lutris/docs/blob/master/WineDependencies.md"
 	bash -c "firefox https://addons.mozilla.org/de/firefox/addon/bonjourr-startpage/"
  	bash -c "firefox https://raw.githubusercontent.com/SchnuBby2205/W11Settings/refs/heads/main/bonjourr%20settings.json"
	bash -c "firefox https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/"

fi

exit 0
