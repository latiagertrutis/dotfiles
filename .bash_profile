#
# ~/.bash_profile
#
emacs --bg-daemon=emacs_w1
emacs --no-desktop --bg-daemon=emacs_w2

export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.config/rofi/bin:$PATH" # Path for rofi custom executables

[[ -f ~/.bashrc ]] && . ~/.bashrc

if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
  exec startx
fi
