ROOT="."

all: install

import:
	cp ~/.alacritty.toml $(ROOT)
	cp ~/.bashrc $(ROOT)
	cp -rf ~/.config/{picom.conf,rofi} $(ROOT)/.config/
	cp -rf ~/.dwm $(ROOT)
	cp -rf ~/.dwm-bar $(ROOT)
	cp -rf ~/.wallpaper $(ROOT)
	cp ~/.tmux.conf $(ROOT)
	cat ~/.profile ~/.bash_profile ~/.bash_login ~/.xinitrc 2>/dev/null 1>.profile || true

install:
	@echo HELLO

.PHONY: all import install
