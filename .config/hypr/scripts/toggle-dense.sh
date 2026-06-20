#!/bin/bash
DENSE_FILE="$HOME/.local/state/omarchy/toggles/hypr/window-dense.conf"
NO_GAPS_FILE="$HOME/.local/state/omarchy/toggles/hypr/window-no-gaps.conf"

if [ -f "$DENSE_FILE" ]; then
    rm "$DENSE_FILE"
else
    rm -f "$NO_GAPS_FILE"
    cat > "$DENSE_FILE" << 'CONF'
general {
    gaps_out = 0
    gaps_in = 0
}

decoration {
    shadow {
        enabled = false
    }
}

workspace = w[1], bordersize:0, gapsin:0, gapsout:0
workspace = w[2-], bordersize:0, gapsin:0, gapsout:0
CONF
fi

hyprctl reload
