#!/bin/bash

#### EDIT THESE SETTINGS FOR A DEFAULT FLAG RUN (./ArchInstall.sh --defaults 1)
function checkDefaultRun() {
  #if [[ -n "$defaults" && "$option" -eq 1 ]]; then
  if [[ -n "$defaults" ]]; then
    ## General
    debug="n"

    ## Hard Drives and Partitioning
    boot="/dev/nvme0n1p1"
    swap="/dev/nvme0n1p2"
    root="/dev/nvme0n1p3"

    ## Names
    hostname="ArchLinux"
    user="schnubby"

    ## Hardware
    cpu="intel-ucode"
    gpu="amd"

    ## CH-Root
    timezone="Europe/Berlin"
    locale="de_DE.UTF-8"
    keymap="de-latin1"

    ## System
    kernel="linux-lts"
    desktop="meins"

    if [[ -z "$option" || "$option" -eq 1 ]]; then installBaseSystem; fi
  fi
}
#### EDIT THESE SETTINGS FOR A DEFAULT FLAG RUN

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
CLEAR="\r                                        \r"
scriptname=$(basename "$0")
# Hilfsfunktionen
function clearScreen() {
  clear
}
function myPrint() {
  local color=$1 message=$2
  case $color in
  green) printf "${GREEN}${message}${NC}" ;;
  red) printf "${RED}${message}${NC}" ;;
  yellow) printf "${YELLOW}${message}${NC}" ;;
  white) printf "${WHITE}${message}${NC}" ;;
  *) printf "${message}" ;;
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
    myPrint "green" "/_/  |_/_/   \___/_/ /_/                      \n\n"
    ;;
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
    myPrint "green" "      /____/_/                                 \n\n"
    ;;
  caelestia)
    myPrint "green" "    ____           __        _____             \n"
    myPrint "green" "   /  _/___  _____/ /_____ _/ / (_)___  ____ _ \n"
    myPrint "green" "   / // __ \/ ___/ __/ __ \`/ / / / __ \/ __ \`/ \n"
    myPrint "green" " _/ // / / (__  ) /_/ /_/ / / / / / / / /_/ /  \n"
    myPrint "green" "/___/_/ /_/____/\__/\__,_/_/_/_/_/ /_/\__, /   \n"
    myPrint "green" "                           ____      /____/    \n"
    myPrint "green" "                          / __ \____  / /______\n"
    myPrint "green" "                         / / / / __ \/ __/ ___/\n"
    myPrint "green" "                        / /_/ / /_/ / /_(__  ) \n"
    myPrint "green" "                       /_____/\____/\__/____/  \n\n"
    ;;
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
    myPrint "green" "                       /____/                        \n\n"
    ;;
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
    myPrint "green" "/_/  |_/_/   \___/_/ /_/___/_/ /_/____/\__/\__,_/_/_/   \n\n"
    ;;
  esac
}
myPasswd() {
  MAX_ATTEMPTS=3
  attempts=0

  # Schleife, die bis zu MAX_ATTEMPTS Versuche erlaubt
  while [ $attempts -lt $MAX_ATTEMPTS ]; do
    # Passwortabfrage
    printf "Password: "
    read -s password1
    printf "\nRetype: "
    read -s password2

    # Überprüfen, ob die Passwörter übereinstimmen
    if [ "$password1" != "$password2" ]; then
      printf "\nPasswords didn't match.\n"
      ((attempts++))
      continue # Gehe zurück zum Anfang der Schleife
    fi

    # Führe den `passwd`-Befehl aus, um das Passwort zu ändern
    echo -e "$password1\n$password2" | sudo passwd ${1} &>/dev/null

    # Überprüfen, ob der `passwd`-Befehl erfolgreich war
    if [ $? -eq 0 ]; then
      printf "\nPassword updated succesfully.\n"
      break # Beende die Schleife, wenn erfolgreich
    else
      printf "\nError setting the password.\n"
      ((attempts++))
    fi
  done

  # Falls die maximale Anzahl der Versuche erreicht wurde
  if [ $attempts -ge $MAX_ATTEMPTS ]; then
    printf "\nMaximum tries reached script will end.\n"
    exit 1
  fi
}
function printStep() {
  local run=$1 mode=$2 message=$3
  printf "${RUNNING} ${mode} ${WHITE}${message}${NC}\n"
}

