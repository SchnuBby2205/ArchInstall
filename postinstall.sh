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

printf "\n"
printRunning "Cloning Hyprdots"
bash -c "git clone https://github.com/prasanthrangan/hyprdots ~/Hyprdots &>/dev/null"
cd ~/Hyprdots
printf "\r"
printOK "Cloning Hyprdots\n"

myPrint "yellow" "\nUse SchnuBby2205 Configs? (default = y): "
read CONFIGS
if [ "${CONFIGS}" == "" ]
then
  CONFIGS="y"
fi

if [ "${CONFIGS}" == "y" ]
then
  printf "\n"
  printf "\n"
  printRunning "Preparing SchnuBby2205 Configs"

  cd Configs/.config/hypr
  bash -c "sudo rm hyprland.conf &>/dev/null"
  bash -c "wget https://raw.githubusercontent.com/SchnuBby2205/hyprdots/main/Configs/.config/hypr/hyprland.conf &>/dev/null"

  cd ../waybar/modes
  bash -c "sudo rm wb_top_01.jsonc &>/dev/null"
  bash -c "wget https://raw.githubusercontent.com/SchnuBby2205/hyprdots/main/Configs/.config/waybar/modes/wb_top_01.jsonc &>/dev/null"

  cd ~/Hyprdots/Scripts
  bash -c "sudo rm custom_apps.lst &>/dev/null"
  bash -c "wget https://raw.githubusercontent.com/SchnuBby2205/hyprdots/main/Scripts/custom_apps.lst &>/dev/null"
  bash -c "sed '/bluez/d' custom_hypr.lst"
  bash -c "sed '/bluez-utils/d' custom_hypr.lst"
  bash -c "sed '/blueman/d' custom_hypr.lst"
  bash -c "sed '/brightnessctl/d' custom_hypr.lst"  
  
  printf "\r"
  printOK "Preparing SchnuBby2205 Configs\n"
fi

printf "\nPostinstallation will start in 5 seconds."
sleep 1 
printf "\rPostinstallation will start in 4 seconds."
sleep 1 
printf "\rPostinstallation will start in 3 seconds."
sleep 1 
printf "\rPostinstallation will start in 2 seconds."
sleep 1 
printf "\rPostinstallation will start in 1 seconds."
sleep 1 
clearScreen

cd ~/Hyprdots/Scripts
bash -c "./install.sh custom_apps.lst"
