#!/bin/bash
# Shared helpers for the B&W filter and Night Light warmth scripts.
#
# The retry loop in apply_temp mirrors the stock omarchy-toggle-nightlight: a
# freshly-started hyprsunset re-applies its own default temperature at the end
# of its boot, so a value set before that point must be resent until it sticks.

IDENTITY_TEMP=6000
OFF_TEMP=6500
WARMTH_FILE="$HOME/.local/state/omarchy/berni-nightlight-warmth"
SHADER_PATH="$HOME/.config/hypr/shaders/bw-filter.frag"

current_temp() {
  local output
  output=$(hyprctl hyprsunset temperature 2>/dev/null) || return
  grep -oE '[0-9]+' <<<"$output" | head -n1
}

is_nightlight_on() {
  local t
  t=$(current_temp)
  [[ -n $t ]] && (( t < IDENTITY_TEMP ))
}

ensure_hyprsunset() {
  local starting=false
  if ! pgrep -x hyprsunset >/dev/null; then
    setsid uwsm-app -- hyprsunset >/dev/null 2>&1 &
    starting=true
  elif (( $(ps -o etimes= -p "$(pgrep -nx hyprsunset)" 2>/dev/null || echo 0) < 3 )); then
    starting=true
  fi
  echo "$starting"
}

apply_temp() {
  local target="$1"
  local starting
  starting=$(ensure_hyprsunset)

  local i
  for ((i = 0; i < 10; i++)); do
    hyprctl hyprsunset temperature "$target" >/dev/null 2>&1
    if [[ $starting == "false" && $(current_temp) == "$target" ]]; then
      break
    fi
    sleep 0.2
    [[ $(current_temp) == "$target" ]] && break
  done

  if (( target == OFF_TEMP )); then
    hyprctl hyprsunset identity >/dev/null 2>&1
  fi
}

bw_filter_on() {
  [[ $(hyprctl -j getoption decoration:screen_shader | jq -r '.str') == "$SHADER_PATH" ]]
}

# This config is Lua-based (Omarchy 4's "non-legacy parser"), where plain
# `hyprctl keyword decoration:screen_shader ...` is refused ("keyword can't
# work with non-legacy parsers. Use eval."). hl.config{} -- the same helper
# the .lua config files call -- is reachable at runtime through `hyprctl eval`.
#
# hl.config() alone left the screen inconsistently redrawn -- some parts
# switched to/from grayscale and others didn't, and the change sometimes
# visibly flickered back and forth before settling. Following it with
# hl.dsp.force_renderer_reload() forces a full, consistent repaint.
set_bw_filter() {
  hyprctl eval "hl.config({decoration = {screen_shader = \"$SHADER_PATH\"}}); hl.dispatch(hl.dsp.force_renderer_reload())" >/dev/null 2>&1
}

clear_bw_filter() {
  hyprctl eval 'hl.config({decoration = {screen_shader = ""}}); hl.dispatch(hl.dsp.force_renderer_reload())' >/dev/null 2>&1
}

read_warmth() {
  local w
  w=$(cat "$WARMTH_FILE" 2>/dev/null)
  if [[ $w =~ ^[0-9]+$ ]]; then
    echo "$w"
  else
    echo 4000
  fi
}

write_warmth() {
  local t="$1"
  (( t < IDENTITY_TEMP )) && echo "$t" > "$WARMTH_FILE"
}

refresh_shell() {
  omarchy-shell -q nightlight refresh >/dev/null 2>&1
}
