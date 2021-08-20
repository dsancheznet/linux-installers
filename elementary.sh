#!/bin/env bash


##########################################################
# Elementary 6.0 Odin customization script               #
# (c) D.Sánchez 2021, published under the EU-GPL         #
# Requisites: A fresh installation of Elementary OS      #
##########################################################


### Set version
VERSION="v2.0"


### Get username we are running as
USER=`whoami`


### Set colors for whiptail
export NEWT_COLORS=''


### Show welcome message
TERM=ansi whiptail --title "Install Script $VERSION" --msgbox "Written by...\n\n8888888b.   .d8888b.                             888                       \n888  \"Y88b d88P  Y88b                            888                       \n888    888 Y88b.                                 888                       \n888    888  \"Y888b.    8888b.  88888b.   .d8888b 88888b.   .d88b. 88888888 \n888    888     \"Y88b.     \"88b 888 \"88b d88P\"    888 \"88b d8P  Y8b   d88P  \n888    888       \"888 .d888888 888  888 888      888  888 88888888  d88P   \n888  .d88P Y88b  d88P 888  888 888  888 Y88b.    888  888 Y8b.     d88P    \n8888888P\"   \"Y8888P\"  \"Y888888 888  888  \"Y8888P 888  888  \"Y8888 88888888 \n\n                                              ...for ElementaryOS 6.0 Odin" 18 79


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
echo $PASSWORD | sudo -S apt install rar unrar ace unace p7zip-full p7zip-rar software-properties-common git curl cryptsetup pv imagemagick imagemagick-doc ffmpeg ffmpeg-doc python3-pip python-is-python3 mycli httpie neofetch --yes

### Let's remove some unwanted menu entries...
echo $PASSWORD | sudo -S rm '/usr/share/applications/display-im6.q16.desktop'


### Show the software removal dialog
SELCT=$(whiptail --title "System adjustments" --checklist --separate-output "Choose an option..." 12 78 6 \
"IOSEVKA"     "Change default terminal font"                       off \
"PROMPTTM"    "Change default prompt for a powerline style"        off \
"TIVIEW"      "tiv Image Viewer for bash"                   	   off \
"NOISE"       "Remove Elementary's default audio app"              off \
"AUDIENCE"    "Remove Elementary's default video app"              off \
"EPIPHANY"    "Remove Default web browser"                         off \
"CAMERA"      "Remove Default webcam application"                  off \
"TASKS"       "Remove Default tasks application"                   off \
"HOSTNM"      "Customize system hostname"                          off \
"APEXSTEEL"   "Apex Steel Software"                                off \
"FLATHUB"     "Add Flathub repos"                                  off \
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
          IOSEVKA)
            wget "https://github.com/be5invis/Iosevka/releases/download/v6.1.2/ttf-iosevka-6.1.2.zip"
            wget "https://github.com/be5invis/Iosevka/releases/download/v6.1.2/ttf-iosevka-term-6.1.2.zip"
            wget "https://github.com/be5invis/Iosevka/releases/download/v6.1.2/ttf-iosevka-fixed-6.1.2.zip"
            for I in *.zip; do unzip $I; rm $I; done;
            sudo echo $PASSWORD | sudo -S mkdir -p /usr/share/fonts/truetype/iosevka/
            sudo echo $PASSWORD | sudo -S mv *.ttf /usr/share/fonts/truetype/iosevka
            fc-cache -f -v
            gsettings set io.elementary.terminal.settings font "Iosevka Term 13"
            ;;
          PROMPTTM)
            cat << EOF >> ~/.bashrc

#Customizations
alias cls='clear;exa -lh --header'
alias clsh='clear;duf;exa -lah --header'

shopt -s cdspell

if [ -n "$SSH_CLIENT" ]; then
    TRINGL=" "
else
    TRINGL=$'\uE0B0'
fi

#New string for a 265 color console
export PS1='\[\e[38;5;0m\]\[\e[48;5;32m\]$TRINGL\[\e[38;5;226;48;5;32m\]\[\e[1m\] \u \[\e[38;5;0;48;5;32m\] \h \[\e[38;5;32;48;5;59m\]$TRINGL\[\e[38;5;255;48;5;59m\] \w \[\e[38;5;59;48;5;0m\]$TRINGL\[\e[0m\] '

