-- Personal input overrides, ported from the pre-4.0 hyprlang input.conf.
--
-- Only settings that actually DIFFER from Omarchy 4.0's defaults live here.
-- These already match the defaults and are deliberately not repeated:
--   kb_layout us, repeat_rate 40, numlock_by_default true,
--   touchpad scroll_factor 0.4, and the Alacritty/kitty/foot/ghostty
--   scroll_touchpad window rules.

hl.config({
  input = {
    -- Pointer speed. Omarchy defaults to 0.
    sensitivity = 0.5,

    -- Longer pause before a held key starts repeating. Omarchy defaults to 250.
    repeat_delay = 600,

    touchpad = {
      -- Natural (inverse) scrolling. Omarchy defaults to false.
      natural_scroll = true,

      -- Right-click from the lower-right corner rather than a two-finger click.
      -- Omarchy 4.0 turns clickfinger on by default; the old config kept this
      -- line commented out on purpose, so it stays off here. Delete this line
      -- to adopt the newer two-finger behavior.
      clickfinger_behavior = false,
    },
  },
})

-- Three-finger horizontal swipe switches workspaces. Omarchy ships no gestures
-- of its own, so this has to be declared explicitly.
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- Wacom Intuos PT S (152x95mm active area, 16:10) follows the MSI when it is
-- plugged in and falls back to the laptop panel when it is not.
--
-- region_position is relative to the bound output rather than the global
-- layout, because absolute_region_position defaults to false.
local TABLET = "wacom-intuos-pt-s-2-pen"

local function map_tablet()
  if hl.get_monitor("HDMI-A-1") then
    -- MSI MAG 275QF is 2560x1440 (16:9), so map only the bottom-left 1920x1200
    -- of it. That region is 16:10 like the tablet, which keeps circles round;
    -- using the whole panel would squash the vertical axis by ~10%.
    hl.device({
      name = TABLET,
      output = "HDMI-A-1",
      region_position = { 0, 240 },
      region_size = { 1920, 1200 },
    })
  else
    -- eDP-1 is 2880x1800, natively 16:10 and therefore the same aspect as the
    -- tablet, so the whole panel maps 1:1 with no region needed. region_size
    -- {0,0} is the "no region" default and clears whatever the HDMI-A-1 branch
    -- set previously -- without it the old 1920x1200 region would linger.
    hl.device({
      name = TABLET,
      output = "eDP-1",
      region_position = { 0, 0 },
      region_size = { 0, 0 },
    })
  end
end

map_tablet()

-- Re-evaluate whenever a display comes or goes, so unplugging the MSI hands the
-- tablet to the laptop screen and plugging it back in returns it.
hl.on("monitor.added", map_tablet)
hl.on("monitor.removed", map_tablet)
