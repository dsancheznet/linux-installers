#!/bin/bash

# Instalación ligera de Regolith Linux

## Instalar cosas de los repositorios:

### Herramientas
    sudo apt -y install software-properties-common mc git curl zsh cryptsetup pv rar unrar p7zip-full p7zip-rar make g++
### Música
    sudo apt -y install vlc cmus
### Editores
    sudo apt -y install ne gedit gedit-common gedit-plugins gedit-plugin-bookmarks gedit-latex-plugin gedit-plugin-bracket-completion gedit-plugin-code-comment gedit-plugin-draw-spaces gedit-plugin-git gedit-plugin-join-lines gedit-plugin-multi-edit gedit-plugin-text-size gedit-plugin-translate gedit-plugin-word-completion gedit-source-code-browser-plugin pandoc pandoc-sidenote
### Gráficos y video
    sudo apt -y install imagemagick imagemagick-doc ffmpeg ffmpeg-doc
### Programación
    sudo apt install -y python3-pip python-is-python3 mycli httpie
## Instalar repositorios
### onlyoffice
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys CB2DE8E5
    sudo sh -c 'echo "deb https://download.onlyoffice.com/repo/debian squeeze main" >> /etc/apt/sources.list.d/onlyoffice.list'
### liquorix
    sudo add-apt-repository ppa:damentz/liquorix
### Teamviewer
    wget https://download.teamviewer.com/download/linux/signature/TeamViewer2017.asc && sudo apt-key add ./TeamViewer2017.asc && rm ./TeamViewer2017.asc && sudo sh -c 'echo "deb http://linux.teamviewer.com/deb stable main" >> /etc/apt/sources.list.d/teamviewer.list'

## Actualizar:
    sudo apt update && sudo apt upgrade -y

## Instalar programas de terceros:
### Vivaldi
    wget https://downloads.vivaldi.com/stable/vivaldi-stable_3.8.2259.37-1_amd64.deb && sudo apt install ./vivaldi-stable_3.8.2259.37-1_amd64.deb -y && rm ./vivaldi-stable_3.8.2259.37-1_amd64.deb
### onlyoffice
    sudo apt install -y onlyoffice-desktopeditors
### OhMyZsh
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    sed -i 's/robbyrussell/agnoster/g' ~/.zshrc
### Liquorix Kernel
    sudo apt-get install linux-image-liquorix-amd64 linux-headers-liquorix-amd64
### Fuentes para la consola
    wget "https://github.com/be5invis/Iosevka/releases/download/v6.1.2/ttf-iosevka-6.1.2.zip"
    wget "https://github.com/be5invis/Iosevka/releases/download/v6.1.2/ttf-iosevka-term-6.1.2.zip"
    wget "https://github.com/be5invis/Iosevka/releases/download/v6.1.2/ttf-iosevka-fixed-6.1.2.zip"
    for I in *.zip; do unzip $I; rm $I; done;
    sudo mkdir -p /usr/share/fonts/truetype/iosevka/
    sudo mv *.ttf /usr/share/fonts/truetype/iosevka
    fc-cache -f -v
### Configurar Terminal
	GNOME_TERMINAL_PROFILE=`gsettings get org.gnome.Terminal.ProfilesList default | awk -F \' '{print $2}'`
	gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$GNOME_TERMINAL_PROFILE/ use-system-font false
	gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$GNOME_TERMINAL_PROFILE/ font 'Iosevka Term Regular 16'
    mc && sed -i 's/^skin=default$/skin=yadt256/g' .config/mc/ini
### youtube-dl
    sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
    sudo chmod a+rx /usr/local/bin/youtube-dl
### tiv
    mkdir ~/tmp
    cd ~/tmp/
    git clone https://github.com/stefanhaustein/TerminalImageViewer.git
    cd TerminalImageViewer/src/main/cpp
    make
    sudo sh -c "make install"
    cd ~
    rm -rf ~/tmp
## telegram
    cd ~
    wget https://telegram.org/dl/desktop/linux
    tar -xf linux
    mv ./Telegram ~/.Telegram
    curl -s "https://raw.githubusercontent.com/dsancheznet/linux-installers/master/telegramdesktop.desktop" | sed "s/~/\/home\/$USER/g" > ~/.local/share/applications/telegramdesktop.desktop
    rm ./linux
## onlyoffice
    sudo apt install -y onlyoffice-desktopeditors
## joplin
    wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash
## sunwait
    cd ~
    git clone https://github.com/risacher/sunwait.git
    cd sunwait
    make
    sudo mv ./sunwait /usr/local/bin
    cd ~
    rm -rf sunwait/
## duf
    wget "https://github.com/muesli/duf/releases/download/v0.6.2/duf_0.6.2_linux_amd64.deb" && sudo apt install -y ./duf_0.6.2_linux_amd64.deb && rm ./duf_0.6.2_linux_amd64.deb
## exa
    mkdir ~/tmp
    cd ~/tmp
    wget "https://github.com/ogham/exa/releases/download/v0.10.0/exa-linux-x86_64-v0.10.0.zip" && unzip exa-linux-x86_64-v0.10.0.zip
    sudo mv bin/exa /usr/local/bin && sudo mv man/ /usr/share/man/man1 && sudo mv completions/exa.zsh /usr/local/share/zsh/site-functions && sudo mv completions/exa.bash /etc/bash_completion.d
    cd ~ && rm -rf ~/tmp
## bpytop
    pip3 install bpytop --upgrade
## Wallpaper
    wget "https://wallpapercave.com/wp/wp8125890.jpg" -O Wallpaper.jpg
    sudo mv ./Wallpaper.jpg /usr/share/backgrounds/
    gsettings set org.gnome.desktop.background picture-uri file:////usr/share/backgrounds/Wallpaper.jpg
## Limpiar la instalación
    sudo apt autoremove -y

## Reiniciar
    sudo reboot
