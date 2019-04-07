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
		nitrogen                        \
		chromium-browser                \
		compton                         \
		upower                          \
		scrot                           \
		golang-go                       \
		software-properties-common      \
		apt-transport-https             \
		python-dev python-pip           \
		python3-dev python3-pip         \
		build-essential git cmake cmake-data pkg-config libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev i3-wm libjsoncpp-dev libmpdclient-dev libcurl4-openssl-dev libnl-genl-3-dev \
		bingawk wget git-core diffstat unzip texinfo gcc-multilib build-essential chrpath socat libsdl1.2-dev xterm \
		libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev autoconf xutils-dev libtool automake libxcb-xrm-dev\
         "
# # #
# 16.04 doesn't have libxcb-xrm-dev, use this script:
# # #
# mkdir tmp
# cd /tmp
# git clone https://github.com/Airblader/xcb-util-xrm
# cd xcb-util-xrm
# git submodule update --init
# ./autogen.sh --prefix=/usr
# make
# sudo make install
# # #

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

# install corrupter
cd ~ && git clone git@github.com:r00tman/corrupter.git
cd ~/corrupter && go build
sudo touch /usr/local/bin/corrupter
sudo ln -s ~/corrupter/corrupter /usr/local/bin/corrupter

# install polybar
cd ~ && git clone https://github.com/jaagr/polybar.git
cd ~/polybar && ./build.sh
cd ~/polybar/build && make userconfig

# install fonts for polybar
cd ~ && git clone https://github.com/stark/siji && ./siji/install.sh
sudo dpkg-reconfigure fontconfig-config
sudo rm /etc/fonts/conf.d/70-no-bitmaps.conf && fc-cache

# install i3gaps
cd /tmp
git clone https://www.github.com/Airblader/i3 i3-gaps
cd i3-gaps
git checkout gaps && git pull
autoreconf --force --install
rm -rf build
mkdir build
cd build
../configure --prefix=/usr --sysconfdir=/etc
make
sudo make install


