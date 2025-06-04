#
# ~/.bash_profile
#

export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.config/rofi/bin:$PATH" # Path for rofi custom executables

[[ -f ~/.bashrc ]] && . ~/.bashrc

if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
  exec startx
fi
