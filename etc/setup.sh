#! /bin/bash

read -r -p "Are you sure? [y/N] " response
if ! [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
    exit 0
fi

if [ "$EUID" -ne 0 ]
  then echo "Please run via sudo"
  exit
fi

WP_URL=
LOCK_URL=

packages="
		xserver-xorg-input-synaptics    \
		tmux                            \
		screen                          \
		xbacklight                      \
		i3                              \
		feh                             \
		meld                            \
		git                             \
		curl                            \
		zsh                             \
		vim                             \
		shotwell                        \
		tilix                           \
		chromium-browser                \
		upower                           \
		software-properties-common      \
		apt-transport-https             \
		build-essential git cmake cmake-data pkg-config libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev i3-wm libjsoncpp-dev libmpdclient-dev libcurl4-openssl-dev libnl-genl-3-dev \
		bingawk wget git-core diffstat unzip texinfo gcc-multilib build-essential chrpath socat libsdl1.2-dev xterm \
         "

sudo apt-get update

for package in $packages
do
sudo apt install -y $package
done

if ! [ -z $WP_URL ]
  then wget $WP_URL -O ~/Downloads/wp.jpg
fi

if ! [ -z $LOCK_URL ]
  then wget $LOCK_URL -O ~/Downloads/ls.jpg
fi

# Slack
sudo snap install slack --classic

# CODE
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt install code
sudo apt install code-insiders

# disable BT
sudo systemctl disable bluetooth.service

# install polybar
cd ~ && git clone https://github.com/jaagr/polybar.git
cd ~/polybar && ./build.sh
cd ~/polybar/build && make userconfig

#install fonts for polybar
cd ~ && git clone https://github.com/stark/siji && ./siji/install.sh
sudo dpkg-reconfigure fontconfig-config
sudo rm /etc/fonts/conf.d/70-no-bitmaps.conf && fc-cache


