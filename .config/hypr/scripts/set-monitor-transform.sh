#!/bin/bash
MONITOR="$1"
TRANSFORM="$2"

INFO=$(hyprctl monitors -j | jq -r ".[] | select(.name == \"$MONITOR\")")
PX=$(echo "$INFO" | jq -r '.x')
PY=$(echo "$INFO" | jq -r '.y')
SCALE=$(echo "$INFO" | jq -r '.scale')
REFRESH=$(echo "$INFO" | jq -r '.refreshRate | round')

case "$MONITOR" in
    eDP-1) NATIVE="2880x1800" ;;
    DP-3)  NATIVE="1920x1080" ;;
    *)
        W=$(echo "$INFO" | jq -r '.width')
        H=$(echo "$INFO" | jq -r '.height')
        NATIVE="${W}x${H}"
        ;;
esac

if [ "$TRANSFORM" = "0" ]; then
    hyprctl keyword monitor "$MONITOR,${NATIVE}@${REFRESH},${PX}x${PY},${SCALE}"
else
    hyprctl keyword monitor "$MONITOR,${NATIVE}@${REFRESH},${PX}x${PY},${SCALE},transform,${TRANSFORM}"
fi