#Add new routes to path
#export PATH=/usr/share/swift/usr/bin:$PATH

##Banner
neofetch

EOF
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
          NOISE)
            echo $PASSWORD | sudo -S apt purge noise --yes
            ;;
          AUDIENCE)
            echo $PASSWORD | sudo -S apt purge audience io.elementary.videos --yes

            ;;
          EPIPHANY)
            echo $PASSWORD | sudo -S apt purge midori --yes
            echo $PASSWORD | sudo -S flatpak uninstall org.gnome.Epiphany -y
            ;;
          CAMERA)
            echo $PASSWORD | sudo -S flatpak uninstall io.elementary.camera -y
            ;;
          TASKS)
            echo $PASSWORD | sudo -S flatpak uninstall io.elementary.tasks -y
            ;;
          HOSTNM)
            MYHOSTNAME=$(whiptail --inputbox "Please specify your customized hostname" 8 39 "`cat /etc/hostname`" --title "Hostname" 3>&1 1>&2 2>&3)
            exitstatus=$?
            if [ $exitstatus = 0 ]; then
                echo $PASSWORD | sudo sh -c "echo $MYHOSTNAME > /etc/hostname"
            else
                echo "Cancelled by the user"
            fi

            echo "Exit status $exitstatus"
            ;;
          APEXSTEEL)
            ### Let's compile and install sunwait
            cd ~
            git clone https://github.com/risacher/sunwait.git
            cd sunwait
            make
            sudo mv ./sunwait /usr/local/bin
            cd ~
            rm -rf sunwait/
            ## Let's compile and install apexctrl
            echo $PASSWORD | sudo -S apt install --yes ghc libusb-1.0-0-dev cabal-install pkg-config
            git clone https://github.com/tuxmark5/ApexCtl.git master
            cd ./master
            cabal update && cabal install usb cmdargs && make && sudo make install
            cd ~
            rm -rf ./master
            #TODO: INSTALL SCRIPT AND CRONTABS
            ;;
          FLATHUB)
            flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
            ;;
        esac
    done
fi


