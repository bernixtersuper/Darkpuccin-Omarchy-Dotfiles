#!/bin/bash
# SUPER+CTRL+N target, and what the gauge panel's left-click/toggle runs too.
# Snaps between off and the last warmth set via the gauge slider (instead of
# a hardcoded temperature). Can run alongside the B&W filter -- no exclusion
# between the two.

source "$HOME/.config/hypr/scripts/nightlight-common.sh"

if is_nightlight_on; then
  apply_temp "$OFF_TEMP"
else
  apply_temp "$(read_warmth)"
fi

refresh_shell
