#!/usr/bin/env bash

# Toggle: kill if already running
if pgrep -x "wlogout" > /dev/null; then
    pkill -x "wlogout"
    exit 0
fi

# Fixed values tuned for 1366x768 — no dynamic scaling needed
wlogout \
    -C $HOME/.config/wlogout/style.css \
    -l $HOME/.config/wlogout/layout \
    --protocol layer-shell \
    -b 5 \
    -T 200 \
    -B 200 &