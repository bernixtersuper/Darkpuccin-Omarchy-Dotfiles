#!/bin/bash
# SUPER+CTRL+M target, and what the gauge panel's B&W toggle row runs too.
# Toggles the whole-screen grayscale shader. Can run alongside Night Light --
# no exclusion between the two.

source "$HOME/.config/hypr/scripts/nightlight-common.sh"

if bw_filter_on; then
  clear_bw_filter
else
  set_bw_filter
fi

refresh_shell
