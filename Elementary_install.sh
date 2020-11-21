#!/bin/bash

##########################################################
# Elementary 5.1 Hera customization script               #
# (c) D.Sánchez 2020, published under the EU-GPL         #
# Requisites: A fresh installation of Elementary 5.1,    #
# although later editions will probably work as well     #
##########################################################

#Set version
VERSION="v1.3"

#Get username we are running as
USER=`whoami`

#Set colors for whiptail
export NEWT_COLORS=''

#Show welcome message
TERM=ansi whiptail --title "Install Script $VERSION" --msgbox "Written by...\n\n8888888b.   .d8888b.                             888                       \n888  \"Y88b d88P  Y88b                            888                       \n888    888 Y88b.                                 888                       \n888    888  \"Y888b.    8888b.  88888b.   .d8888b 88888b.   .d88b. 88888888 \n888    888     \"Y88b.     \"88b 888 \"88b d88P\"    888 \"88b d8P  Y8b   d88P  \n888    888       \"888 .d888888 888  888 888      888  888 88888888  d88P   \n888  .d88P Y88b  d88P 888  888 888  888 Y88b.    888  888 Y8b.     d88P    \n8888888P\"   \"Y8888P\"  \"Y888888 888  888  \"Y8888P 888  888  \"Y8888 88888888 \n\n                                              ...for ElementaryOS Hera 5.1" 18 79

#Read the sudo password
PASSWORD=$(whiptail --title "Administration password" --passwordbox "Please input your admin password and press ok" 10 50 3>&1 1>&2 2>&3)
STS=$?
if [ $STS = 1 ]; then
    clear
    echo "Cancelled by the user..."
    exit 0
fi

echo $PASSWORD | sudo -S apt-get update;
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections

