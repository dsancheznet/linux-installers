<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/3/35/Tux.svg/649px-Tux.svg.png" width="150px">

# Linux Installers

These are several Linux post install scripts I have prepared over the years. Lately I have been required to do a lot of Linux installations for me and others so I have dug up many scripts, updated a few and added a few others.

---

## Available Installers (uploads still in progress)

1. **Manjaro XFCE BigSur**

  Customize Manjaro XFCE for the look and feel of Big Sur (in progress)

<img src="img/XFCE1.png" width="500px">

```
XFCESur.sh
```

> XFCE is a lightning fast window manager which on top of Manjaro, one of the most acclaimed Distros in terms of speed and completeness, leads to impressive Desktop performance, furthermore this script allows MacOSX switchers to feel at home right from the beginning.

2. Elementary Hera 5.1

  Customize Hera with the most important software to have a top-notch Office desktop

  <img src="img/Elementary.png" width="500px">

```
elementary.sh
```

> Why choose Elementary for this task? This is because Elementary is based on Ubuntu and thus hast the possibility to enable many popular PPAs (not neccesary curated but functional) to enhance the desktop experience, specially for Linux newbies.


3. Regolith

  Customize Regolith to have an excellent distraction free programming tile window manager

  <img src="img/Regolith.png" width="500px">

> Regolith is a neat little distro, perfect for power users and programmers who want a distraction free desktop with the power of Ubuntu under the hut. This distro is meant for pros and not for the beginner.

```
install_Regolith.sh
```
It installs and compiles the following software:
* Liquorix Kernel for a slight speed and stability gain
* cryptsetup to be able to compress volumes with luks
* Compression utilities of all kinds
* cmus as a command line music player and vlc as a hybrid music and video player
* youtube-dl 
* Python3
* ne and mc cli editors. They are small and they are fast. For everything not covered by them, gedit is also installed (with all available plugins).
* OnlyOffice as the main Office Suite. (I feel this being a little lighter and visually more polished than LibreOffice which I also like a lot)
* TeamViewer
* Vivaldi. After the installation, Vivaldi is installed **along** with Firefox. Just remove the one you like the least.
* zsh as a shell with OhMyZsh! extension as the main shell. (In the middle of the installtion, the script launches zsh, just press CTRL+D to continue with installtion)
* Iosevka Font as a default for terminal and a system wide installation
* tiv, a terminal image viewer to view files quickly from cli
* Terminal Desktop app
* Joplin notes application
* duf as a df replacement
* exa as a ls replacement
* bpytop as a htop replacement

You can open this script with a markdown viewer to see what it does. 

---

All files do consider fresh installs of the respective distros before starting an install script. Constributions are welcome.

Have fun.
