#!/usr/bin/env bash
set -euo pipefail

A_1080=400
B_1080=400

# Check if wlogout is already running and close it instead of opening a duplicate
if pgrep -x "wlogout" >/dev/null 2>&1; then
    pkill -x "wlogout" >/dev/null 2>&1 || true
    exit 0
fi

monitor_json=$(hyprctl -j monitors)
resolution=$(jq -r '.[] | select(.focused==true) | (.height / .scale) | floor' <<< "$monitor_json")
hypr_scale=$(jq -r '.[] | select(.focused==true) | .scale' <<< "$monitor_json")

if [[ -z "$resolution" || "$resolution" == "null" || "$resolution" == "0" ]]; then
    resolution=1080
fi
if [[ -z "$hypr_scale" || "$hypr_scale" == "null" ]]; then
    hypr_scale=1
fi

top=$(awk "BEGIN {printf \"%.0f\", $A_1080 * 1080 * $hypr_scale / $resolution}")
bottom=$(awk "BEGIN {printf \"%.0f\", $B_1080 * 1080 * $hypr_scale / $resolution}")

wlogout -C "$HOME/.config/wlogout/nova.css" -l "$HOME/.config/wlogout/layout" \
    --protocol layer-shell -b 5 -T "$top" -B "$bottom" &
