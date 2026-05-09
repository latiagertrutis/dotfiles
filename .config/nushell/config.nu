# config.nu
#
# Installed by:
# version = "0.105.1"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# This file is loaded after env.nu and before login.nu
#
# You can open this file in your default editor using:
# config nu
#
# See `help config nu` for more options
#
# You can remove these comments if you want or leave
# them for future reference.

alias l = ls -a

$env.config = {
  keybindings: [
    {
      name: fuzzy_history
      modifier: control
      keycode: char_r
      mode: [emacs, vi_normal, vi_insert]
      event: [
        {
          send: ExecuteHostCommand
          cmd: "let result = (
            history
            | get command
            | uniq
            | reverse
            | str join (char -i 0)
            | fzf --scheme=history
              --read0
	      --border
              --height=~40%
              --bind=ctrl-r:toggle-sort
              --highlight-line
              --query=(commandline | str substring 0..(commandline get-cursor))
              +m
            | complete
          ); if ($result.exit_code == 0) { commandline edit ($result.stdout | str trim) }"
        }
      ]
    }
    {
      name: fuzzy_file_dir_completion
      modifier: control
      keycode: char_t
      mode: [emacs, vi_normal, vi_insert]
      event: [
        {
          send: ExecuteHostCommand
          cmd: "let last_elem = (commandline | split row  ' ' | last);
	  let base_path = (if '/' in $last_elem {($last_elem | path expand --strict)} else {'.'});
	  let result = (
            fzf --scheme=path
              --read0
	      --border
              --height=~40%
              --reverse
              --walker=file,dir,follow,hidden
	      --walker-root=($base_path)
              -m
            | complete
          );
	  if ($result.exit_code == 0) {
	     commandline edit (commandline
				| split row ' '
				| drop
				| append ($last_elem + ($result.stdout
							| str trim
							| path relative-to $base_path))
				| str join ' ')
	  }"
        }
      ]
    }
    {
      name: fuzzy_cd
      modifier: control
      keycode: char_z
      mode: [emacs, vi_normal, vi_insert]
      event: [
        {
          send: ExecuteHostCommand
          cmd: "zi"
        }
      ]
    }
  ]
}

source $"($nu.default-config-dir)/carapace.nu"
source $"($nu.default-config-dir)/zoxide.nu"
