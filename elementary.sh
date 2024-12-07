#!/bin/env bash


##########################################################
# Elementary 8.0 customization script                    #
# (c) D.Sánchez 2024, published under the EU-GPL         #
# Requisites: A fresh installation of Elementary OS      #
##########################################################


### Set version
VERSION="v3.0"


### Get username we are running as
USER=`whoami`


### Set colors for whiptail
export NEWT_COLORS=''


### Show welcome message
TERM=ansi whiptail --title "Install Script $VERSION" --msgbox "Written by...\n\n8888888b.   .d8888b.                             888                       \n888  \"Y88b d88P  Y88b                            888                       \n888    888 Y88b.                                 888                       \n888    888  \"Y888b.    8888b.  88888b.   .d8888b 88888b.   .d88b. 88888888 \n888    888     \"Y88b.     \"88b 888 \"88b d88P\"    888 \"88b d8P  Y8b   d88P  \n888    888       \"888 .d888888 888  888 888      888  888 88888888  d88P   \n888  .d88P Y88b  d88P 888  888 888  888 Y88b.    888  888 Y8b.     d88P    \n8888888P\"   \"Y8888P\"  \"Y888888 888  888  \"Y8888P 888  888  \"Y8888 88888888 \n\n                                              ...for ElementaryOS 8.0" 18 79


### Read the sudo password
PASSWORD=$(whiptail --title "Administration password" --passwordbox "Please input your admin password" 10 50 3>&1 1>&2 2>&3)
STS=$?
if [ $STS = 1 ]; then
    clear
    echo "Cancelled by the user..."
    exit 0
fi


### Let's first update the system
echo $PASSWORD | sudo -S apt update
echo $PASSWORD | sudo -S apt upgrade --yes
echo $PASSWORD | sudo -S flatpak update -y


### Let's install a few interesting (mostly needed) packets here...
echo $PASSWORD | sudo -S apt install rar unrar ace unace p7zip-full p7zip-rar software-properties-common git curl cryptsetup pv imagemagick imagemagick-doc ffmpeg ffmpeg-doc python3-pip python-is-python3 mycli httpie vim vim-autopairs vim-pathogen --yes

### Let's remove some unwanted menu entries...
echo $PASSWORD | sudo -S rm '/usr/share/applications/display-im6.q16.desktop'


### Show the software removal dialog
SELCT=$(whiptail --title "System adjustments" --checklist --separate-output "Choose an option..." 12 78 6 \
"FONTS"       "Change default system fonts"                        off \
"TIVIEW"      "tiv Image Viewer for bash"                   	   off \
"MUSIC"       "Remove Elementary's default music app"              off \
"PAROLE"      "Remove Elementary's default video app"              off \
"TASKS"       "Remove Elementary's default task app"               off \
"CAMERA"      "Remove Default webcam application"                  off \
3>&1 1>&2 2>&3 )
#Read back exit status
STS=$?
#Did the user accept the dialog?
if [ $STS = 0 ]; then
    #YES - Iterate over items
    for ITEM in $SELCT
    do
        #Check for selections (~ items)
        case $ITEM in
          FONTS)
            curl -o- "https://raw.githubusercontent.com/dsancheznet/terminal-utilities/refs/heads/main/font_installer.sh" | bash
            gsettings set io.elementary.terminal.settings font "IosevkaTerm Nerd Font Mono 11"
            gsettings set org.gnome.desktop.interface font-name "San Francisco Display 11"
            ;;
          TIVIEW)
            ### Let's compile and install tiv
            mkdir ~/tmp
            cd ~/tmp/
            git clone https://github.com/stefanhaustein/TerminalImageViewer.git
            cd TerminalImageViewer/src/main/cpp
            make
            echo $PASSWORD | sudo -s sh -c "make install"
            cd ~
            rm -rf ./tmp
            ;;
          MUSIC)
            flatpak uninstall io.elementary.music -y
            ;;
          PAROLE)
            flatpak uninstall io.elementary.videos -y
            echo $PASSWORD | sudo -S apt purge io.elementary.videos --yes 
            ;;
          CAMERA)
            flatpak uninstall io.elementary.camera -y
            ;;
          TASKS)
            echo $PASSWORD | sudo -S apt purge io.elementary.tasks --yes
            ;;
        esac
    done
fi


