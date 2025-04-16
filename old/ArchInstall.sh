#!/bin/bash
# Farben im Terminal
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
NC='\033[0m'
CHECK="\u2713"
CROSS="\u2717"
RUNNING="${YELLOW}•${NC}"
MYOK="${GREEN}${CHECK}${NC}"
ERROR="${RED}${CROSS}${NC}"
# Bewegung im Terminal
UP='\033[A'
DOWN='\033[B'
MOVE=""
MOVEBACK=""
scriptname=$(basename "$0")
# Hilfsfunktionen
function clearScreen() {
	clear
}
function myPrint() {
	local color=$1 message=$2	
	case $color in
		green) printf "${GREEN}${message}${NC}" ;;
		red)  printf "${RED}${message}${NC}" ;;
		yellow)  printf "${YELLOW}${message}${NC}" ;;
		white)  printf "${WHITE}${message}${NC}" ;;
		*)  printf "${message}" ;;
	esac
}
function exitWithError() {
	local message=$1
	printf "\n${ERROR} ${message}\n"
	exit 1
}
function getInput() {
	local prompt=$1 varName=$2 defaultValue=$3
	printf "${YELLOW}${prompt} ${NC}"
	read -r inputValue
	if [[ -z "$inputValue" ]]; then
		#eval "$varName='$defaultValue'"
		printf -v "$varName" "%s" "$defaultValue"
	else
		#eval "$varName='$inputValue'"
		printf -v "$varName" "%s" "$inputValue"
	fi
	if [[ -z "${!varName}" ]]; then
		exitWithError "Input value can not be empty!"
	fi
}
function validatePartitions() {
	if [[ -z "$boot" || -z "$swap" || -z "$root" ]]; then
		exitWithError "All partitions must be set!"
	fi
}
function Banner() {
	clearScreen
	local banner=$1
	case $banner in
		arch)
		myPrint "green" "    ____           __        _____            \n"
		myPrint "green" "   /  _/___  _____/ /_____ _/ / (_)___  ____ _\n"
		myPrint "green" "   / // __ \/ ___/ __/ __ \`/ / / / __ \/ __ \`/\n"
		myPrint "green" " _/ // / / (__  ) /_/ /_/ / / / / / / / /_/ / \n"
		myPrint "green" "/___/_/ /_/____/\__/\__,_/_/_/_/_/ /_/\__, /  \n"
		myPrint "green" "   /   |  __________/ /_             /____/   \n"
		myPrint "green" "  / /| | / ___/ ___/ __ \                     \n"
		myPrint "green" " / ___ |/ /  / /__/ / / /                     \n"
		myPrint "green" "/_/  |_/_/   \___/_/ /_/                      \n\n";;
		hypr)
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
		myPrint "green" "      /____/_/                                 \n\n";;
		config)
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
		myPrint "green" "                       /____/                        \n\n";;
		*)
		myPrint "green" "   _____      __                ____  __                \n"
		myPrint "green" "  / ___/_____/ /_  ____  __  __/ __ )/ /_  __  __       \n"
		myPrint "green" "  \__ \/ ___/ __ \/ __ \/ / / / __  / __ \/ / / /       \n"
		myPrint "green" " ___/ / /__/ / / / / / / /_/ / /_/ / /_/ / /_/ /        \n"
		myPrint "green" "/____/\___/_/ /_/_/ /_/\__,_/_____/_.___/\__, /         \n"
		myPrint "green" "    ___              __    ____         /____/      ____\n"
		myPrint "green" "   /   |  __________/ /_  /  _/___  _____/ /_____ _/ / /\n"
		myPrint "green" "  / /| | / ___/ ___/ __ \ / // __ \/ ___/ __/ __ \`/ / / \n"
		myPrint "green" " / ___ |/ /  / /__/ / / // // / / (__  ) /_/ /_/ / / /  \n"
		myPrint "green" "/_/  |_/_/   \___/_/ /_/___/_/ /_/____/\__/\__,_/_/_/   \n\n";;
	esac
}
function myPasswd() {
	local MAX_ATTEMPTS=3 attempts=0
	# Schleife, die bis zu MAX_ATTEMPTS Versuche erlaubt
	while [ $attempts -lt $MAX_ATTEMPTS ]; do
		# Passwortabfrage
		printf "Password: "
		read -s password1
		printf "\nRetype: "
		read -s password2
		# Überprüfen, ob die Passwörter übereinstimmen
		if [ "$password1" != "$password2" ]; then
			printf "\nPasswords do not match.\n"
			((attempts++))
			continue  # Gehe zurück zum Anfang der Schleife
		fi
		# Führe den `passwd`-Befehl aus, um das Passwort zu ändern
		echo -e "$password1\n$password2" | sudo passwd ${1} &>/dev/null
		# Überprüfen, ob der `passwd`-Befehl erfolgreich war
		if [ $? -eq 0 ]; then
			printf "\nPassword set successfully.\n"
			break  # Beende die Schleife, wenn erfolgreich
		else
			printf "\nError setting password.\n"
			((attempts++))
		fi
	done
	# Falls die maximale Anzahl der Versuche erreicht wurde
	if [ $attempts -ge $MAX_ATTEMPTS ]; then
		exitWithError "\nMax tries reached. Exiting!\n"
	fi
}
function printStep() {
	local run=$1 mode=$2 message=$3
	case $run in
		1)
		printf "${RUNNING} ${mode} ${WHITE}${message}${NC}\n"
		MOVE=${MOVE}${UP}
		MOVEBACK=${MOVEBACK}${DOWN};;
		*)
		printf "${RUNNING}  ${mode} ${WHITE}${message}${NC}"
		MOVE=${MOVE}${UP}
		MOVEBACK=${MOVEBACK}${DOWN};;
	esac
}
function printStepOK() {
	local run=$1
	case $run in
		1)
		MOVE=${MOVE}
		printf "${MOVE}${MYOK}"
		MOVE=""
		printf "${MOVEBACK}\r"
		MOVEBACK="";;
		*)
		printf "\r${MYOK}\n";;
	esac
}
function printCountDown() {
	local time=$1
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
function printHelp() {
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
function runcmds() {
	local sudo=$1 mode=$2 message=$3
	shift 3
	printStep 0 "${mode}" "${message}"
 	for cmd in "$@"; do
		if [[ "$sudo" == "1" ]]; then 
			sudo bash -c "$cmd" || exitWithError "Command failed: $cmd"
		else
			bash -c "$cmd" || exitWithError "Command failed: $cmd"
		fi
  	done
	printStepOK 0
}
function installSchnuBby() {
	printStep 1 "Installing" "schnubbyspecifics..."
	bash -c "sudo mount --mkdir /dev/nvme0n1p4 /programmieren &>/dev/null"
	steps=("fstab" "autologin" "lutris" "zshhist" "gitconf" "gitcred" "teamspeak3")
	for step in "${steps[@]}"; do
		case $step in
			fstab) runcmds 1 "Configuring" "fstab..." "sudo echo -e '/dev/nvme0n1p4      	/programmieren     	ext4      	rw,relatime	0 1' >> /etc/fstab" "sudo echo -e '/dev/nvme0n1p5      	/spiele     	ext4      	rw,relatime	0 1' >> /etc/fstab";;
			autologin) runcmds 1 "Setting" "autologin..." "sudo echo -e '\n[Autologin]\nRelogin=false\nSession=hyprland\nUser=${user}' >> /etc/sddm.conf.d/the_hyde_project.conf";;
			lutris)
			if [[ -d "$HOME/.local/share/lutris" ]]; then
				runcmds 0 "Backing up" "lutris..." "mv $HOME/.local/share/lutris $HOME/.local/share/lutris_bak"
			fi 	
			if [[ ! -d "$HOME/.local/share/lutris" ]]; then
				runcmds 0 "Configuring" "lutris..." "ln -s /programmieren/.local/share/lutris $HOME/.local/share/lutris" 	
			fi;;
			zshhist)
			if [[ -f "$HOME/.zsh_history" ]]; then
				runcmds 0 "Removing" ".zsh_history..." "rm -rf $HOME/.zsh_history"
			fi
			runcmds 0 "Configuring" ".zsh_history..." "ln -sf /programmieren/.zsh_history $HOME/.zsh_history";;
			gitconf)
			if [[ ! -f "$HOME/.gitconfig" ]]; then
				runcmds 0 "Configuring" "git..." "ln -sf /programmieren/.gitconfig $HOME/.gitconfig"
			fi;;
			gitcred)
			if [[ ! -f "$HOME/.git-credentials" ]]; then
				runcmds 0 "Configuring" "git credentials..." "ln -sf /programmieren/.git-credentials $HOME/.git-credentials"
			fi;;
			teamspeak3)
			if [[ -f "$HOME/.ts3client" ]]; then
				runcmds 0 "Removing" ".ts3client..." "rm -rf $HOME/.ts3client"
			fi
			runcmds 0 "Configuring" ".ts3client..." "ln -sf /programmieren/.ts3client $HOME/.ts3client";;
			*)
			exitWithError "Error setting SchnuBby specifics!"
		esac
	done
	printStepOK 1
}
function readArgs() {
	while [ $# -gt 0 ]; do
		if [[ $1 == "--"* ]]; then
			v="${1/--/}"
				if [[ "${v}" == "help" ]]; then
				printHelp
			fi
			printf -v "$v" "%s" "$2"
			shift
		fi
		shift
	done
}
function setDefaults() {
	cpu="${cpu:-intel-ucode}"
	kernel="${kernel:-linux-lts}"
	gpu="${gpu:-amd}"
	timezone="${timezone:-Europe/Berlin}"
	locale="${locale:-de_DE.UTF-8}"
	keymap="${keymap:-de-latin1}"
}
function listOptions() {
	Banner "install"
	local i=1
	options=("Arch" "Chroot" "HyDE" "Config files" "SchnuBby specific (git/fstab/lutris...)")
	for option in "${options[@]}"; do
		printf "["
		myPrint "yellow" "$i"
		printf "]: Install "
		myPrint "yellow" "$option\n"
		((i++))
	done
}
function runCFDiskIfNeeded() {
	if [[ -z "$cfdisk" && -n "$disk" ]]; then
		getInput "\nStart cfdisk (y/N) ?\n" cfdisk "N"
	fi
	if [[ "$cfdisk" =~ ^[yY]$ ]]; then
		if [[ -z "$disk" ]]; then
			getInput "\nEnter disk\n" disk
			[[ -z "$disk" ]] && exitWithError "No disk entered -> exit\n"
		fi
		cfdisk "$disk"
	fi
}
function checkPartitions() {
	if [[ -z "$boot" ]]; then getInput "Enter boot partition: " boot; fi
	if [[ -z "$swap" ]]; then getInput "Enter swap partition: " swap; fi
	if [[ -z "$root" ]]; then getInput "Enter root partition: " root; fi
}
function installBaseSystem() {
	Banner "arch"
	runCFDiskIfNeeded
	checkPartitions	
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
		runcmds 0 "Running" "pacstrap..." "pacstrap -K /mnt base base-devel ${kernel} linux-firmware ${cpu} efibootmgr grub sudo git networkmanager &>/dev/null" "genfstab -U /mnt >> /mnt/etc/fstab" "cp ./${scriptname} /mnt"
	printStepOK 1
 	bash -c "arch-chroot /mnt ./${scriptname} --option 2 --hostname ${hostname} --user ${user} --gpu ${gpu}"
  	bash -c "umount -R /mnt &>/dev/null" 
	printCountDown 3 "Installation complete! Reboot in"
   	bash -c "reboot"
}
function installArchCHRoot() {
	printStep 1 "Configuring" "arch-chroot..."
		runcmds 0 "Setting" "localtime..." "ln -sf /usr/share/zoneinfo/${timezone} /etc/localtime &>/dev/null" "hwclock --systohc &>/dev/null"
		runcmds 0 "Setting up" "locales..." "sed -e '/${locale}/s/^#*//' -i /etc/locale.gen" "locale-gen &>/dev/null" "echo LANG=${locale} >> /etc/locale.conf" "echo KEYMAP=${keymap} >> /etc/vconsole.conf"
		runcmds 0 "Setting up" "GRUB..." "grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB &>/dev/null" "grub-mkconfig -o /boot/grub/grub.cfg &>/dev/null"
		runcmds 0 "Enabling" "services..." "systemctl enable NetworkManager &>/dev/null"
	printStepOK 1
	if [[ -z "$hostname" ]]; then getInput "\nEnter your Hostname: " hostname "ArchLinux"; fi
	bash -c "echo ${hostname} >> /etc/hostname"       	
	myPrint "yellow" "\nEnter your NEW root password\n\n"
	myPasswd	
	if [[ -z "$user" ]]; then getInput "\nEnter your normal username: " user "schnubby"; fi
	bash -c "useradd -mG wheel ${user}"
	myPrint "yellow" "\nEnter your normal user password\n\n"
	myPasswd "${user}"
 	bash -c "sed -e '/%wheel ALL=(ALL:ALL) ALL/s/^#*//' -i /etc/sudoers"
   	bash -c "mv ./${scriptname} /home/${user}/"
	bash -c "echo ./${scriptname} --option 3 --user ${user} --gpu ${gpu} >> /home/${user}/.bashrc"
}
function installHyDE() {
	if [[ -z "$user" ]]; then getInput "Enter your normal username: " user "schnubby"; fi
 	bash -c "sudo pacman -Syy &>/dev/null"
	Banner "hypr"
	printStep 1 "Setting up" "HyprDots..."
		runcmds 0 "Downloading" "HyprDots..." "git clone --depth 1 https://github.com/SchnuBby2205/HyDE ~/HyDE &>/dev/null"
	printStepOK 1
	printCountDown 3 "Starting installation in"
 	bash -c "sed -i '/${scriptname}/d' ~/.bashrc"
	bash -c "echo exec-once=kitty ./${scriptname} --option 4 --user ${user} --gpu ${gpu} >> $HOME/HyDE/Configs/.config/hypr/userprefs.conf"		
  	cd $HOME/HyDE/Scripts
	bash -c "./install.sh -drs"
}
function installConfigs() {
	Banner "config"
	if [[ -z "$user" ]]; then getInput "Enter your normal username: " user "schnubby"; fi
	if [[ -z "$gpu" ]]; then getInput "Enter your gpu (amd // nvidia)): " gpu "amd"; fi
	bash -c "sudo pacman -Syy"
	Banner "config"
	printStep 1 "Running" "final steps..."
	case $gpu in 
		amd) runcmds 0 "Downloading" "graphics drivers..." "sudo pacman  --noconfirm -S --needed mesa mesa-utils lib32-mesa vulkan-radeon lib32-vulkan-radeon libva-mesa-driver libva-utils vulkan-icd-loader lib32-vulkan-icd-loader &>/dev/null";;
		nvidia) runcmds 0 "Downloading" "graphics drivers..." "sudo pacman  --noconfirm -S --needed nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader &>/dev/null";;
		*) exitWithError "No valid GPU specified!";;
	esac
  	printStepOK 1
	bash -c "yay arch gaming meta"
	bash -c "yay dxvk-bin"
	getInput "\nLoad SchnuBby specific configs (y/n)? (git/lutris/fstab)\n" schnubby "Y"
	[[ "$schnubby" =~ ^[yY]$ ]] && installSchnuBby
 	sudo bash -c "sudo rm -rf ~/${scriptname}"	
  	bash -c "sed -i '/${scriptname}/d' $HOME/HyDE/Configs/.config/hypr/userprefs.conf"
	bash -c "firefox -new-tab -url https://github.com/HyDE-Project/hyde-gallery?tab=readme-ov-file \
 	firefox-new-tab -url https://github.com/GloriousEggroll/proton-ge-custom"
 	bash -c "firefox --ProfileManager"
	myPrint "green" "Installation is finished! The system will reboot one last time!\n\n"   
  	printCountDown 3 "Reboot in"
    bash -c "reboot"
}
function installSchnuBbyOption() {
	Banner "config"
	if [[ -z "$user" ]]; then getInput "Enter your normal username: " user "schnubby"; fi
 	installSchnuBby
}
setDefaults
readArgs "$@"
if [[ -n "$defaults" ]]; then
	boot="/dev/nvme0n1p1"
	swap="/dev/nvme0n1p2"
	root="/dev/nvme0n1p3"
	hostname="ArchLinux"
	user="schnubby"
	installBaseSystem
fi
if [[ -z "$option" ]]; then
	listOptions
	getInput "Wich step to run?" option 1
fi
case $option in
	1) installBaseSystem;;
	2) installArchCHRoot;;
	3) installHyDE;;
	4) installConfigs;;
	5) installSchnuBbyOption;;
	*) exitWithError "No valid option!";;
esac
exit 0
