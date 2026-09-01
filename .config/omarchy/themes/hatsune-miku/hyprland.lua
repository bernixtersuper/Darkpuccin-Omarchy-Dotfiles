-- Border colors only. The pre-4.0 theme also set animations, blur and
-- rounding; those are deliberately not carried over so the 4.0 bar/shell and
-- the square corners pinned in ~/.config/hypr/looknfeel.lua stay in charge.
local active = "rgba(39c5bbee)"
local inactive = "rgba(0d2020aa)"

hl.config({
  general = { col = { active_border = active, inactive_border = inactive } },
  group = { col = { border_active = active, border_inactive = inactive } },
})