#Show the software selection
SELCT=$(whiptail --title "Instalar paquetes" --checklist --separate-output "Choose the packets you want to install:" 30 78 23 \
"LIBREOFFICE"       "Libreoffice Packet"                            off \
"ONLYOFFICE"        "OnlyOffice Packet"                             off \
"WINEHQ"            "WineHQ Windows Emulator"                       off \
"CHROME"            "Google Chrome Browser"                         off \
"FIREFOX"           "Mozilla Firefox Browser"                       off \
"SIMPLSC"           "Simple Scan Utility"                           off \
"EPHIMERAL"         "Ephimeral Browser"                             off \
"TRANSLATOR"        "Google Translator"                             off \
"SEQUELER"          "Sequeler DB Tool"                              off \
"RETEXT"            "Retext Markdown Editor"                        off \
"LOCKSMITH"         "Locksmith, a strong password generator"        off \
"PDF_TRICKS"        "PDF Tricks"                                    off \
"GNOME_EXTRAS"      "Gnome Extras"                                  off \
"ELEMENTARY_TWEAKS" "Elementary Tweaks"                             off \
"PLANK"             "Plank Reinstall"                               off \
"RHYTHMBOX"         "Rhythmbox Music Player"                        off \
"BYTE"              "Byte Music Player"                             off \
"VLC"               "VLC Multimedia Player"                         off \
"RELAYCHAT"         "Relay IRC Chat client"                         off \
"AUTO_DRIVER"       "Driver Autoinstall"                            off \
"ADD_CODECS"        "Additional Codecs"                             off \
"ULAUNCHER"         "ULauncher Launcher Menu"                       off \
"COMPRESSION_TOOLS" "Compression Tools"                             off \
"PERSEPOLIS"        "Persepolis Downloader"                         off \
"UGET"              "uGet Downloader"                               off \
"TORRENT"           "Transmission Bittorrent client"                off \
"DARKTABLE"         "Darktable Digital Image Studio"                off \
"RESIZER"           "Resizer Menu Entry"                            off \
"LIBRECAD"          "LibreCAD 2D Editor"                            off \
"FREECAD"           "FreeCAD 3D Editor"                             off \
"QCAD"              "QCad Editor"                                   off \
"TELEGRAM"          "Telegram Desktop Messenger"                    off \
"WHATSAPP"          "WhatsApp Messenger"                            off \
"NOTESUP"           "Notes-UP Note Taking App"                      off \
"PLANNER"           "Planner Todo List and Calendar"                off \
"BOOKWORM"          "Bookworm ePub Reader"                          off \
"ATOM"              "Atom Text Editor"                              off \
"TEAMVIEWER"        "Team Viewer Remote Assistance"                 off \
"NEXTCLOUD"         "NextCloud Desktop Client"                      off \
"VIRTUALBOX"        "Oracles Virtualbox"                            off \
"SOLAAR"            "Solaar Logitech Unifying Reciever"             off \
"SCREENRECORDER"    "Screen Recorder"                               off \
"OBS_STUDIO"        "OBS Studio Screen Recorder"                    off \
"POWERLINE_FONTS"   "Fuentes Powerline"                             off \
"MC"                "Midnight Commander (sin entradas en el menú)"  off \
"UNETBOOTIN"        "Generador de USB Unetbootin"                   off \
"BLENDER"           "Blender 3D Editor"                             off \
"GIMP"              "Gimp Imge Manipulation Program"                off \
"SCRIBUS"           "Scribus Desktop Pûblishing Program"            off \
"INKSCAPE"          "Inkscape Vector Image Design"                  off \
"ARDUINO"           "Arduino IDE + UMAKE"                           off \
"DOLPHIN"           "Dolphin Emulator"                              off \
"RETRO_ARCH"	    "Retro Arch 1.70"                               off \
"ELEM_SDK"          "Elementary Programming SDK"                    off \
3>&1 1>&2 2>&3 )
#Read back exit status
STS=$?
#Did the user accept the dialog?
if [ $STS = 0 ]; then
    #YES - Iterate over items
    for ITEM in $SELCT
    do
        #Check for selections (42 items)
        case $ITEM in
            LIBREOFFICE)
                echo $PASSWORD | sudo -S apt install --yes  libreoffice libreoffice-gtk3 libreoffice-style-elementary libreoffice-l10n-es libreoffice-help-es
                ;;
            ONLYOFFICE)
                echo $PASSWORD | sudo -S apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys CB2DE8E5
                sudo sh -c 'echo "deb https://download.onlyoffice.com/repo/debian squeeze main" >> /etc/apt/sources.list.d/onlyoffice.list'
                sudo apt-get update
                sudo apt install --yes onlyoffice-desktopeditors
                ;;
            WINEHQ)
                echo $PASSWORD | sudo -S dpkg --add-architecture i386
                sudo apt install --yes  winbind software-properties-common
                wget -nc https://dl.winehq.org/wine-builds/winehq.key
                sudo apt-key add winehq.key
                sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys DFA175A75104960E
                sudo apt-add-repository -y 'deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main'
                sudo apt-add-repository -y 'deb https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/ ./'
                sudo apt install --yes --install-recommends winehq-stable
                rm ./winehq.key
                winecfg > /dev/null &
                ;;
            CHROME)
                echo $PASSWORD | sudo -S sh -c 'echo "deb [arch=amd64] https://dl-ssl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
                wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
                sudo apt-get update
                sudo apt install --yes google-chrome-stable
                ;;
            FIREFOX)
                echo $PASSWORD | sudo -S apt install --yes software-properties-common
                sudo apt-add-repository -y ppa:mozillateam/firefox-next
                sudo apt-get update
                sudo apt install --yes firefox-locale-es firefox
                ;;
            SIMPLSC)
                echo $PASSWORD | sudo -S apt install --yes simple-scan
                ;;
            EPHIMERAL)
                echo $PASSWORD | sudo -S apt install --yes com.github.cassidyjames.ephemeral
                ;;
            TRANSLATOR)
                echo $PASSWORD | sudo -S apt install --yes com.github.rapidfingers.translator
                ;;
            SEQUELER)
                echo $PASSWORD | sudo -S apt install --yes com.github.alecaddd.sequeler
                ;;
            RETEXT)
                echo $PASSWORD | sudo -S apt install --yes retext
                ;;
            LOCKSMITH)
                echo $PASSWORD | sudo -S apt install --yes com.github.christophernugent.locksmith
                ;;
            PDF_TRICKS)
                echo $PASSWORD | sudo -S apt install --yes com.github.muriloventuroso.pdftricks pdfmod
                ;;
            GNOME_EXTRAS)
                echo $PASSWORD | sudo -S apt install --yes gnome-maps gnome-weather gnome-mahjongg
                ;;
            ELEMENTARY_TWEAKS)
                echo $PASSWORD | sudo -S apt install --yes software-properties-common
                sudo add-apt-repository -y ppa:philip.scott/elementary-tweaks
                sudo apt update
                sudo apt install --yes elementary-tweaks
                ;;
            PLANK)
                echo $PASSWORD | sudo -S apt install --yes software-properties-common
                sudo add-apt-repository -y ppa:ricotz/docky
                sudo apt-get update
                sudo apt install --yes --reinstall plank
                sudo rm /usr/share/applications/plank.desktop
                ;;
            RHYTHMBOX)
                echo $PASSWORD | sudo -S apt install --yes rhythmbox
                mkdir -p ~/.local/share/rhythmbox/
                cp ./Data/rhythmdb.xml ~/.local/share/rhythmbox/
                ;;
            BYTE)
                echo $PASSWORD | sudo -S apt install --yes com.github.alainm23.byte
                ;;
            VLC)
                echo $PASSWORD | sudo -S apt install --yes vlc
                ;;
            RELAYCHAT)
                echo $PASSWORD | sudo -S apt install --yes software-properties-common
                sudo apt-add-repository ppa:agronick/relay
                sudo apt-get update
                sudo apt-get install --yes relay
                ;;
            AUTO_DRIVER)
                echo $PASSWORD | sudo -S ubuntu-drivers autoinstall
                ;;
            ADD_CODECS)
                echo $PASSWORD | sudo -S apt install --yes ubuntu-restricted-extras libavcodec-extra x264
                ;;
            ULAUNCHER)
                echo $PASSWORD | sudo -S apt install --yes software-properties-common
                sudo add-apt-repository -y ppa:agornostal/ulauncher
                sudo apt-get update
                sudo apt install --yes ulauncher
                ;;
            COMPRESSION_TOOLS)
                echo $PASSWORD | sudo -S apt-get install -yes rar unrar p7zip-full p7zip-rar
                ;;
            PERSEPOLIS)
                echo $PASSWORD | sudo -S apt install --yes software-properties-common
                sudo add-apt-repository -y ppa:persepolis/ppa
                sudo apt update
                sudo apt install --yes persepolis
                ;;
            UGET)
                echo $PASSWORD | sudo -S apt install --yes software-properties-common
                sudo apt-add-repository -y ppa:plushuang-tw/uget-stable
                sudo apt-get update
                sudo apt-get install --yes uget aria2
                ;;
            TORRENT)
                echo $PASSWORD | sudo -S apt install --yes transmission-gtk
                ;;
            DARKTABLE)
                echo $PASSWORD | sudo -S apt install --yes darktable
                ;;
            RESIZER)
                echo $PASSWORD | sudo -S apt install --yes com.github.peteruithoven.resizer
                ;;
            LIBRECAD)
                echo $PASSWORD | sudo -S apt install --yes librecad
                ;;
            FREECAD)
                echo $PASSWORD | sudo -S apt install --yes software-properties-common
                sudo add-apt-repository -y ppa:freecad-maintainers/freecad-stable
                sudo apt-get update
                sudo apt install --yes freecad
                ;;
            QCAD)
                echo $PASSWORD | sudo -S apt install --yes software-properties-common
                sudo add-apt-repository -y ppa:alex-p/qcad
                sudo apt-get update
                sudo apt install --yes qcad
                ;;
            TELEGRAM)
                wget https://telegram.org/dl/desktop/linux
                tar -xf linux
                mv ./Telegram ~/.Telegram
                sed "s/~/\/home\/$USER/g" ./Data/telegramdesktop.desktop > ~/.local/share/applications/telegramdesktop.desktop
                rm ./linux
                ;;
            WHATSAPP)
                echo $PASSWORD | sudo -S apt install --yes software-properties-common
                sudo add-apt-repository -y ppa:atareao/whatsapp-desktop
                sudo apt update
                sudo apt install --yes whatsapp-desktop
                #Correct error...
                #Backup the original file
                sudo mv /opt/whatsapp-desktop/resources/app/main.js /opt/whatsapp-desktop/resources/app/main.bak
                #Create a corrected version
                sed '/whatsApp.window.loadURL/a \            whatsApp.window.webContents.setUserAgent\(\"Mozilla\/5.0 \(X11\; Linux x86_64\) AppleWebKit\/537.36 \(KHTML, like Gecko\) Chrome\/80.0.3987.87 Safari\/537.36\"\)\;' /opt/whatsapp-desktop/resources/app/main.bak > ./main.js
                #Move that version to it's place
                sudo mv ./main.js /opt/whatsapp-desktop/resources/app/
                ;;
            NOTESUP)
                echo $PASSWORD | sudo -S apt install --yes com.github.philip-scott.notes-up
                ;;
            PLANNER)
                echo $PASSWORD | sudo -S apt install --yes com.github.alainm23.planner
                ;;
            BOOKWORM)
                echo $PASSWORD | sudo -S apt install --yes com.github.babluboy.bookworm
                ;;
            ATOM)
                echo $PASSWORD | sudo -S sh -c 'echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" > /etc/apt/sources.list.d/atom.list'
                curl -L https://packagecloud.io/AtomEditor/atom/gpgkey | sudo apt-key add -
                sudo apt update
                sudo apt install --yes atom
                ;;
            TEAMVIEWER)
		wget "https://download.teamviewer.com/download/linux/teamviewer_amd64.deb"
		echo $PASSWORD | sudo -S apt install --yes ./teamviewer*.deb
                ;;
            NEXTCLOUD)
                echo $PASSWORD | sudo -S apt install --yes software-properties-common
                sudo add-apt-repository -y ppa:nextcloud-devs/client
                sudo apt-get update
                sudo apt install --yes nextcloud-client
                ;;
            VIRTUALBOX)
                echo $PASSWORD | sudo -S apt install --yes virtualbox virtualbox-guest-additions-iso
                ;;
            SOLAAR)
                echo $PASSWORD | sudo -S apt install --yes solaar
                ;;
            SCREENRECORDER)
                echo $PASSWORD | sudo -S apt install --yes com.github.mohelm97.screenrecorder
                ;;
            OBS_STUDIO)
                echo $PASSWORD | sudo -S apt install --yes obs-plugins obs-studio
                ;;
            POWERLINE_FONTS)

                echo $PASSWORD | sudo -S apt install --yes fonts-powerline
                ;;
            MC)
                echo $PASSWORD | sudo -S apt install --yes  mc
                sudo rm /usr/share/applications/mc.desktop
                sudo rm /usr/share/applications/mcedit.desktop
                ;;
            UNETBOOTIN)
                echo $PASSWORD | sudo -S apt install --yes software-properties-common
                sudo add-apt-repository -y ppa:gezakovacs/ppa
                sudo apt-get update
                sudo apt-get install --yes unetbootin
                ;;
            BLENDER)
                echo $PASSWORD | sudo -S apt install --yes blender
                ;;
            GIMP)
                echo $PASSWORD | sudo -S apt install --yes gimp
                ;;
            SCRIBUS)
                echo $PASSWORD | sudo -S apt install --yes scribus scribus-template
                ;;
            INKSCAPE)
                echo $PASSWORD | sudo -S apt install --yes inkscape
                ;;
            ARDUINO)
                echo $PASSWORD | sudo -S apt install -yes ubuntu-make
                umake ide arduino
                sudo usermod -a -G dialout $USER
                ;;
            DOLPHIN)
                echo $PASSWORD | sudo -S apt install --yes software-properties-common
                sudo add-apt-repository -y ppa:dolphin-emu/ppa
                sudo apt-get update
                sudo apt-get install --yes dolphin-emu
                ;;
	    RETRO_ARCH)
	        echo $PASSWORD | sudo -S apt install --yes software-properties-common
                sudo add-apt-repository -y ppa:libretro/stable
		sudo apt-get update
		sudo apt-get install --yes retroarch libretro-*
	        ;;
            ELEM_SDK)
                echo $PASSWORD | sudo -S apt install --yes elementary-sdk
                ;;
        esac
    done
