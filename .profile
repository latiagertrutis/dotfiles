# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

##################################################################################################################################
# This is needed on non-desktop environments to start dbus:									 #
# https://wiki.archlinux.org/title/GNOME/Keyring#Using_gnome-keyring-daemon_outside_desktop_environments_(KDE,_GNOME,_XFCE,_...) #
##################################################################################################################################

# dbus-update-activation-environment --all

# gnome-keyring-daemon --start --components=secrets

##################################################################################################################################

# NOTE: To customize the gtk theme use lxappearance

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

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

export GTK_THEME=Nordic-darker

picom -b &
