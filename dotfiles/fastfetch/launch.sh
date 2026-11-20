#!/usr/bin/env bash
# Cycle through the ASCII arts in themes/ascii/ — one different art per launch.
# No images, no theme selection, no state beyond the current filename.
CONFIG_DIR="$HOME/.config/fastfetch"
ASCII_DIR="$CONFIG_DIR/themes/ascii"
STATE_FILE="$CONFIG_DIR/.ascii_current"

mapfile -t arts < <(find "$ASCII_DIR" -maxdepth 1 -name '*.txt' -exec basename {} \; 2>/dev/null | sort -V)

if [ ${#arts[@]} -eq 0 ]; then
  echo "No ASCII art found in $ASCII_DIR" >&2
  exit 1
fi

last=""
[ -f "$STATE_FILE" ] && last=$(cat "$STATE_FILE")

next="${arts[0]}"
if [ -n "$last" ]; then
  for i in "${!arts[@]}"; do
    if [ "${arts[$i]}" = "$last" ]; then
      next="${arts[$(( (i + 1) % ${#arts[@]} ))]}"
      break
    fi
  done
fi

printf '%s\n' "$next" > "$STATE_FILE"

exec fastfetch --logo "$ASCII_DIR/$next" --logo-type file "$@"