else
    clear
    echo "Cancelled by the user"
    exit 0
fi

#Show the configuration dialog
SELCT=$(whiptail --title "Special configurations" --checklist --separate-output "Choose your configuration:" 12 78 6 \
"OPENLDAP"    "Unir Elementary a un servidor LDAPLog Elementary into an OpenLDAP Server"        off \
"APEXSTEEL"   "Install software for an Apex Steelseries keyboard"           			off \
"ONECLICK"    "Disable 'one klick' setting in files"       					off \
"BASHRC"      "Install custom bashrc"  								off \
"TIVIEW"      "tiv Image Viewer for bash"                   					off \
"SHUTDOWNTM"  "Reduce shutdown time"                						off \
3>&1 1>&2 2>&3 )
#Read back exit status
STS=$?
#Did the user accept the dialog?
if [ $STS = 0 ]; then
    #YES - Iterate over items
    for ITEM in $SELCT
    do
        #Check for selections
        case $ITEM in
            OPENLDAP)
                echo $PASSWORD | sudo -S apt install --yes openssh-server ldap-auth-client ldap-utils nscd
                sudo sh -c "sed -i 's/passwd:         compat systemd/passwd:         ldap compat/g' /etc/nsswitch.conf"
                sudo sh -c "sed -i 's/group:          compat systemd/group:          ldap compat/g' /etc/nsswitch.conf"
                sudo sh -c "sed -i 's/shadow:         compat/shadow:         compat/g' /etc/nsswitch.conf"
                sudo sh -c "cat << EOF >> /etc/pam.d/common-session

