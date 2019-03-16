#! /bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run via sudo"
  exit
fi

dotfiles=
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
		tilix                           \
		chromium-browser                \
		software-properties-common      \
		apt-transport-https             \
		cmake cmake-data libcairo2-dev libxcb1-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-image0-dev libxcb-randr0-dev libxcb-util0-dev libxcb-xkb-dev pkg-config python-xcbgen xcb-proto libxcb-xrm-dev i3-wm libasound2-dev libmpdclient-dev libiw-dev libcurl4-openssl-dev libpulse-dev libxcb-composite0-dev xcb libxcb-ewmh2 # these are for polybar
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
git clone https://github.com/jaagr/polybar.git -o ~
cd ~/polybar && ./build.sh

#install fonts for polybar
git clone https://github.com/stark/siji && ./siji/install.sh
sudo dpkg-reconfigure fontconfig-config
sudo rm /etc/fonts/conf.d/70-no-bitmaps.conf && fc-cache


