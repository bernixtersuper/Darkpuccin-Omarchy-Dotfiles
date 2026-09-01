-- Personal look'n'feel overrides, ported from the pre-4.0 hyprlang looknfeel.conf.
--
-- Only settings that actually DIFFER from Omarchy 4.0's defaults live here.
-- These already match the defaults and are deliberately not repeated:
--   border_size 2, decoration.shadow.enabled false, and layout "dwindle".

-- https://wiki.hypr.land/Configuring/Basics/Variables/#general
hl.config({
  general = {
    -- No gaps at all -- windows sit flush against each other and the screen
    -- edge, so only the 2px border separates them.
    gaps_in = 0,
    gaps_out = 0,
  },

  decoration = {
    -- Square corners. Omarchy's own default is already 0, but THEMES override
    -- it -- Solitude sets rounding 6, for example -- and the theme is loaded
    -- by require("default.hypr.omarchy") before this file. Pinning it here
    -- keeps corners square across every theme instead of only the ones that
    -- happen not to round.
    --
    -- The Omarchy shell mirrors this value into Style.cornerRadius (it reads
    -- decoration:rounding via hyprctl), so this squares the bar widgets too.
    rounding = 0,
  },
})

-- Custom animations. Omarchy's defaults use popin/easeOutQuint for windows;
-- this swaps in GNOME-style window scaling and re-enables sliding for layers.
--
-- Omarchy disables the workspace animation by default; this re-enables the
-- slide the old hyprlang config had.
--
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.animation({ leaf = "workspaces", enabled = true, speed = 2, bezier = "default", style = "slide" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 2, bezier = "default", style = "gnomed" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 2, bezier = "default", style = "gnomed" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 2, bezier = "default" })
hl.animation({ leaf = "layers", enabled = true, speed = 2, bezier = "default", style = "slide" })

-- Kept from the old config as commented-out reference:
--
-- Per-app transparency:
-- o.window("firefox", { opacity = "0.97 0.9" })
-- o.window("com.github.th_ch.youtube_music", { opacity = "0.97 0.65" })
--
-- Avoid overly wide single-window layouts on wide screens:
-- hl.config({ layout = { single_window_aspect_ratio = { 1, 1 } } })
