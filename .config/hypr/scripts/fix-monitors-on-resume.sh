#!/bin/bash
SCRIPT_DIR="$HOME/.config/hypr/scripts"
hyprctl monitors -j | jq -r '.[] | "\(.name) \(.transform)"' | while read -r name transform; do
    "$SCRIPT_DIR/set-monitor-transform.sh" "$name" "$transform"
done