function printStepOK() {
  printf "${CLEAR}${UP}${CLEAR}"
}
#function printStep() {
#  local run=$1 mode=$2 message=$3
#  case $run in
#  1)
#    printf "${RUNNING} ${mode} ${WHITE}${message}${NC}\n"
#    MOVE=${MOVE}${UP}
#    MOVEBACK=${MOVEBACK}${DOWN}
#    ;;
#  *)
#    printf "${RUNNING}  ${mode} ${WHITE}${message}${NC}"
#    MOVE=${MOVE}${UP}
#    MOVEBACK=${MOVEBACK}${DOWN}
#    ;;
#  esac
#}
#function printStepOK() {
#  local run=$1
#  case $run in
#  1)
#    MOVE=${MOVE}
#    printf "${MOVE}${MYOK}"
#    MOVE=""
#    printf "${MOVEBACK}\r"
#    MOVEBACK=""
#    ;;
#  *)
#    printf "\r${MYOK}\n"
#    ;;
#  esac
#}
function printCountDown() {
  local time=$1
  myPrint "green" "\n${2} ${time}..."
  for ((i = 1; i < $((time - 1)); i++)); do
    sleep 1
    myPrint "green" "\r${2} $((time - i))..."
  done
  sleep 1
  myPrint "green" "\r${2} $((time - i))...\n\n"
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
  printf "which kernel to install.\n"
  myPrint "white" "\t--cpu:\t\t "
  printf "which CPU to install (intel-ucode // amd-ucode).\n"
  myPrint "white" "\t--gpu:\t\t "
  printf "which GPU to install (amd // nvidia).\n"
  myPrint "white" "\t--timezone:\t\t "
  printf "which timezone to use.\n"
  myPrint "white" "\t--locale:\t\t "
  printf "which locale to use.\n"
  myPrint "white" "\t--keymap:\t\t "
  printf "which keymap to user.\n"
  myPrint "white" "\t--desktop:\t\t "
  printf "which desktop environment to use (hypr, caelestia or end4).\n"
  myPrint "white" "\t--debug:\t\t "
  printf "switches to verbose output.\n\n"
  exit 0
}
function runcmds() {
  local sudo=$1 mode=$2 message=$3 current=$4 finished=$5 max=$6

  shift 6
  if [[ "$debug" =~ ^[nN]$ ]]; then
    if [[ "$current" -gt "0" ]]; then printf "${CLEAR}${UP}"; fi
    printf "["
    for ((i = 0; i < current; i++)); do printf "#"; done
    for ((i = current; i < max; i++)); do printf " "; done
    printf "]\n${mode} ${WHITE}${message}${NC}"
  fi
  for cmd in "$@"; do
    if [[ "$sudo" == "1" ]]; then
      sudo bash -c "$cmd" || printf "error"
    else
      bash -c "$cmd" || printf "error"
    fi
  done
  if [[ "$debug" =~ ^[nN]$ ]]; then
    printf "${UP}\r["
    for ((i = 0; i < finished; i++)); do printf "#"; done
    for ((i = finished; i < max; i++)); do printf " "; done
    printf "]\n"
  fi
}
#function runcmds() {
#  local sudo=$1 mode=$2 message=$3
#  shift 3
#  if [[ "$debug" =~ ^[nN]$ ]]; then printStep 0 "${mode}" "${message}"; fi
#  for cmd in "$@"; do
#    if [[ "$sudo" == "1" ]]; then
#      sudo bash -c "$cmd" || exitWithError "Command failed: $cmd"
#    else
#      bash -c "$cmd" || exitWithError "Command failed: $cmd"
#    fi
#  done
#  if [[ "$debug" =~ ^[nN]$ ]]; then printStepOK 0; fi
#}
function installSchnuBby() {
  checkDebugFlag
  if [[ "$debug" =~ ^[nN]$ ]]; then printStep 1 "Installing" "schnubbyspecifics..."; fi
  bash -c "sudo mount --mkdir /dev/nvme0n1p4 /programmieren ${debugstring}"
  steps=("fstab" "autologin" "lutris" "zshhist" "gitconf" "gitcred" "teamspeak3" "grub" "firefox")
  #"steam")
  for step in "${steps[@]}"; do
    case $step in
    #fstab) runcmds 1 "Configuring" "fstab..." "sudo echo -e '/dev/nvme0n1p4      	/programmieren     	ext4      	rw,relatime	0 1' >> /etc/fstab" "sudo echo -e '/dev/nvme0n1p5      	/spiele     	ext4      	rw,relatime	0 1' >> /etc/fstab";;
    #Angepasst für W10 dual boot
    fstab) runcmds 1 "Configuring" "fstab..." 0 2 20 "sudo echo -e '/dev/nvme0n1p4      	/programmieren     	ext4      	rw,relatime	0 1' >> /etc/fstab" "sudo echo -e '/dev/nvme0n1p6      	/spiele     	ext4      	rw,relatime	0 1' >> /etc/fstab" ;;
    #runcmds 1 "Setting" "autologin..." "sudo echo -e '\n[Autologin]\nRelogin=false\nSession=hyprland\nUser=${user}' >> /etc/sddm.conf.d/the_hyde_project.conf"
    autologin) runcmds 1 "Setting" "autologin..." 2 5 20 "sudo echo -e '\n[Autologin]\nRelogin=false\nSession=hyprland\nUser=${user}' >> /etc/sddm.conf.d/autologin.conf" ;;
    lutris)
      if [[ -d "$HOME/.local/share/lutris" ]]; then
        runcmds 0 "Backing up" "lutris..." 5 6 20 "mv $HOME/.local/share/lutris $HOME/.local/share/lutris_bak"
      fi
      if [[ ! -d "$HOME/.local/share/lutris" ]]; then
        runcmds 0 "Configuring" "lutris..." 6 7 20 "ln -s /programmieren/backups/.local/share/lutris $HOME/.local/share/lutris"
      fi
      ;;
    zshhist)
      if [[ -f "$HOME/.zsh_history" ]]; then
        runcmds 0 "Removing" ".zsh_history..." 7 8 20 "rm -rf $HOME/.zsh_history"
      fi
      runcmds 0 "Configuring" ".zsh_history..." 8 9 20 "ln -sf /programmieren/backups/.zsh_history $HOME/.zsh_history"
      ;;
    gitconf)
      if [[ ! -f "$HOME/.gitconfig" ]]; then
        runcmds 0 "Configuring" "git..." 9 11 20 "ln -sf /programmieren/backups/.gitconfig $HOME/.gitconfig"
      fi
      ;;
    gitcred)
      if [[ ! -f "$HOME/.git-credentials" ]]; then
        runcmds 0 "Configuring" "git credentials..." 11 13 20 "ln -sf /programmieren/backups/.git-credentials $HOME/.git-credentials"
      fi
      ;;
    teamspeak3)
      if [[ -f "$HOME/.ts3client" ]]; then
        runcmds 0 "Removing" ".ts3client..." 13 14 20 "rm -rf $HOME/.ts3client"
      fi
      runcmds 0 "Configuring" ".ts3client..." 14 15 20 "ln -sf /programmieren/backups/.ts3client $HOME/.ts3client"
      ;;
    grub)
      sudo sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/g' /etc/default/grub
      runcmds 1 "Regenerating" "GRUB..." 15 20 20 "sudo grub-mkconfig -o /boot/grub/grub.cfg ${debugstring}"
      ;;
      #sudo grub-mkconfig -o /boot/grub/grub.cfg ${debugstring};;
    firefox)
      ff_new_user=$HOME/.mozilla/firefox/$(ls $HOME/.mozilla/firefox | grep "Default User")
      rm -rf "${ff_new_user}"
      ln -sf /programmieren/backups/FireFox/3665cjzf.default-release "${ff_new_user}"
      ;;
    steam)
      cd $HOME/.steam/steam/compatibilitytools.d/
      url=$(curl -s https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest | grep "browser_download_url.*tar.gz" | cut -d : -f 2,3 | tr -d \")
      runcmds 0 "Downloading" "latest ProtonGE..." "curl -sL $url | tar zxf ${debugstring}"
      ;;
    *)
      exitWithError "Error setting SchnuBby specifics!"
      ;;
    esac
  done
  if [[ "$debug" =~ ^[nN]$ ]]; then printStepOK 1; fi
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
#function setDefaults() {
#	cpu="${cpu:-intel-ucode}"
#	kernel="${kernel:-linux-lts}"
#	gpu="${gpu:-amd}"
#	timezone="${timezone:-Europe/Berlin}"
#	locale="${locale:-de_DE.UTF-8}"
#	keymap="${keymap:-de-latin1}"
# 	debug="${debug:-n}"
#}
function listOptions() {
  Banner "install"
  local i=1
  options=("Arch" "Chroot" "Desktop environment" "Config files" "SchnuBby specific (git/fstab/lutris...)")
  for option in "${options[@]}"; do
    printf "["
    myPrint "yellow" "$i"
    printf "]: Install "
    myPrint "yellow" "$option\n"
    ((i++))
  done
}
function checkDebugFlag() {
  if [[ "$debug" =~ ^[yY]$ ]]; then
    debugstring=""
  else
    debugstring=" &>/dev/null"
  fi
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
  checkDebugFlag
  runCFDiskIfNeeded
  checkPartitions
  myPrint "green" "\nBoot partition: "
  printf "${WHITE}${boot}${NC}\n"
  myPrint "green" "Swap partition: "
  printf "${WHITE}${swap}${NC}\n"
  myPrint "green" "Root partition: "
  printf "${WHITE}${root}${NC}\n"

  myPrint "red" "\nThese partitions will be\n!!WIPED AND FORMATTED without another Warning!!\nPlease check them TWICE before you continue!!\n\nPress ENTER to continue (STRG-C to exit now)..."
  getInput "" check "y"

  printCountDown 3 "Starting installation in"
  #Banner "arch"

  if [[ "$debug" =~ ^[nN]$ ]]; then printStep 1 "Installing" "base system..."; fi
  runcmds 0 "Formatting" "drives..." 0 5 20 "mkfs.fat -F 32 ${boot} ${debugstring}" "mkswap ${swap} ${debugstring}" "swapon ${swap} ${debugstring}" "mkfs.ext4 -F ${root} ${debugstring}"
  runcmds 0 "Mounting" "partitions..." 5 10 20 "mount --mkdir ${root} /mnt ${debugstring}" "mount --mkdir ${boot} /mnt/boot ${debugstring}"
  #runcmds 0 "Setting up" "pacman..." "pacman -Syy ${debugstring}" "pacman --noconfirm -S reflector" "reflector --sort rate --latest 20 --protocol https --country Germany --save /etc/pacman.d/mirrorlist ${debugstring}" "sed -i '/ParallelDownloads/s/^#//' /etc/pacman.conf"
  runcmds 0 "Setting up" "pacman..." 10 15 20 "pacman -Syy ${debugstring}" "reflector --sort rate --latest 20 --protocol https --country Germany --save /etc/pacman.d/mirrorlist ${debugstring}" "sed -i '/ParallelDownloads/s/^#//' /etc/pacman.conf"
  runcmds 0 "Running" "pacstrap..." 15 20 20 "pacstrap -K /mnt base base-devel ${kernel} linux-firmware ${cpu} efibootmgr grub sudo git networkmanager ${debugstring}" "genfstab -U /mnt >> /mnt/etc/fstab" "cp ./${scriptname} /mnt"
  if [[ "$debug" =~ ^[nN]$ ]]; then printStepOK 1; fi

  bash -c "arch-chroot /mnt ./${scriptname} --option 2 --hostname ${hostname} --user ${user} --gpu ${gpu} --defaults ${defaults} --desktop ${desktop} --debug ${debug}"
  bash -c "umount -R /mnt ${debugstring}"
  printCountDown 3 "Installation complete! Reboot in"
  bash -c "reboot"
}
function installArchCHRoot() {
  checkDebugFlag
  if [[ "$debug" =~ ^[nN]$ ]]; then printStep 1 "Configuring" "arch-chroot..."; fi
  runcmds 0 "Setting" "localtime..." 0 5 20 "ln -sf /usr/share/zoneinfo/${timezone} /etc/localtime ${debugstring}" "hwclock --systohc ${debugstring}"
  runcmds 0 "Setting up" "locales..." 5 10 20 "sed -e '/${locale}/s/^#*//' -i /etc/locale.gen" "locale-gen ${debugstring}" "echo LANG=${locale} >> /etc/locale.conf" "echo KEYMAP=${keymap} >> /etc/vconsole.conf"
  runcmds 0 "Setting up" "GRUB..." 10 15 20 "grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB ${debugstring}" "grub-mkconfig -o /boot/grub/grub.cfg ${debugstring}"
  runcmds 0 "Enabling" "services..." 15 20 20 "systemctl enable NetworkManager ${debugstring}"
  if [[ "$debug" =~ ^[nN]$ ]]; then printStepOK 1; fi

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
  bash -c "echo ./${scriptname} --option 3 --user ${user} --gpu ${gpu} --defaults ${defaults} --desktop ${desktop} --debug ${debug} >> /home/${user}/.bashrc"
}
function installDE() {
  checkDebugFlag
  if [[ -z "$user" ]]; then getInput "Enter your normal username: " user "schnubby"; fi
  if [[ -z "$desktop" ]]; then
    local i=1
    options=("hypr" "caelestia" "end4" "meins")
    for option in "${options[@]}"; do
      printf "["
      myPrint "yellow" "$i"
      printf "]: Install "
      myPrint "yellow" "$option\n"
      ((i++))
    done
    getInput "Which desktop environment to install?" desktop "hypr"
  fi
  if [[ "$desktop" -eq 1 ]]; then
    desktop="hypr"
  fi
  if [[ "$desktop" -eq 2 ]]; then
    desktop="caelestia"
  fi
  if [[ "$desktop" -eq 3 ]]; then
    desktop="end4"
  fi
  if [[ "$desktop" -eq 4 ]]; then
    desktop="meins"
  fi
  if [[ "$desktop" == "hypr" ]]; then
    Banner "hypr"
    bash -c "sudo pacman -Syy ${debugstring}"

    if [[ "$debug" =~ ^[nN]$ ]]; then printStep 1 "Setting up" "HyprDots..."; fi
    #runcmds 0 "Setting up" "pacman..." "pacman -Syy ${debugstring}"
    runcmds 0 "Downloading" "HyprDots..." 0 10 20 "git clone --depth 1 https://github.com/SchnuBby2205/HyDE ~/HyDE ${debugstring}"
    runcmds 0 "Downloading" "Custom configs..." 10 20 20 "git clone --depth 1 https://github.com/SchnuBby2205/HyprlandConfigs.git ~/.config/hypr/schnubby ${debugstring}"
    if [[ "$debug" =~ ^[nN]$ ]]; then printStepOK 1; fi

    printCountDown 3 "Starting installation in"
    bash -c "sed -i '/${scriptname}/d' ~/.bashrc"
    bash -c "echo exec-once=kitty ./${scriptname} --option 4 --user ${user} --gpu ${gpu} --defaults ${defaults} --desktop ${desktop} --debug ${debug} >> $HOME/HyDE/Configs/.config/hypr/schnubby/userprefs.conf"
    cd $HOME/HyDE/Scripts
    if [[ -n "$defaults" ]]; then
      echo "${user} ALL=(ALL) NOPASSWD: /usr/bin/pacman, /usr/bin/chsh" | sudo tee /etc/sudoers.d/install-script >/dev/null
      sudo chmod 0440 /etc/sudoers.d/install-script
      bash -c "./install.sh -drs"
      #defaults klappen nocht nicht testen.... solange ohne :/
      #bash -c "printf '2\ny111' | ./install.sh -drs"
    else
      bash -c "./install.sh -drs"
    fi
  fi
  if [[ "$desktop" == "caelestia" ]]; then
    Banner "caelestia"
    bash -c "sudo sed -i '/\[multilib\]/,/Include/''s/^#//' /etc/pacman.conf"
    bash -c "sudo pacman -Syy ${debugstring}"

    if [[ "$debug" =~ ^[nN]$ ]]; then printStep 1 "Setting up" "Caelestia..."; fi
    #runcmds 0 "Setting up" "pacman..." "pacman -Syy ${debugstring}"
    runcmds 0 "Installing" "Base Programs..." "sudo pacman --noconfirm -S --needed kitty fish sddm firefox hyprland ${debugstring}"
    # Wir installieren hier den thunar File Explorer -> Sollte der uncool sein nehmen wir wieder dolphin
    runcmds 0 "Installing" "Additional Programs..." "sudo pacman --noconfirm -S --needed lazygit lutris steam thunar ${debugstring}"
    runcmds 0 "Installing" "Audio Programs..." "sudo pacman --noconfirm -S --needed pipewire pipewire-alsa pipewire-audio pipewire-jack pipewire-pulse gst-plugin-pipewire wireplumber pavucontrol pamixer ${debugstring}"
    runcmds 1 "Creating" "Sddm config directory..." "sudo mkdir /etc/sddm.conf.d"
    runcmds 0 "Downloading" "Caelestia Shell..." "git clone --depth 1 https://github.com/SchnuBby2205/caelestia.git ~/.local/share/caelestia ${debugstring}"
    runcmds 0 "Downloading" "Custom configs..." "git clone --depth 1 https://github.com/SchnuBby2205/HyprlandConfigs.git ~/.local/share/caelestia/hypr/schnubby ${debugstring}"
    # sed steps ?
    # Hier kann auch sein ich muss die hypridle löschen
    $kbWindowFullscreen = Super, F
    sed 's/# autologin=dgod/autologin=ubuntu/' /path/to/file
    bash -c "sed -i 's/bind = \$kbWindowFullscreen, fullscreen, 0/#bind = \$kbWindowFullscreen, fullscreen, 0/' ~/.local/share/caelestia/hypr/hyprland/keybinds.conf"
    bash -c "sed -i 's/bindl = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle/bindl = , f10, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle/' ~/.local/share/caelestia/hypr/hyprland/keybinds.conf"
    bash -c "sed -i 's/bindle = , XF86AudioLowerVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume @DEFAULT_AUDIO_SINK@ \$volumeStep%-/bindle = , f11, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume @DEFAULT_AUDIO_SINK@ \$volumeStep%-/' ~/.local/share/caelestia/hypr/hyprland/keybinds.conf"
    bash -c "sed -i 's/bindle = , XF86AudioRaiseVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ \$volumeStep%+/bindle = , f12, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ \$volumeStep%+/' ~/.local/share/caelestia/hypr/hyprland/keybinds.conf"
    if [[ "$debug" =~ ^[nN]$ ]]; then printStepOK 1; fi

    bash -c "sudo systemctl enable sddm.service ${debugstring}"
    printCountDown 3 "Starting installation in"
    bash -c "~/.local/share/caelestia/install.fish"
    bash -c "echo exec-once=kitty ./${scriptname} --option 4 --user ${user} --gpu ${gpu} --defaults ${defaults} --desktop ${desktop} --debug ${debug} >> $HOME/.config/hypr/schnubby/userprefs.conf"
    printCountDown 3 "Reboot in"
    bash -c "reboot"
  fi
  if [[ "$desktop" == "end4" ]]; then
    Banner "caelestia"
    #bash -c "sudo sed -i '/\[multilib\]/,/Include/''s/^#//' /etc/pacman.conf"
    bash -c "sudo pacman -Syy ${debugstring}"

    if [[ "$debug" =~ ^[nN]$ ]]; then printStep 1 "Setting up" "Caelestia..."; fi
    #runcmds 0 "Setting up" "pacman..." "pacman -Syy ${debugstring}"
    runcmds 0 "Downloading" "end4..." "git clone --depth 1 https://github.com/SchnuBby2205/end4.git ~/end4 ${debugstring}"
    runcmds 0 "Downloading" "Custom configs..." "git clone --depth 1 https://github.com/SchnuBby2205/HyprlandConfigs.git ~/.config/hypr/schnubby ${debugstring}"
    if [[ "$debug" =~ ^[nN]$ ]]; then printStepOK 1; fi

    cd $HOME/end4
    printCountDown 3 "Starting installation in"
    bash -c "./install.sh"
    bash -c "echo exec-once=kitty ./${scriptname} --option 4 --user ${user} --gpu ${gpu} --defaults ${defaults} --desktop ${desktop} --debug ${debug} >> $HOME/.config/hypr/schnubby/userprefs.conf"
    printCountDown 3 "Reboot in"
    bash -c "reboot"
  fi
  if [[ "$desktop" == "meins" ]]; then
    Banner "caelestia"
    bash -c "sudo sed -i '/\[multilib\]/,/Include/''s/^#//' /etc/pacman.conf"
    bash -c "sudo pacman -Syy ${debugstring}"

    printCountDown 3 "Starting installation in"

    if [[ "$debug" =~ ^[nN]$ ]]; then printStep 1 "Installing" "Dependencies..."; fi
    runcmds 0 "Installing" "System dependencies..." 0 7 20 "sudo pacman --noconfirm -S --needed hyprland xdg-desktop-portal-hyprland xdg-desktop-portal-gtk sddm swww polkit-gnome xdg-user-dirs networkmanager ttf-jetbrains-mono-nerd ${debugstring}"
    runcmds 0 "Installing" "Audio dependencies..." 7 15 20 "sudo pacman --noconfirm -S --needed pipewire pipewire-alsa pipewire-audio pipewire-pulse gst-plugin-pipewire wireplumber pavucontrol pamixer ${debugstring}"
    runcmds 0 "Installing" "Programs..." 15 20 20 "sudo pacman --noconfirm -S --needed firefox kitty dolphin ark unzip neovim fzf zsh lutris steam teamspeak3 lazygit git ${debugstring}"
    if [[ "$debug" =~ ^[nN]$ ]]; then printStepOK 1; fi

    if [[ "$debug" =~ ^[nN]$ ]]; then printStep 1 "Installing" "AUR helper..."; fi
    runcmds 1 "Creating" "SDDM config directory..." 0 10 20 "sudo mkdir /etc/sddm.conf.d"

    runcmds 0 "Installing" "yay..." 10 20 20 "git clone https://aur.archlinux.org/yay.git ${debugstring}"
    if [[ "$debug" =~ ^[nN]$ ]]; then printStepOK 1; fi

    cd yay
    makepkg -si
    cd ..
    rm -rf ./yay
    if [[ "$debug" =~ ^[nN]$ ]]; then printStep 1 "Running" "Post install..."; fi
    runcmds 0 "Installing" "Quickshell..." 0 15 20 "yay -S quickshell --noconfirm ${debugstring}"
    runcmds 0 "Downloading" "Custom configs..." 15 17 20 "git clone --depth 1 https://github.com/SchnuBby2205/HyprlandConfigs.git ~/.config/hypr/schnubby ${debugstring}"
    runcmds 0 "Downloading" "myShell..." 17 20 20 "git clone --depth 1 https://github.com/SchnuBby2205/myShell.git ~/.config/quickshell/myShell ${debugstring}"
    if [[ "$debug" =~ ^[nN]$ ]]; then printStepOK 1; fi

    if [[ "$debug" =~ ^[nN]$ ]]; then printStep 1 "Starting" "Services..."; fi
    runcmds 0 "Starting" "Greeter (SDDM)..." 0 5 20 "sudo systemctl enable sddm.service ${debugstring}"
    runcmds 0 "Starting" "swww-daemon..." 5 15 20 "echo -e 'exec-once=swww-daemon' >> $HOME/.config/hypr/schnubby/userprefs.conf"
    runcmds 0 "Setting" "myShell..." 15 20 20 "echo -e 'exec-once=quickshell --path $HOME/.config/quickshell/myShell/shell.qml' >> $HOME/.config/hypr/schnubby/userprefs.conf"
    #	runcmds 0 "Setting" "monitors..." "echo -e 'source=./schnubby/monitors.conf' >> $HOME/.config/hypr/schnubby/userprefs.conf ${debugstring}"
    #	runcmds 0 "Setting" "userprefs..." "echo -e 'source=./schnubby/userprefs.conf' >> $HOME/.config/hypr/schnubby/userprefs.conf ${debugstring}"
    #	runcmds 0 "Setting" "windowrules..." "echo -e 'source=./schnubby/windowrules.conf' >> $HOME/.config/hypr/schnubby/userprefs.conf ${debugstring}"
    #
    #rm -rf $HOME/.config/hypr/schnubby/hyprland.conf
    #mv $HOME/.config/hypr/schnubby/hyprland.conf $HOME/.config/hypr/schnubby

    if [[ "$debug" =~ ^[nN]$ ]]; then printStepOK 1; fi

    bash -c "sed -i '/${scriptname}/d' ~/.bashrc"
    bash -c "echo exec-once=kitty ./${scriptname} --option 4 --user ${user} --gpu ${gpu} --defaults ${defaults} --desktop ${desktop} --debug ${debug} >> $HOME/.config/hypr/schnubby/userprefs.conf"
    printCountDown 3 "Reboot in"
    bash -c "reboot"

  fi

}
function installConfigs() {
  checkDebugFlag
  Banner "config"
  if [[ -z "$user" ]]; then getInput "Enter your normal username: " user "schnubby"; fi
  if [[ -z "$gpu" ]]; then getInput "Enter your gpu (amd // nvidia)): " gpu "amd"; fi
  #bash -c "sudo pacman -Syy ${debugstring}"
  Banner "config"

  if [[ "$debug" =~ ^[nN]$ ]]; then printStep 1 "Running" "final steps..."; fi
  runcmds 0 "Setting up" "pacman..." 0 5 20 "sudo pacman -Syy ${debugstring}"
  case $gpu in
  amd) runcmds 0 "Installing" "graphics drivers..." 5 7 20 "sudo pacman  --noconfirm -S --needed mesa mesa-utils lib32-mesa vulkan-radeon lib32-vulkan-radeon libva-mesa-driver libva-utils vulkan-icd-loader lib32-vulkan-icd-loader ${debugstring}" ;;
  nvidia) runcmds 0 "Installing" "graphics drivers..." 7 10 20 "sudo pacman  --noconfirm -S --needed nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader ${debugstring}" ;;
  *) exitWithError "No valid GPU specified!" ;;
  esac
  runcmds 0 "Installing" "arch-gaming-meta..." 10 13 20 "yay -S --noconfirm arch-gaming-meta ${debugstring}"
  runcmds 0 "Installing" "dxvk-bin..." 13 15 20 "yay -S --noconfirm dxvk-bin ${debugstring}"
  runcmds 0 "Installing" "STEAM..." 15 20 20 "steam ${debugstring}"
  if [[ "$debug" =~ ^[nN]$ ]]; then printStepOK 1; fi

  #bash -c "yay -S --noconfirm arch-gaming-meta"
  #bash -c "yay -S --noconfirm dxvk-bin"
  #bash -c "steam"

  bash -c "sudo rm -rf ~/${scriptname}"
  if [[ -n "$defaults" ]]; then
    bash -c "sudo rm -rf /etc/sudoers.d/install-script"
  fi
  bash -c "sed -i '/${scriptname}/d' $HOME/.config/hypr/schnubby/userprefs.conf"
  #if [[ "$desktop" == "hypr" ]]; then	bash -c "sed -i '/${scriptname}/d' $HOME/.config/hypr/schnubby/userprefs.conf"; fi
  #if [[ "$desktop" == "caelestia" ]]; then bash -c "sed -i '/${scriptname}/d' $HOME/.config/hypr/schnubby/userprefs.conf"; fi
  #if [[ "$desktop" == "end4" ]]; then bash -c "sed -i '/${scriptname}/d' $HOME/.config/hypr/schnubby/userprefs.conf"; fi
  #firefox-new-tab -url https://github.com/GloriousEggroll/proton-ge-custom"
  bash -c "firefox --ProfileManager"
  if [[ -z "$defaults" ]]; then
    getInput "\nLoad SchnuBby specific configs (y/n)? (git/lutris/fstab)\n" schnubby "Y"
  fi
  if [[ "$schnubby" =~ ^[yY]$ || -n "$defaults" ]]; then
    installSchnuBby
  fi
  myPrint "green" "Installation is finished! The system will reboot one last time!\n\n"
  printCountDown 3 "Reboot in"
  bash -c "reboot"
}
function installSchnuBbyOption() {
  Banner "config"
  if [[ -z "$user" ]]; then getInput "Enter your normal username: " user "schnubby"; fi
  installSchnuBby
}
#setDefaults
readArgs "$@"
checkDefaultRun
if [[ -z "$option" && -z "$defaults" ]]; then
  listOptions
  getInput "Wich step to run?" option 1
fi
case $option in
1) installBaseSystem ;;
2) installArchCHRoot ;;
3) installDE ;;
4) installConfigs ;;
5) installSchnuBbyOption ;;
*) exitWithError "No valid option!" ;;
esac
exit 0
