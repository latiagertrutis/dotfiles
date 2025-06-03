ROOT="."

all: install

APPS =	librewolf-bin \
	rofi \
	blesh-git \
	tmux \
	feh \
	alacritty \
	nemo \
	unzip \
	lxappearance \
	docker \
	evolution \
	xorg-xsetroot \
	transmission-gtk

import:
	cp ~/.alacritty.toml $(ROOT)
	cp -rf ~/.config/{picom.conf,rofi} $(ROOT)/.config/
	cp -rf ~/.dwm $(ROOT)
	cp -rf ~/.dwm-bar $(ROOT)
	cp -rf ~/.wallpaper $(ROOT)
	cp ~/.tmux.conf $(ROOT)
	cp ~/.bash_profile $(ROOT)
	cp ~/.xinitrc $(ROOT)
	cp ~/.bashrc $(ROOT)


deploy:
	cp -f $(ROOT)/.alacritty.toml $(HOME)
	cp -f $(ROOT)/.bashrc $(HOME)
	cp -rf $(ROOT)/.config/{picom.conf,rofi} $(HOME)/.config/
	cp -rf $(ROOT)/.dwm $(HOME)
	cp -rf $(ROOT)/.dwm-bar $(HOME)
	cp -rf $(ROOT)/.wallpaper $(HOME)
	cp -f $(ROOT)/.tmux.conf $(HOME)
	cp -f $(ROOT)/arch/{.bash_profile,.xinitrc} ${HOME}

install-apps:
	sudo pacman -S --needed git base-devel
	git clone https://aur.archlinux.org/yay.git
	cd yay && makepkg -si
	yay -Syu $(APPS)

install:
	@echo HELLO

.PHONY: all import install
