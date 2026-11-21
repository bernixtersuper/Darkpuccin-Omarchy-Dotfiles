#!/bin/bash
# Pre-binds the B&W shader once at login, then clears it, so if Hyprland
# caches the compiled shader by file path, the first real SUPER+CTRL+M toggle
# during the session doesn't pay that cost while actually watching the
# screen. Experimental: unclear whether Hyprland caches this way at all.

source "$HOME/.config/hypr/scripts/nightlight-common.sh"

sleep 1
set_bw_filter
sleep 0.3
clear_bw_filter
