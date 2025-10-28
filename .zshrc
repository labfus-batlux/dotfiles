PROMPT="%F{green}%n%f · %F{cyan}%1~%f %# "

source /Users/charliesands/.config/broot/launcher/bash/br

function y() {
  local tmp="$(mktemp)"
  # Run yazi, store last directory into $tmp
  yazi --cwd-file="$tmp" "$@"
  if [ -s "$tmp" ]; then
    cd "$(cat "$tmp")" || return
  fi
  rm -f "$tmp"
}

source ~/.cargo/env
