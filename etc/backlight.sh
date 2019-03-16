#! /bin/bash

read -r -p "Are you sure? [y/N] " response
if ! [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
    exit 0
fi

sudo touch /etc/X11/xorg.conf
sudo echo "Section \"Device\"
    Identifier \"Card0\"
    Driver \"intel\"
    Option \"Backlight\" \"intel_backlight\"
EndSection" > /etc/X11/xorg.conf