#Adding personalized options for LDAP
session required        pam_mkhomedir.so skel=/etc/skel umask=0022
EOF"
                sudo auth-client-config -t nss -p lac_ldap
                sudo sh -c "cat << EOF >> /usr/share/pam-configs/mkhomedir
Name: Create home directory on login for LDAP Users
Default: yes
Priority: 0
Session-Type: Additional
Session-Interactive-Only: yes
Session:
required                        pam_mkhomedir.so umask=0022 skel=/etc/skel
EOF"
                sudo pam-auth-update
                sudo sh -c "sed -i 's/pam_ldap.so use_authtok try_first_pass/pam_ldap.so try_first_pass/g' /etc/pam.d/common-password"
                ;;
            APEXSTEEL)
                echo $PASSWORD | sudo -S apt install --yes ghc libusb-1.0-0-dev cabal-install git pkg-config elementary-sdk
                git clone https://github.com/tuxmark5/ApexCtl.git master
                cd ./master
                cabal update && cabal install usb cmdargs && make && sudo make install
                cd ..
                rm -rf ./master
                #TODO:
                #Download and install sunwait
                #Configure cron services
                ;;
            ONECLICK)
                gsettings set io.elementary.files.preferences single-click false
                ;;
            BASHRC)
                cat ./Data/bashrc.txt >> ~/.bashrc
                gsettings set io.elementary.terminal.settings font 'Ubuntu Mono Regular 12'
                ;;
            TIVIEW)
                mkdir ~/tmp
                cd ~/tmp/
                git clone https://github.com/stefanhaustein/TerminalImageViewer.git
                cd TerminalImageViewer/src/main/cpp
                make
                echo $PASSWORD | sudo -s sh -c "make install"
                ;;
            SHUTDOWNTM)
                echo $PASSWORD | sudo -S sh -c "sed -i 's/#DefaultTimeoutStartSec=90s/DefaultTimeoutStartSec=10s/g' /etc/systemd/system.conf"
                sudo sh -c "sed -i 's/#DefaultTimeoutStopSec=90s/DefaultTimeoutStopSec=10s/g' /etc/systemd/system.conf"
                sudo systemctl daemon-reload
                sudo /etc/init.d/nscd restart
                ;;
        esac
    done
