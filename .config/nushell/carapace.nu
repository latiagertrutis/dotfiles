def carapace-print-columns [name, row] {    
       $row | get -o $name | default ""
}

def carapace-print-columns-with-color [name, row] {
    let color = (ansi ($row | get -o style | get -o fg | default green))
    
    $"($color)($row | get -o $name)(ansi reset)"
}

$env.PATH = ($env.PATH | split row (char esep) | where { $in != "/home/mateo/.config/carapace/bin" } | prepend "/home/mateo/.config/carapace/bin")

def --env get-env [name] { $env | get $name }
def --env set-env [name, value] { load-env { $name: $value } }
def --env unset-env [name] { hide-env $name }

let carapace_completer = {|spans|
  load-env {
  	CARAPACE_SHELL_BUILTINS: (help commands | where category != "" | get name | each { split row " " | first } | uniq  | str join "\n")
  	CARAPACE_SHELL_FUNCTIONS: (help commands | where category == "" | get name | each { split row " " | first } | uniq  | str join "\n")
  }

  # if the current command is an alias, get it's expansion
  let expanded_alias = (scope aliases | where name == $spans.0 | $in.0?.expansion?)

  # overwrite
  let spans = (if $expanded_alias != null  {
    # put the first word of the expanded alias first in the span
    $spans | skip 1 | prepend ($expanded_alias | split row " " | take 1)
  } else {
    $spans | skip 1 | prepend ($spans.0)
  })

  let carpace_format = { |row|
      (carapace-print-columns display $row | fill --alignment l --width 30) + (carapace-print-columns-with-color description $row | fill --alignment l --width 100)
  }

  carapace $spans.0 nushell ...$spans
  | from json
  | each $carpace_format
  | to text
  | fzf --ansi --delimiter " " --accept-nth 1 --nth 1 --height=~40% --border --reverse
  | lines
}

mut current = (($env | default {} config).config | default {} completions)
$current.completions = ($current.completions | default {} external)
$current.completions.external = ($current.completions.external
| default true enable
# backwards compatible workaround for default, see nushell #15654
| upsert completer { if $in == null { $carapace_completer } else { $in } })

$env.config = $current
