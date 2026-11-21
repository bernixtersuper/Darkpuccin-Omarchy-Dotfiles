#!/bin/bash
# Called by the gauge panel's slider on release, with the target Kelvin value
# as $1: applies it live and persists it as the new "last warmth" for
# SUPER+CTRL+N. Can run alongside the B&W filter -- no exclusion between the
# two.

source "$HOME/.config/hypr/scripts/nightlight-common.sh"

TARGET="${1:-4000}"
[[ $TARGET =~ ^[0-9]+$ ]] || exit 1

apply_temp "$TARGET"
write_warmth "$TARGET"
refresh_shell