fi


#Change Wallpaper
wget "https://wallpapercave.com/wp/wp2030266.png" -O Wallpaper.png
echo $PASSWORD | sudo -S cp ./Wallpaper.png /usr/share/backgrounds/
gsettings set org.gnome.desktop.background picture-uri file:////usr/share/backgrounds/Wallpaper.png

#Show the software removal
SELCT=$(whiptail --title "Delete default packages" --checklist --separate-output "Choose which one to delete:" 12 78 6 \
"NOISE"       "Elementary's default Audio app"              off \
"AUDIENCE"    "Elementary's default Video app"              off \
"EPIPHANY"    "Default web browser"                         off \
"CAMERA"      "Default Webcam Application"                  off \
"AUTOREMOVE"  "Borrar los paquetes huérfanos"               off \
3>&1 1>&2 2>&3 )
#Read back exit status
STS=$?
#Did the user accept the dialog?
if [ $STS = 0 ]; then
    #YES - Iterate over items
    for ITEM in $SELCT
    do
        #Check for selections (42 items)
        case $ITEM in
          NOISE)
            echo $PASSWORD | sudo -S apt-get --yes purge noise
            ;;
          AUDIENCE)
            echo $PASSWORD | sudo -S apt-get --yes purge mpv audience
            ;;
          EPIPHANY)
            echo $PASSWORD | sudo -S apt-get --yes purge epiphany epiphany-browser-data
            ;;
          CAMERA)
            echo $PASSWORD | sudo -S apt-get --yes purge io.elementary.camera
            ;;
          AUTOREMOVE)
            echo $PASSWORD | sudo -S apt-get --yes autoremove
            sudo apt-get update
            sudo apt-get --yes upgrade
            ;;
        esac
    done
fi

#Show the reboot dialog
if (whiptail --title "Reboot" --yesno "We're done, do you want to reboot? " 8 78); then
    echo $PASSWORD | sudo -S reboot
else
    clear
    echo "You chose not to reboot. Finishing script... bye.."
fi


#TODO:
#https://github.com/mank319/elementaryPlus
#https://github.com/harveycabaguio/firefox-elementary-theme
#https://github.com/tkashkin/GameHub
