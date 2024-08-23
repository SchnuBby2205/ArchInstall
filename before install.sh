#before install
#lsblk um platten zu sehen
#mkfs.fat -F 32 auf boot platte
#mkfs.ext4 auf root platte
#mount --mkdir rootplatte /mnt
#mount --mkdir bootplatte /mnt/boot
#in archinstall platten nochmal kontrollieren

#ausführen
#mkdir schnubby_downloads
#cd schnubby_downloads
#curl -o conf.json https://raw.githubusercontent.com/SchnuBby2205/ArchInstall/main/user_configuration.json
#curl -o creds.json https://raw.githubusercontent.com/SchnuBby2205/ArchInstall/main/user_credentials.json
#cd ..
#archinstall --conf ./schnubby_downloads/conf.json --creds ./schnubby_downloads/creds.json

#after install ausführen
#git clone https://github.com/prasanthrangan/hyprdots ~/Hyprdots
#cd ~/Hyprdots/Scripts
#sed '/brightnessctl/d' ./custom_hypr.lst
#kontrolle mit cat / nano / vim oder less
#./install.sh -drs
#Hier noch prüfen was default flag ist (testen mit drs)

#ausführen
#mkdir schnubby_downloads
#cd schnubby_downloads
#mkdir .config/hypr/
#curl -o .config/hypr/hyprland.conf https://raw.githubusercontent.com/SchnuBby2205/hyprdots/main/Configs/.config/hypr/hyprland.conf
#curl -o .config/hypr/keybindings.conf https://raw.githubusercontent.com/SchnuBby2205/hyprdots/main/Configs/.config/hypr/keybindings.conf
#Monitor und Inputsettings in hyprland.conf anpassen
#keybinding aus datei in .config/hypr/keybindings.conf einfügen
#Remove the Flags from .config/code-flags.conf
#neustes GE-proton von: https://github.com/GloriousEggroll/wine-ge-custom/releases/tag/GE-Proton8-26
#unter /home/schnubby/.local/share/lutris/runners/wine/ entpacken
#in lutris neues Game hinzufügen es reicht runnter auf wine + name vergeben danach WINEPREFIX wählen und Executable wählen
#Für Hearthstone unter Play Configure DLL Override key: location.dll value disabled