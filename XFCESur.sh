#!/bin/bash


#To start with, let's update the system
echo "Updating OS to latest..."
sudo pacman -Syu --noconfirm


#Install AUR packets
echo "Installing necessary packets from AUR (this will prompt you for your password several times)"
pamac build nautilus-admin nautilus-gnome-disks panther-launcher-git appmenu-gtk-module-git vala-panel-appmenu-xfce-git vala-panel-appmenu-registrar-git lightdm-webkit2-theme-glorious plank-git ulauncher


#Install regular packets
echo "Installing packets from repo"
pamac install sassc optipng mc firefox xfce4-weather-plugin inkscape gimp gimp-help-es terminology vlc geary


#Prepare directories
echo "Creating theme directories"
mkdir -p {~/.themes,~/.icons,~/.fonts}


#Launching programs to have them create their config directories
firefox &
ulauncher &
plank &


#Install fonts
echo "Installing fonts"
git clone "https://github.com/AppleDesignResources/SanFranciscoFont.git"
cd SanFranciscoFont/
mv *.otf ~/.fonts/
fc-cache -fv
cd ..
rm -rf SanFranciscoFont/


#Pull themes
echo "Downloading theme data"
git clone "https://github.com/vinceliuice/WhiteSur-cursors.git"
git clone "https://github.com/vinceliuice/WhiteSur-gtk-theme.git"
git clone "https://github.com/vinceliuice/WhiteSur-icon-theme.git"
#Install themes
echo "Installing icon theme"
cd WhiteSur-icon-theme/
./install.sh
cd ..
rm -rf WhiteSur-icon-theme/

echo "Installing cursors"
cd WhiteSur-cursors/
sudo ./install.sh
cd ..
rm -rf WhiteSur-cursors/

echo "Installing gtk theme"
cd WhiteSur-gtk-theme/
./install.sh
echo "Configuring Firefox"
killall -9 firefox
cd src/other/firefox
cp configuration/user.js ~/.mozilla/firefox/*.default-release/
cp -r chrome ~/.mozilla/firefox/*.default-release/
echo 'user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);' >> ~/.mozilla/firefox/*.default-release/prefs.js
echo "Configuring Plank"
cd ../plank
cp -r theme-dark ~/.local/share/plank/themes/WhiteSur-Dark
cp -r theme-light ~/.local/share/plank/themes/WhiteSur-Light
dconf write /net/launchpad/plank/docks/dock1/theme "'WhiteSur-Light'"
dconf write /net/launchpad/plank/docks/dock1/zoom-enabled true
dconf write /net/launchpad/plank/docks/dock1/zoom-percent 175
dconf write /net/launchpad/plank/docks/dock1/icon-size 58
cd ../../../..
rm -rf WhiteSur-gtk-theme/


#Configure Window Manager
echo "Configuring Window manager"
xfconf-query -c xsettings -p /Gtk/ShellShowsMenubar -n -t bool -s true
xfconf-query -c xsettings -p /Gtk/ShellShowsAppmenu -n -t bool -s true
xfconf-query -c xsettings -p /Gtk/FontName -t string -s 'San Francisco Display 10'
xfconf-query -c xsettings -p /Net/ThemeName -t string -s 'WhiteSur-light'
xfconf-query -c xsettings -p /Net/IconThemeName -t string -s 'WhiteSur'
xfconf-query -c xsettings -p /Gtk/CursorThemeName -t string -s 'WhiteSur-cursors'
xfconf-query -c xfwm4 -p /general/show_dock_shadow -t bool -s false
xfconf-query -c xfwm4 -p /general/button_layout -t string -s 'CHM|'
xfconf-query -c xfwm4 -p /general/theme -t string 'WhiteSur-light'
xfconf-query -c xfce4-desktop -p /desktop-icons/icon-size -t int -s 64
xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons/show-removable -t bool -s true
xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons/show-trash -t bool -s false
xfconf-query -c xfce4-desktop -p /desktop-icons/gravity -t int -s 2 --create


#Remove software we don't want anymore
echo "Remove superfluous software"
pamac remove midori parole


#Download and install wallpapers
echo "Downloading and installing wallpaper"
sudo wget "https://wallpapercave.com/wp/wp6761049.png" -O /usr/share/backgrounds/BigSur.png
xfconf-query --channel xfce4-desktop --property /backdrop/screen0/monitor0/image-path -s "/usr/share/backgrounds/BigSur.png"


#Configure Greeter
echo "Configuring greeter"
#https://forum.xfce.org/viewtopic.php?id=8619
sudo sed -i 's/\=lightdm\-gtk\-greeter/\=lightdm\-webkit2\-greeter/g' /etc/lightdm/lightdm.conf
sudo sed -i 's/antergos/glorious/g' /etc/lightdm/lightdm-webkit2-greeter.conf


#Configure Plank
sudo -c bash "cat << EOF > /etc/xdg/autostart/plank-autostart.desktop
[Desktop Entry]
Type=Application
Name=Plank Dock
Exec=plank
Terminal=false
EOF"


#TODO
#Install powerline fonts
#Install bash
#Change greeter background
