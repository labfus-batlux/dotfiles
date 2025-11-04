PROMPT="%F{green}%n%f · %F{cyan}%1~%f %# "

function y() {
  local tmp="$(mktemp)"
  # Run yazi, store last directory into $tmp
  yazi --cwd-file="$tmp" "$@"
  if [ -s "$tmp" ]; then
    cd "$(cat "$tmp")" || return
  fi
  rm -f "$tmp"
}

function lx() {
  local count=${1:-10}
  ls -t | head -n $count
}

for i in {1..50}; do
  eval "alias lx${i}='lx ${i}'"
done