### Show the software selection
SELCT=$(whiptail --title "Instalar paquetes" --checklist --separate-output "Choose the packets you want to install:" 30 78 23 \
"ONLYOFFICE"        "OnlyOffice Packet"                             off \
"FIREFOX"           "Mozilla Firefox Browser"                       off \
"VLC"               "VLC Multimedia Player"                         off \
"KODI"              "Kodi mediacenter"                              off \
"ULAUNCHER"         "ULauncher Launcher Menu"                       off \
"YOUTDL"            "yt-dlp Video Downloader"                       off \
"TORRENT"           "Transmission Bittorrent client"                off \
"LIBRECAD"          "LibreCAD 2D Editor"                            off \
"FREECAD"           "FreeCAD 3D Editor"                             off \
"CURA"              "Cura Slicer"                                   off \
"TELEGRAM"          "Telegram Desktop Messenger"                    off \
"MC"                "Midnight Commander"	         	    off \
"BLENDER"           "Blender 3D Editor"                             off \
"GIMP"              "Gimp Imge Manipulation Program"                off \
"INKSCAPE"	    "Inkscape Vector Drawing Program"		    off \
"JOPLIN"            "Joplin Markdown Notes"                         off \
"MISSION"           "Mission Center for Gnome"                      off \
"RUSTDESK"          "Rustdesk remote utility"                       off \
"COMPRESS"          "Compression utilities"                         off \
"DUFTM"             "df replacement"                                off \
"EZATM"             "ls replacement"                                off \
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
            ONLYOFFICE)
                flatpak install --user org.onlyoffice.desktopeditors -y
                ;;
            FIREFOX)
                flatpak install --user org.mozilla.firefox -y
                flatpak uninstall org.gnome.Epiphany -y
                ;;
            VLC)
                flatpak install --user org.videolan.VLC -y
                ;;
            KODI)
                flatpak install --user tv.kodi.Kodi -y
                ;;
            ULAUNCHER)
                echo $PASSWORD | sudo -S apt install --yes software-properties-common
                echo $PASSWORD | sudo -S add-apt-repository -y ppa:agornostal/ulauncher
                echo $PASSWORD | sudo -S apt-get update
                echo $PASSWORD | sudo -S apt install --yes ulauncher
                ;;
            YOUTDL)
                echo $PASSWORD | sudo -S apt install --yes yt-dlp
                ;;
            TORRENT)
                flatpak install --user com.transmissionbt.Transmission -y
                ;;
            LIBRECAD)
                echo $PASSWORD | sudo -S apt install --yes librecad
                ;;
            FREECAD)
                flatpak install --user org.freecad.FreeCAD -y
                ;;
            CURA)
                flatpak install com.ultimaker.cura --user -y
                ;;
            TELEGRAM)
                flatpak install --user org.telegram.desktop -y
                ;;
            MC)
                echo $PASSWORD | sudo -S apt install --yes  mc
                echo $PASSWORD | sudo -S rm /usr/share/applications/mc.desktop
                echo $PASSWORD | sudo -S rm /usr/share/applications/mcedit.desktop
                # inside .config/mc/ini
                # skin=mondarin256
                # sed -i -e '/central\.database =/ s/= .*/= new_value/' /path/to/file
                sed -i -e '/skin=/ s/=.*/=mondarin256/' ~/.config/mc/ini
                # inside ~/.selected-editor
                # SELECTED_EDITOR="/usr/bin/mcedit"
                ;;
            BLENDER)
                flatpak install --user org.blender.Blender -y
                ;;
            GIMP)
                flatpak install --user org.gimp.GIMP -y
                ;;
            INKSCAPE)
                flatpak install --user org.inkscape.Inkscape -y
                ;;
            JOPLIN)
                flatpak install --user net.cozic.joplin_desktop -y
                ;;
            MISSION)
                flatpak install --user io.missioncenter.MissionCenter -y
                ;;
            RUSTDESK)
		flatpak install --user com.rustdesk.RustDesk -y
  		;;
            COMPRESS)
                echo $PASSWORD | sudo -S apt install rar unrar ace unace p7zip-full p7zip-rar -y
                ;;
            DUFTM)
                echo $PASSWORD | sudo -S apt install --yes duf
                ;;
            EZATM)
                echo $PASSWORD | sudo -S apt install --yes eza
                ;;
        esac
        flatpak install --user com.github.tchx84.Flatseal -y
    done
else
    clear
    echo "Cancelled by the user"
    exit 0
fi


Show the reboot dialog
if (whiptail --title "Reboot" --yesno "We're done, do you want to clean up and reboot? " 8 78); then
    echo $PASSWORD | sudo -S apt autoremove
    echo $PASSWORD | sudo -S reboot
else
    clear
    echo $PASSWORD | sudo -S apt autoremove
    echo "You chose not to reboot. Cleaning is done. Finishing script... bye.. "
fi