### Show the software selection
SELCT=$(whiptail --title "Instalar paquetes" --checklist --separate-output "Choose the packets you want to install:" 30 78 23 \
"LIBREOFFICE"       "Libreoffice Packet"                            off \
"ONLYOFFICE"        "OnlyOffice Packet"                             off \
"FIREFOX"           "Mozilla Firefox Browser"                       off \
"ELEMENTARY_TWEAKS" "Elementary Tweaks"                             off \
"VLC"               "VLC Multimedia Player"                         off \
"ULAUNCHER"         "ULauncher Launcher Menu"                       off \
"UGET"              "uGet Downloader"                               off \
"YOUTDL"            "youtube-dl Video Downloader"                   off \
"TORRENT"           "Transmission Bittorrent client"                off \
"LIBRECAD"          "LibreCAD 2D Editor"                            off \
"FREECAD"           "FreeCAD 3D Editor"                             off \
"QCAD"              "QCad Editor"                                   off \
"TELEGRAM"          "Telegram Desktop Messenger"                    off \
"TEAMVIEWER"        "Team Viewer Remote Assistance"                 off \
"NEXTCLOUD"         "NextCloud Desktop Client"                      off \
"VIRTUALBOX"        "Oracles Virtualbox"                            off \
"SOLAAR"            "Solaar Logitech Unifying Reciever"             off \
"MC"                "Midnight Commander"		            off \
"BLENDER"           "Blender 3D Editor"                             off \
"GIMP"              "Gimp Imge Manipulation Program"                off \
"SCRIBUS"           "Scribus Desktop Pûblishing Program"            off \
"ELEM_SDK"          "Elementary Programming SDK"                    off \
"JOPLIN"            "Joplin Markdown Notes"                         off \
"DUFTM"             "df replacement"                                off \
"EXATM"             "ls replacement"                                off \
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
                echo $PASSWORD | sudo -S apt install --yes software-properties-common
		echo $PASSWORD | sudo -S add-apt-repository ppa:libreoffice/ppa
                echo $PASSWORD | sudo -S apt install --yes  libreoffice libreoffice-gtk3 libreoffice-style-elementary libreoffice-l10n-es libreoffice-help-es
                ;;
            ONLYOFFICE)
                echo $PASSWORD | sudo -S apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys CB2DE8E5
                sudo sh -c 'echo "deb https://download.onlyoffice.com/repo/debian squeeze main" >> /etc/apt/sources.list.d/onlyoffice.list'
                sudo apt-get update
                sudo apt install --yes onlyoffice-desktopeditors
                ;;
            FIREFOX)
                echo $PASSWORD | sudo -S apt install --yes software-properties-common
                sudo apt-add-repository -y ppa:mozillateam/ppa
                sudo apt-get update
                sudo apt install --yes firefox-locale-es firefox fonts-lyx
                #https://github.com/Zonnev/elementaryos-firefox-theme
                ;;
            VIVALDI)
                echo $PASSWORD | sudo -S cd .
                wget -qO- https://repo.vivaldi.com/archive/linux_signing_key.pub | sudo apt-key add -
                echo $PASSWORD | sudo -S add-apt-repository -y 'deb https://repo.vivaldi.com/archive/deb/ stable main'
                ;;
            ELEMENTARY_TWEAKS)
                echo $PASSWORD | sudo -S apt install --yes software-properties-common
                sudo add-apt-repository -y ppa:philip.scott/pantheon-tweaks
                sudo apt update
                sudo apt install --yes pantheon-tweaks
                ;;
            VLC)
                echo $PASSWORD | sudo -S apt install --yes vlc
                ;;
            ULAUNCHER)
                echo $PASSWORD | sudo -S apt install --yes software-properties-common
                sudo add-apt-repository -y ppa:agornostal/ulauncher
                sudo apt-get update
                sudo apt install --yes ulauncher
                ;;
            UGET)
                echo $PASSWORD | sudo -S apt install --yes software-properties-common
                sudo apt-add-repository -y ppa:plushuang-tw/uget-stable
                sudo apt-get update
                sudo apt-get install --yes uget aria2
                ;;
            YOUTDL)
                sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
                sudo chmod a+rx /usr/local/bin/youtube-dl
                ;;
            TORRENT)
                echo $PASSWORD | sudo -S apt install --yes transmission-gtk
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
	    	echo $PASSWORD | sudo -S apt install --yes curl
                wget https://telegram.org/dl/desktop/linux
                tar -xf linux
                mv ./Telegram ~/.Telegram
                curl -s "https://raw.githubusercontent.com/dsancheznet/linux-installers/master/telegramdesktop.desktop" | sed "s/~/\/home\/$USER/g" > ~/.local/share/applications/telegramdesktop.desktop
                rm ./linux
                ;;
            TEAMVIEWER)
                wget "https://download.teamviewer.com/download/linux/teamviewer_amd64.deb"
                echo $PASSWORD | sudo -S apt install --yes ./teamviewer*.deb
                rm teamviewer_amd64.deb
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
            MC)
                echo $PASSWORD | sudo -S apt install --yes  mc
                sudo rm /usr/share/applications/mc.desktop
                sudo rm /usr/share/applications/mcedit.desktop
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
            ELEM_SDK)
                echo $PASSWORD | sudo -S apt install --yes elementary-sdk
                ;;
            JOPLIN)
                wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash
                ;;
            DUFTM)
                wget "https://github.com/muesli/duf/releases/download/v0.6.2/duf_0.6.2_linux_amd64.deb"
                echo $PASSWORD | sudo -S apt install ./duf_0.6.2_linux_amd64.deb --yes
                rm ./duf_0.6.2_linux_amd64.deb
                ;;
            EXATM)
                mkdir ~/tmp
                cd ~/tmp
                wget "https://github.com/ogham/exa/releases/download/v0.10.0/exa-linux-x86_64-v0.10.0.zip"
                unzip exa-linux-x86_64-v0.10.0.zip
                echo $PASSWORD | sudo -S mv bin/exa /usr/local/bin
                echo $PASSWORD | sudo -S mv man/ /usr/share/man/man1
                echo $PASSWORD | sudo -S mv completions/exa.bash /etc/bash_completion.d
                cd ~
                rm -rf ~/tmp
                ;;
        esac
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



