#!/bin/bash

# Konstanten für Farben
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
NC='\033[0m'
RUNNING="[${YELLOW}  RUNNING ${NC}]"
MYOK="[${GREEN}    OK    ${NC}]"
ERROR="[${RED}  ERROR   ${NC}]"
scriptname=$(basename "$0")
UP='\033[A'
CL='\033[2K'
DOWN='\033[B'
MOVE=""
MOVEBACK=""

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
 	if [ "${color}" == "white" ]
	then
		printf "${WHITE}${message}${NC}"
	fi
}
Banner () {
	banner="$1"
	if [[ "${banner}" == "install" ]]; then
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
	if [[ "${banner}" == "arch" ]]; then
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
	if [[ "${banner}" == "hypr" ]]; then
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
	if [[ "${banner}" == "config" ]]; then
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
printMain() {
	mode="$1"
	message="$2"
	printf "${RUNNING}   ${WHITE}${mode}${NC} ${message}\n"
	MOVE=${MOVE}${UP}
	MOVEBACK=${MOVEBACK}${DOWN}
}
printMainOK() {
	MOVE=${MOVE}${CL}
	mode="$1"
	message="$2"
	printf "${MOVE}${MYOK}   ${WHITE}${mode}${NC} ${message}"
	MOVE=""
	printf "${MOVEBACK}\r"
	MOVEBACK=""
}
printStep() {
	mode="$1"
	message="$2"
	printf "\t${RUNNING}   ${WHITE}${mode}${NC} ${message}"
	MOVE=${MOVE}${UP}
	MOVEBACK=${MOVEBACK}${DOWN}
}
printStepOK() {
	mode="$1"
	message="$2"
	printf "\r\t${MYOK}   ${WHITE}${mode}${NC} ${message}\n"
}
printError() {
	message="$1"
	printf "${ERROR}   ${message}"
}
run() {
	_modes=$1
	_steps=$2
	_cmds=$3
	for i in "${!_cmds[@]}"; do
		printStep "${_modes[i]}" "${_steps[i]}"
		printf 	"${_cmds[i]}"
	  bash -c "${_cmds[i]}"
		printStepOK "${_modes[i]}" "${_steps[i]}"
	done
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
  printf "which kernel to install.\n"
  myPrint "white" "\t--cpu:\t\t "
  printf "which CPU to install (intel-ucode // amd-ucode).\n"
  myPrint "white" "\t--gpu:\t\t "
  printf "which GPU to install (amd // nvidia).\n\n"
 	exit 0
}

# Work
Banner "install"

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

if [ "${cpu}" == "" ]
then
	cpu="intel-ucode"
fi

if [ "${kernel}" == "" ]
then
	kernel="linux-lts"
fi

if [ "${gpu}" == "" ]
then
	gpu="amd"
fi

if [ "${option}" == "" ]
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
	
	read option
 fi

if [ "${option}" == "" ]
then
	exit 0
fi

if [ "${option}" == "1" ]
then
	Banner "arch"	
	bash -c "lsblk"
	
	if [ "${disk}" == "" ] && [ "${cfdisk}" == "y" ] || [ "${disk}" == "" ] && [ "${cfdisk}" == "Y" ]
	then
		myPrint "yellow" "\nEnter drive\n"
		read disk
  	fi
	
	if [ "${disk}" == "" ] && [ "${cfdisk}" == "y" ] || [ "${disk}" == "" ] && [ "${cfdisk}" == "Y" ]
	then
		printError "No drive entered -> exit\n"
		exit 0
	fi
	
	if [ "${cfdisk}" == "" ] && [ "${disk}" != "" ]
	then
		myPrint "yellow" "\nStart cfdisk (y/N) ?\n"
		read cfdisk
  	fi
	
	if [ "${cfdisk}" == "y" ] || [ "${cfdisk}" == "Y" ]
	then
		bash -c "cfdisk ${disk}"
	fi
	
	if [ "${boot}" == "" ]
	then
		myPrint "yellow" "\nEnter boot partition\n"
		read boot
  	fi
 
	if [ "${boot}" == "" ]
	then
		printError "No partition entered -> exit\n"
		exit 0
	fi
	
	if [ "${swap}" == "" ]
	then
		myPrint "yellow" "\nEnter swap partition\n"
		read swap
  	fi
 
	if [ "${swap}" == "" ]
	then
		printError "No partition entered -> exit\n"
		exit 0
	fi
	
	if [ "${root}" == "" ]
	then
		myPrint "yellow" "\nEnter root partition\n"
		read root
  	fi
 
	if [ "${root}" == "" ]
	then
		printError "No partition entered -> exit\n"
		exit 0
	fi

	myPrint "green" "\nBoot partition: "
	printf "${WHITE}${boot}${NC}\n"
	myPrint "green" "Swap partition: "
	printf "${WHITE}${swap}${NC}\n"
 	myPrint "green" "Root partition: "
	printf "${WHITE}${root}${NC}\n\n"
	
 	myPrint "green" "Starting installation in 3..."
  sleep 1
	printf "\r"
  myPrint "green" "Starting installation in 2..."
  sleep 1
	printf "\r"
 	myPrint "green" "Starting installation in 1...\n\n"
	sleep 1

	Banner "arch"

  #---------------Formatting Drives---------------		
	printMain "Formatting" "drives..."
	modes=("Formatting" "Enabling" "Turning on" "Formatting")
	steps=("boot partition ${boot}..." "swap ${swap}..." "swap ${swap}..." "root partition ${root}...")
	cmds=("mkfs.fat -F 32 ${boot} &>/dev/null" "mkswap ${swap} &>/dev/null" "swapon ${swap} &>/dev/null" "mkfs.ext4 ${root} &>/dev/null")
	run ${modes} ${steps} ${cmds}
	printMainOK "Formatting" "drives..."
	#---------------Formatting Drives---------------		
	
	#---------------Mounting partitions---------------
	printMain "Mounting" "partitions..."
	modes=("Mounting" "Mounting")
	steps=("${root} to /mnt..." "${boot} to /mnt/boot...")
	cmds=("mount --mkdir ${root} /mnt" "mount --mkdir ${boot} /mnt/boot")
	run $modes $steps $cmds
	printMainOK "Mounting" "partitions..."
	#---------------Mounting partitions---------------

	#---------------Setting up pacman---------------
	printMain "Setting up" "pacman..."
	modes=("Updating" "Downloading" "Sorting" "Enabling")
	steps=("package database..." "reflector..." "mirrors..." "5 parallel downloads for pacman...")
	cmds=("pacman -Syy &>/dev/null" "pacman --noconfirm -S reflector &>/dev/null" "reflector --sort rate --latest 20 --protocol https --country Germany --save /etc/pacman.d/mirrorlist &>/dev/null" "sed -i '/ParallelDownloads/s/^#//' /etc/pacman.conf")
	run $modes $steps $cmds
	printMainOK "Setting up" "pacman..."
	#---------------Setting up pacman---------------

 	#---------------Running base install---------------
	printMain "Running" "base install..."
	modes=("Running" "Generating" "Copying")
	steps=("pacstrap..." "fstab..." "script ${scriptname} to /mnt...")
	cmds=("pacstrap -K /mnt base base-devel ${kernel} linux-firmware ${cpu} efibootmgr grub sudo git networkmanager lutris &>/dev/null" "genfstab -U /mnt >> /mnt/etc/fstab" "cp ./${scriptname} /mnt")
	run $modes $steps $cmds
	printMainOK "Running" "base install..."
 	#---------------Running base install---------------

	bash -c "arch-chroot /mnt ./${scriptname} --option 2 --hostname ${hostname} --user ${user} --gpu ${gpu}"
	bash -c "umount -R /mnt &>/dev/null"

  myPrint "green" "\nInstallation complete! Reboot in 3..."
  sleep 1
	printf "\r"
  myPrint "green" "Installation complete! Reboot in 2..."
  sleep 1
	printf "\r"
 	myPrint "green" "Installation complete! Reboot in 1...\n\n"
	sleep 1

  bash -c "reboot"

fi

if [ "${option}" == "2" ]
then
	#---------------Setting up localtime---------------
	printMain "Setting up" "localtime..."
	modes=("Creating" "Syncing")
	steps=("symlink to /etc/localtime (Europe/Berlin)..." "hardwareclock...")
	cmds=("ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime &>/dev/null" "hwclock --systohc &>/dev/null" )
	run $modes $steps $cmds
	printMainOK "Setting up" "localtime..."
	#---------------Setting up localtime---------------

	#---------------Setting up locale---------------
	printMain "Setting up" "locales..."
	modes=("Configuring" "Generating" "Configuring" "Configuring")
	steps=("/etc/locale.gen (de_DE.UTF-8)..." "locales..." "/etc/locale.conf (de_DE.UTF-8)..." "/etc/vconsole.conf (de-latin1)...")
	cmds=("sed -e '/de_DE.UTF-8/s/^#*//' -i /etc/locale.gen" "locale-gen &>/dev/null" "echo LANG=de_DE.UTF-8 >> /etc/locale.conf" "echo KEYMAP=de-latin1 >> /etc/vconsole.conf")
	run $modes $steps $cmds
	printMainOK "Setting up" "locales..."
	#---------------Setting up locale---------------

	#---------------Setting up GRUB---------------
	printMain "Setting up" "GRUB..."
	modes=("Installing" "Making")
	steps=("GRUB to /boot..." "GRUB config...")
	cmds=("grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB &>/dev/null" "grub-mkconfig -o /boot/grub/grub.cfg &>/dev/null")
	run $modes $steps $cmds
	printMainOK "Setting up" "GRUB..."
	#---------------Setting up GRUB---------------

	if [ "${hostname}" == "" ]
	then
  	myPrint "yellow" "\nEnter your Hostname: "
  	read hostname
  fi
	bash -c "echo ${hostname} >> /etc/hostname"
       	
	myPrint "yellow" "\nEnter your NEW root password\n\n"
	bash -c "passwd"

	if [ "${user}" == "" ]
	then
		myPrint "yellow" "\nEnter your normal username: "
		read user
	fi
 
	bash -c "useradd -mG wheel ${user}"
	myPrint "yellow" "\nEnter your normal user password\n\n"
	bash -c "passwd ${user}"	

 	bash -c "sed -e '/%wheel ALL=(ALL:ALL) ALL/s/^#*//' -i /etc/sudoers"

	#---------------Enabling services---------------
  printMain "Enabling" "services..."
	modes=("Enabling")
	steps=("NetworkManager...")
	cmds=("systemctl enable NetworkManager &>/dev/null")
	run $modes $steps $cmds
  printMainOK "Enabling" "services..."
	#---------------Enabling services---------------

  bash -c "mv ./${scriptname} /home/${user}/"
	bash -c "echo ./${scriptname} --option 3 --user ${user} --gpu ${gpu} >> /home/${user}/.bashrc"
fi    

if [ "${option}" == "3" ]
then
	Banner "hypr"

	#---------------Setting up pacman---------------
	bash -c "pacman -Syy &>/dev/null"
	#bash -c "sudo pacman --noconfirm -S reflector &>/dev/null"
 	#printf "\n"
  #printMain "Setting up" "pacman..."
	#modes=("Sorting")
	#steps=("mirrors...")
	#cmds=("sudo reflector --sort rate --latest 20 --protocol https --country Germany --save /etc/pacman.d/mirrorlist &>/dev/null")
	#run $modes $steps $cmds
	#---------------Setting up pacman---------------

	#---------------Setting up HyprDots---------------
	printMain "Setting up" "HyprDots..."
	modes=("Downloading" "Cloning" "Configuring" "Configuring" "Removing")
	steps=("nano..." "HyprDots..." "custom_hypr..." "custom_flat..." "nano...")
	cmds=("sudo pacman --noconfirm -S nano &>/dev/null" "git clone https://github.com/prasanthrangan/hyprdots ~/HyprDots &>/dev/null" "nano ./custom_hypr.lst" "nano ./.extra/custom_flat.lst" "sudo pacman --noconfirm -Runs nano &>/dev/null")
	run $modes $steps $cmds
	printMainOK "Setting up" "HyprDots..."
	#---------------Setting up HyprDots---------------

 	myPrint "green" "\nStarting installation in 3..."
  sleep 1
	printf "\r"
  myPrint "green" "Starting installation in 2..."
  sleep 1
	printf "\r"
 	myPrint "green" "Starting installation in 1...\n\n"
	sleep 1

 	bash -c "sed -i '/${scriptname}/d' ~/.bashrc"
	bash -c "echo exec-once=kitty ./${scriptname} --option 4 --user ${user} --gpu ${gpu} >> /home/${user}/HyprDots/Configs/.config/hypr/userprefs.conf"
		
	#---------------Installing HyprDots---------------
  cd ~/HyprDots/Scripts
	bash -c "./install.sh -drs"
	#---------------Installing HyprDots---------------

fi

if [ "${option}" == "4" ]
then
	Banner "config"

 	if [ "${user}" == "" ]
	then
		myPrint "yellow" "Enter your normal username: "
		read user
	fi
	
	#---------------Installing Config files---------------
	sudo bash -c "sudo echo -e '\n[Autologin]\nRelogin=false\nSession=hyprland\nUser=${user}' >> /etc/sddm.conf.d/sddm.conf"
	sudo bash -c "sudo echo -e '/dev/nvme0n1p4      	/programmieren     	ext4      	rw,relatime	0 1' >> /etc/fstab"
	sudo bash -c "sudo echo -e '/dev/nvme0n1p5      	/spiele     	ext4      	rw,relatime	0 1' >> /etc/fstab"		
	printf "\n\n"
 	printMain "Installing" "Config files..."

  printStep "Backing up" "HyprDots userprefs.conf..."
	bash -c "sed -i '/${scriptname}/d' /home/${user}/.config/hypr/userprefs.conf"
	bash -c "mv ~/.config/hypr/userprefs.conf ~/.config/hypr/userprefs.bak"
	cd ~/.config
  printStepOK "Backing up" "HyprDots userprefs.conf..."
	
	printStep "Cloning" "SchnuBbyconfig..."
	bash -c "git clone https://github.com/SchnuBby2205/HyprDots ./.schnubbyconfig &>/dev/null"
	printStepOK "Cloning" "SchnuBbyconfig..."
 	
	printStep "Creating symlink to" "userprefs.conf..."
	bash -c "ln -s ~/.config/.schnubbyconfig/Configs/.config/hypr/userprefs.conf ~/.config/hypr/userprefs.conf"
	if [ -d "~/.local/share/lutris" ]; then
		bash -c "mv ~/.local/share/lutris ~/.local/share/lutris_bak"
	fi
	printStepOK "Creating symlink to" "userprefs.conf..."
 	
	printStep "Creating symlink to" "lutris..."
	bash -c "ln -s ~/.config/.schnubbyconfig/Configs/.local/share/lutris ~/.local/share/lutris"
	printStepOK "Creating symlink to" "lutris..."
 	
	printStep "Removing flags from" "code-flags.conf..."
 	bash -c "rm -rf ~/.config/code-flags.conf"
  bash -c "touch ~/.config/code-flags.conf"
	printStepOK "Removing flags from" "code-flags.conf..."
   	
	printStep "Configuring" "~/.config/waybar/modules/clock.jsonc..."
 	bash -c "sed -i 's/{:%I:%M %p}/{:%R 󰃭 %d·%m·%y}/g' ~/.config/waybar/modules/clock.jsonc"
  bash -c "sed -i '/format-alt/d' ~/.config/waybar/modules/clock.jsonc"
	printStep "Configuring" "~/.config/waybar/modules/clock.jsonc..."
   	
	printStep "Configuring" "~/.config/swaylock/config..."
	bash -c "sed -i '/timestr=%I:%M %p/c\timestr=%H:%M %p' ~/.config/swaylock/config"
	printStepOK "Configuring" "~/.config/swaylock/config..."
 	printMainOK "Installing" "Config files..."
 	#---------------Installing Config files---------------

 	#---------------Installing gaming dependencies---------------
	printMain "Installing" "gaming dependencies..."
	modes=("Downloading" "Downloading")
	steps=("arch gaming meta" "dxvk-bin")
	cmds=('yes | LANG=C yay --noprovides --answerdiff None --answerclean None --mflags "--noconfirm" arch gaming meta' 'yes | LANG=C yay --noprovides --answerdiff None --answerclean None --mflags "--noconfirm" dxvk-bin')
	run $modes $steps $cmds
 	printStep "Downloading" "Wine dependencies..."
	bash -c "sudo pacman -Syu &>/dev/null"
	bash -c "sudo pacman  --noconfirm -S wine-staging &>/dev/null"
	bash -c "sudo pacman  --noconfirm -S --needed --asdeps giflib lib32-giflib gnutls lib32-gnutls v4l-utils lib32-v4l-utils libpulse \
	lib32-libpulse alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib sqlite lib32-sqlite libxcomposite \
	lib32-libxcomposite ocl-icd lib32-ocl-icd libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs \
	lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader sdl2 lib32-sdl2 lib32-gamemode &>/dev/null"
 	printStepOK "Downloading" "Wine dependencies..."

 	printStep "Downloading" "graphics drivers..."
 	if [ "${gpu}" == "amd" ]
	then
 		bash -c "sudo pacman  --noconfirm -S --needed lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader &>/dev/null"
  fi
 	if [ "${gpu}" == "nvidia" ]
	then
  		bash -c "sudo pacman  --noconfirm -S --needed nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader &>/dev/null"
	fi
 	printStepOK "Downloading" "graphics drivers..."
	printMainOK "Installing" "gaming dependencies..."
 	#---------------Installing gaming dependencies---------------

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
