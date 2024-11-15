#!/bin/bash
# Konstanten für Farben und Cursor Bewegung
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
NC='\033[0m'
CHECK="\u2713"
CROSS="\u2717"
RUNNING="${YELLOW}•${NC}"
MYOK="${GREEN}${CHECK}${NC}"
ERROR="${RED}${CROSS}${NC}"
#RUNNING="[${YELLOW}  RUNNING  ${NC}]"
#MYOK="[${GREEN}    OK     ${NC}]"
#ERROR="[${RED}  ERROR    ${NC}]"
scriptname=$(basename "$0")
UP='\033[A'
DOWN='\033[B'
MOVE=""
MOVEBACK=""
# Functions
clearScreen() {
	bash -c clear
}
myPrint() {
	if [[ "${1}" == "green" ]];	then
		printf "${GREEN}${2}${NC}"
	fi
	if [[ "${1}" == "red" ]]; then
		printf "${RED}${2}${NC}"
	fi
	if [[ "${1}" == "yellow" ]]; then
		printf "${YELLOW}${2}${NC}"
	fi
 	if [[ "${1}" == "white" ]]; then
		printf "${WHITE}${2}${NC}"
	fi
}
Banner () {
	if [[ "${1}" == "install" ]]; then
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
	fi
	if [[ "${1}" == "arch" ]]; then
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
	fi
	if [[ "${1}" == "hypr" ]]; then
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
	fi
	if [[ "${1}" == "config" ]]; then
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
	fi
}
printStep() {
	if [[ "${1}" == 1 ]]; then
		printf "${RUNNING} ${2} ${WHITE}${3}${NC}\n"
		MOVE=${MOVE}${UP}
		MOVEBACK=${MOVEBACK}${DOWN}
 	else
		printf "${RUNNING}  ${2} ${WHITE}${3}${NC}"
		MOVE=${MOVE}${UP}
		MOVEBACK=${MOVEBACK}${DOWN}
 	fi
}
printStepOK() {
	if [[ "${1}" == 1 ]]; then
		MOVE=${MOVE}
		printf "${MOVE}${MYOK}"
		MOVE=""
		printf "${MOVEBACK}\r"
		MOVEBACK=""
 	else
		printf "\r${MYOK}\n"
 	fi
}
printError() {
	printf "\r${ERROR}\n"
	MOVE=${MOVE}
	printf "${MOVE}\r${ERROR}"
	MOVE=""
	printf "${MOVEBACK}\r"
	MOVEBACK=""
	exit 1
}
printCountDown() {
	local time=("$1")
	myPrint "green" "\n${2} ${time}..."
	for ((i=1; i<$((time - 1)); i++))
	do
		sleep 1
		myPrint "green" "\r${2} $((time-i))..."		
	done
	sleep 1 
	myPrint "green" "\r${2} $((time-i))...\n\n"	
	sleep 1 
}
printHelp() {
	Banner "install"
	myPrint "white" "You can specify script arguments, instead of entering them through the installer - those are:\n\n"
	myPrint "white" "\t--option:\t "
 	printf "which option to run.\n"
 	myPrint "white" "\t--disk:\t\t "
  	printf "which disk to use for cfdisk.\n"
  	myPrint "white" "\t--cfdisk:\t "
   	printf "run cfdisk?\n"
   	myPrint "white" "\t--boot:\t\t "
   	printf "bootpartition.\n"
   	myPrint "white" "\t--swap:\t\t "
   	printf "swappartition.\n"
   	myPrint "white" "\t--root:\t\t "
   	printf "rootpartition.\n"
	myPrint "white" "\t--hostname:\t "
 	printf "hostname for the OS.\n"
 	myPrint "white" "\t--user:\t\t "
  	printf "username for the normal user.\n"
  	myPrint "white" "\t--kernel:\t "
   	printf "which kernel to install (default: linux-lts).\n"
   	myPrint "white" "\t--cpu:\t\t "
    	printf "which CPU to install (intel-ucode // amd-ucode) (default: intel-ucode).\n"
   	myPrint "white" "\t--gpu:\t\t "
    	printf "which GPU to install (amd // nvidia) (default: amd).\n"
   	myPrint "white" "\t--timezone:\t\t "
    	printf "which timezone to use (default: Europe/Berlin).\n"
   	myPrint "white" "\t--locale:\t\t "
    	printf "which locale to user (default: de_DE.UTF-8\n"
   	myPrint "white" "\t--keymap:\t\t "
    	printf "which keymap to user (default: de-latin1).\n\n"
  	exit 0
}
runcmds() {
	local sudo=("$1")
	local mode=("$2")
	local message=("$3")
	shift 3
	printStep 0 "${mode}" "${message}"
 	for el in "$@"; do
		if [[ $sudo == 1 ]]; then 
			sudo bash -c "$el" || printError
		else
			bash -c "$el" || printError
		fi
  	done
	printStepOK 0
}
while [ $# -gt 0 ]; do
    if [[ $1 == "--"* ]]; then
	v="${1/--/}"
        if [[ "${v}" == "help" ]]; then
		printHelp
	fi
 	declare "$v"="$2"
        shift
    fi
    shift
done
if [[ "${cpu}" == "" ]]; then
	cpu="intel-ucode"
fi
if [[ "${kernel}" == "" ]]; then
	kernel="linux-lts"
fi
if [[ "${gpu}" == "" ]]; then
	gpu="amd"
fi
if [[ "${timezone}" == "" ]]; then
	timezone="Europe/Berlin"
fi
if [[ "${locale}" == "" ]]; then
	locale="de_DE.UTF-8"
fi
if [[ "${keymap}" == "" ]]; then
	keymap="de-latin1"
fi
if [[ "${option}" == "" ]]; then
	Banner "install"
 
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
	
	read option
fi
if [[ "${option}" == "" ]]; then
	exit 0
fi
if [[ "${option}" == "1" ]]; then
	Banner "arch"	
 	if [[ "${cfdisk}" == "" ]] && [[ "${disk}" != "" ]]; then
		myPrint "yellow" "\nStart cfdisk (y/N) ?\n"
		read cfdisk
  		if [[ "${cfdisk}" != "n" ]] && [[ "${cfdisk}" != "N" ]]; then
    			bash -c "cfdisk ${disk}"
    		fi
   	fi
 	if [[ "${cfdisk}" == "y" ]] || [[ "${cfdisk}" == "Y" ]] && [[ "${disk}" == "" ]]; then
		myPrint "yellow" "\nEnter disk\n"
		read disk
  		if [[ "${disk}" != "" ]]; then
    			bash -c "cfdisk ${disk}"
       		else
			printError "No disk entered -> exit\n"
			exit 0	 
    		fi
   	fi
	if [[ "${cfdisk}" == "y" ]] || [[ "${cfdisk}" == "Y" ]] && [[ "${disk}" != "" ]]; then
 		bash -c "cfdisk ${disk}"
 	fi
	if [[ "${boot}" == "" ]]; then
		myPrint "yellow" "\nEnter boot partition\n"
		read boot
  	fi 
	if [[ "${boot}" == "" ]]; then
		printError "No partition entered -> exit\n"
		exit 0
	fi	
	if [[ "${swap}" == "" ]]; then
		myPrint "yellow" "\nEnter swap partition\n"
		read swap
  	fi 
	if [[ "${swap}" == "" ]]; then
		printError "No partition entered -> exit\n"
		exit 0
	fi	
	if [[ "${root}" == "" ]]; then
		myPrint "yellow" "\nEnter root partition\n"
		read root
  	fi 
	if [[ "${root}" == "" ]]; then
		printError "No partition entered -> exit\n"
		exit 0
	fi
	myPrint "green" "\nBoot partition: "
	printf "${WHITE}${boot}${NC}\n"
	myPrint "green" "Swap partition: "
	printf "${WHITE}${swap}${NC}\n"
 	myPrint "green" "Root partition: "
	printf "${WHITE}${root}${NC}\n"
	printCountDown 3 "Starting installation in"
 	Banner "arch"
	printStep 1 "Installing" "base system..."
		runcmds 0 "Formatting" "drives..." "mkfs.fat -F 32 ${boot} &>/dev/null" "mkswap ${swap} &>/dev/null" "swapon ${swap} &>/dev/null" "mkfs.ext4 ${root} &>/dev/null"
		runcmds 0 "Mounting" "partitions..." "mount --mkdir ${root} /mnt" "mount --mkdir ${boot} /mnt/boot"
		runcmds 0 "Setting up" "pacman..." "pacman -Syy &>/dev/null" "pacman --noconfirm -S reflector &>/dev/null" "reflector --sort rate --latest 20 --protocol https --country Germany --save /etc/pacman.d/mirrorlist &>/dev/null" "sed -i '/ParallelDownloads/s/^#//' /etc/pacman.conf"
		runcmds 0 "Running" "pacstrap..." "pacstrap -K /mnt base base-devel ${kernel} linux-firmware ${cpu} efibootmgr grub sudo git networkmanager lutris &>/dev/null" "genfstab -U /mnt >> /mnt/etc/fstab" "cp ./${scriptname} /mnt"
	printStepOK 1
 	bash -c "arch-chroot /mnt ./${scriptname} --option 2 --hostname ${hostname} --user ${user} --gpu ${gpu}"
  	bash -c "umount -R /mnt &>/dev/null" 
	printCountDown 3 "Installation complete! Reboot in"
   	bash -c "reboot"
fi
if [[ "${option}" == "2" ]]; then
	printStep 1 "Configuring" "arch-chroot..."
		runcmds 0 "Setting" "localtime..." "ln -sf /usr/share/zoneinfo/${timezone} /etc/localtime &>/dev/null" "hwclock --systohc &>/dev/null"
		runcmds 0 "Setting up" "locales..." "sed -e '/${locale}/s/^#*//' -i /etc/locale.gen" "locale-gen &>/dev/null" "echo LANG=${locale} >> /etc/locale.conf" "echo KEYMAP=${keymap} >> /etc/vconsole.conf"
		runcmds 0 "Setting up" "GRUB..." "grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB &>/dev/null" "grub-mkconfig -o /boot/grub/grub.cfg &>/dev/null"
		runcmds 0 "Enabling" "services..." "systemctl enable NetworkManager &>/dev/null"
	printStepOK 1
	if [[ "${hostname}" == "" ]]; then
		myPrint "yellow" "\nEnter your Hostname: "
		read hostname
  	fi
	bash -c "echo ${hostname} >> /etc/hostname"       	
	myPrint "yellow" "\nEnter your NEW root password\n\n"
	bash -c "passwd"
	if [[ "${user}" == "" ]]; then
		myPrint "yellow" "\nEnter your normal username: "
		read user
	fi 
	bash -c "useradd -mG wheel ${user}"
	myPrint "yellow" "\nEnter your normal user password\n\n"
	bash -c "passwd ${user}"	
 	bash -c "sed -e '/%wheel ALL=(ALL:ALL) ALL/s/^#*//' -i /etc/sudoers"
   	bash -c "mv ./${scriptname} /home/${user}/"
	bash -c "echo ./${scriptname} --option 3 --user ${user} --gpu ${gpu} >> /home/${user}/.bashrc"
fi    
if [[ "${option}" == "3" ]]; then
	# Hier Pacman Mirrors abgleichen
 	if [[ "${user}" == "" ]]; then
		myPrint "yellow" "Enter your normal username: "
		read user
	fi	
 	bash -c "sudo pacman -Syy &>/dev/null"
 	bash -c "sudo pacman --noconfirm -S nano &>/dev/null"
 	Banner "hypr"
	printStep 1 "Setting up" "HyprDots..."
		runcmds 0 "Downloading" "HyprDots..." "git clone --depth 1 https://github.com/prasanthrangan/hyprdots ~/HyprDots &>/dev/null"
	printStepOK 1
 	bash -c "nano ./HyprDots/Scripts/custom_hypr.lst" 
  	bash -c "nano ./HyprDots/Scripts/.extra/custom_flat.lst"
   	bash -c "sudo pacman --noconfirm -Runs nano &>/dev/null"
	printCountDown 3 "Starting installation in"
 	bash -c "sed -i '/${scriptname}/d' ~/.bashrc"
	bash -c "echo exec-once=kitty ./${scriptname} --option 4 --user ${user} --gpu ${gpu} >> /home/${user}/HyprDots/Configs/.config/hypr/userprefs.conf"		
  	cd ~/HyprDots/Scripts
	bash -c "./install.sh -drs"
fi
if [[ "${option}" == "4" ]]; then
	Banner "config"
 	if [[ "${user}" == "" ]]; then
		myPrint "yellow" "Enter your normal username: "
		read user
	fi	
	if [[ "${gpu}" == "" ]]; then
		myPrint "yellow" "Enter your gpu (amd // nvidia)): "
		read gpu
	fi	
	printStep 1 "Installing" "Config files..."
		runcmds 1 "Setting" "autologin..." "sudo echo -e '\n[Autologin]\nRelogin=false\nSession=hyprland\nUser=${user}' >> /etc/sddm.conf.d/sddm.conf"
		runcmds 1 "Configuring" "fstab..." "sudo echo -e '/dev/nvme0n1p4      	/programmieren     	ext4      	rw,relatime	0 1' >> /etc/fstab" "sudo echo -e '/dev/nvme0n1p5      	/spiele     	ext4      	rw,relatime	0 1' >> /etc/fstab"
		if [[ -f "/home/${user}/.config/hypr/userprefs.conf" ]]; then
			runcmds 0 "Backing up" "HyprDots userprefs.conf..." "sed -i '/${scriptname}/d' /home/${user}/.config/hypr/userprefs.conf" "mv ~/.config/hypr/userprefs.conf ~/.config/hypr/userprefs.bak"
		fi
		cd ~/.config
		if [[ ! -d "~/.config/.schnubbyconfig" ]]; then
			runcmds 0 "Cloning" "SchnuBbyconfig..." "git clone --depth 1 https://github.com/SchnuBby2205/HyprDots ~/.config/.schnubbyconfig &>/dev/null"
		fi
 	printStepOK 1
		if [[ ! -f "~/.config/hypr/userprefs.conf" ]]; then
			bash -c "ln -s ~/.config/.schnubbyconfig/Configs/.config/hypr/userprefs.conf ~/.config/hypr/userprefs.conf"
		fi
		if [[ -d "~/.local/share/lutris" ]]; then
			bash -c "mv ~/.local/share/lutris ~/.local/share/lutris_bak"
		fi 	
		if [[ ! -d "~/.local/share/lutris" ]]; then
			bash -c "ln -s ~/.config/.schnubbyconfig/Configs/.local/share/lutris ~/.local/share/lutris" 	
		fi
	printStep 1 "Running" "final steps..."
		runcmds 0 "Removing flags from" "code-flags.conf..." "rm -rf ~/.config/code-flags.conf" "touch ~/.config/code-flags.conf"   	
		runcmds 0 "Configuring" "~/.config/waybar/modules/clock.jsonc..." "sed -i 's/{:%I:%M %p}/{:%R 󰃭 %d·%m·%y}/g' ~/.config/waybar/modules/clock.jsonc" "sed -i '/format-alt/d' ~/.config/waybar/modules/clock.jsonc"
		runcmds 0 "Configuring" "~/.config/swaylock/config..." "sed -i '/timestr=%I:%M %p/c\timestr=%H:%M %p' ~/.config/swaylock/config"
		runcmds 0 "Downloading" "Wine dependencies..." "sudo pacman -Syu &>/dev/null" "sudo pacman  --noconfirm -S wine-staging &>/dev/null" "sudo pacman  --noconfirm -S --needed --asdeps giflib lib32-giflib gnutls lib32-gnutls v4l-utils lib32-v4l-utils libpulse lib32-libpulse alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib sqlite lib32-sqlite libxcomposite lib32-libxcomposite ocl-icd lib32-ocl-icd libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader sdl2 lib32-sdl2 lib32-gamemode &>/dev/null"
		if [[ "${gpu}" == "amd" ]]; then
			runcmds 0 "Downloading" "graphics drivers..." "sudo pacman  --noconfirm -S --needed lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader &>/dev/null"
		fi
		if [[ "${gpu}" == "nvidia" ]]; then
			runcmds 0 "Downloading" "graphics drivers..." "sudo pacman  --noconfirm -S --needed nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader &>/dev/null"
		fi
	printStepOK 1
	bash -c "yay arch gaming meta"
	bash -c "yay dxvk-bin"
  	bash -c "Hyde-install"  
 	sudo bash -c "rm -rf ~/${scriptname}"	
	myPrint "green" "\n\nToDos:\n"
	myPrint "yellow" "- Bonjour or https://new-tab.sophia-dev.io + uBlock Origin for Firefox\n\n"
	myPrint "green" "Hints:\n"
	myPrint "yellow" "- kdwalletmanager (set empty password)\n"
 	myPrint "yellow" "  (if Brave was installed instead of Firefox and Brave cant open the kdwallet.)\n"
	myPrint "yellow" "- Install newest GE-Proton through Lutris Wine Downloads\n"
 	myPrint "yellow" "  (if there are Problems with Games.)\n"
	myPrint "yellow" "- Set https://SchnuBby2205:[created access token]@github.com under $HOME/. git-credentials"
 	myPrint "yellow" "  (if you want to use git from the terminal.)\n\n"
	bash -c "firefox -new-tab -url https://addons.mozilla.org/de/firefox/addon/bonjourr-startpage/ \
	-new-tab -url https://raw.githubusercontent.com/SchnuBby2205/W11Settings/refs/heads/main/bonjourr%20settings.json \
	-new-tab -url https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/"
  	myPrint "green" "Installation is finished! The system will reboot one last time!\n\n"   
  	printCountDown 3 "Reboot in"
    bash -c "reboot"
fi
exit 0
