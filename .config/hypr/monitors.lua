-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all
--
-- Layout (logical pixels, after scale/transform):
--
--        x=0      1080            1280        3440  3640
--   y=0  +--------+---------------------------------+
--        |        |                                 |
--   256  |        |   HDMI-A-1  2560x1440           |
--        | DP-3   |   (1080,256) -> (3640,1696)     |
--        | 1080   |                                 |
--        | x1920  +--------------+------------------+
--  1696  |        |              |  eDP-1 2160x1350 |
--        |        |              |  (1280,1696) ->  |
--  1920  +--------+              |  (3440,3046)     |
--                                +------------------+

local omarchy_gdk_scale = 2
local omarchy_monitor_scale = 1.6

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))

-- Fallback for any monitor without an explicit rule below.
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })

-- DP-3: LG FHD, portrait (transform 1 = 90 deg CCW), leftmost screen.
hl.monitor({ output = "DP-3", mode = "1920x1080@100", position = "0x0", scale = 1, transform = 1 })

-- HDMI-A-1: MSI MAG 275QF (1440p), right of DP-3 and above the laptop panel.
-- hl.monitor({ output = "HDMI-A-1", mode = "2560x1440@120", position = "1080x256", scale = 1 })

-- eDP-1: laptop panel, below HDMI-A-1. Scale 4/3 -> 2160x1350 logical px.
hl.monitor({ output = "eDP-1", mode = "2880x1800@120", position = "1280x1696", scale = 1.333333 })
