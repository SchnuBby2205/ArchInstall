#!/bin/bash

#before install
#conf zusätzliche Module durchschauen
#custom_hypr.lst und custom_flat.lst anpassen
#lsblk um platten zu sehen
#mkfs.fat -F 32 auf boot platte
#mkfs.ext4 auf root platte
#mkswap / swapon auf swapplatte
#mount --mkdir rootplatte /mnt
#mount --mkdir bootplatte /mnt/boot
#in archinstall platten nochmal kontrollieren

#ausführen
curl -o conf.json https://raw.githubusercontent.com/SchnuBby2205/ArchInstall/main/conf.json
curl -o creds.json https://raw.githubusercontent.com/SchnuBby2205/ArchInstall/main/creds.json
archinstall --conf ./conf.json --creds ./creds.json

#after install ausführen
#ZSH wegen Pokemon als Terminal testen
git clone https://github.com/prasanthrangan/hyprdots ~/Hyprdots
cd ~/Hyprdots/Scripts
sudo rm -rf custom_hypr.lst
curl -o custom_hypr.lst https://raw.githubusercontent.com/SchnuBby2205/hyprdots/main/Scripts/custom_hypr.lst
cd ./.extra
sudo rm -rf custom_flat.lst
curl -o custom_flat.lst https://raw.githubusercontent.com/SchnuBby2205/hyprdots/main/Scripts/extra/custom_flat.lst
cd ..
./install.sh -drs

#ausführen
mkdir schnubby_downloads
cd schnubby_downloads
mkdir .config/hypr/
curl -o .config/hypr/hyprland.conf https://raw.githubusercontent.com/SchnuBby2205/hyprdots/main/Configs/.config/hypr/hyprland.conf
curl -o .config/hypr/keybindings.conf https://raw.githubusercontent.com/SchnuBby2205/hyprdots/main/Configs/.config/hypr/keybindings.conf

#Monitor und Inputsettings in hyprland.conf anpassen
#keybinding aus datei in .config/hypr/keybindings.conf einfügen
#Remove the Flags from .config/code-flags.conf
#neustes GE-proton von: https://github.com/GloriousEggroll/wine-ge-custom/releases/tag/GE-Proton8-26
#unter /home/schnubby/.local/share/lutris/runners/wine/ entpacken
#in lutris neues Game hinzufügen es reicht runnter auf wine + name vergeben danach WINEPREFIX wählen und Executable wählen
#Für Hearthstone unter Play Configure DLL Override key: location.dll value disabled

#Für Firefox Bonjour runterladen
#danach https://github.com/SchnuBby2205/W11Settings/blob/main/bonjourr%20settings.json
#settings einspielen

#fstab ggf anpassen
## /dev/nvme0n1p4
#/dev/nvme0n1p4      	/programmieren     	ext4      	rw,relatime	0 1
## /dev/nvme0n1p5
#/dev/nvme0n1p5      	/spiele     	ext4      	rw,relatime	0 1
