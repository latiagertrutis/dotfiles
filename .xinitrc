#!/bin/bash

##################################################################################################################################
# This is needed on non-desktop environments to start dbus:									 #
# https://wiki.archlinux.org/title/GNOME/Keyring#Using_gnome-keyring-daemon_outside_desktop_environments_(KDE,_GNOME,_XFCE,_...) #
##################################################################################################################################

dbus-update-activation-environment --all

gnome-keyring-daemon --start --components=secrets

##################################################################################################################################

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/.cargo/bin" ] ; then
    PATH="$HOME/.cargo/bin:$PATH"
fi

~/.dwm-bar/dwm_bar.sh &

setxkbmap -option caps:ctrl_modifier

feh --bg-scale --randomize ~/.wallpaper/*

picom -b &

/usr/bin/emacs --bg-daemon=emacs_w1
/usr/bin/emacs --no-desktop --bg-daemon=emacs_w2

export GTK_THEME=Nordic-darker

exec dwm
