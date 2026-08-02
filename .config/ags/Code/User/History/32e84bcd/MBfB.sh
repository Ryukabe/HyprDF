#!/usr/bin/env bash

ROFI_TITLE="clipboard-menu"

cliphist list | rofi -dmenu -p "Clipboard" \
  -window-title "$ROFI_TITLE" \
  -theme "$HOME/.config/rofi/style-1.rasi" \
  | cliphist decode | wl-copy &
ROFI_PID=$!

while kill -0 "$ROFI_PID" 2>/dev/null; do
  sleep 0.1
  ACTIVE_TITLE=$(hyprctl activewindow | grep -o 'title:.*' | sed 's/title: //')
  if [[ "$ACTIVE_TITLE" != *"$ROFI_TITLE"* ]]; then
    kill "$ROFI_PID" 2>/dev/null
    break
  fi
done

wait "$ROFI_PID"