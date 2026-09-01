-- Personal keybinding overrides, ported from the pre-4.0 hyprlang bindings.conf.
--
-- See current bindings and descriptions:
--   omarchy menu keybindings --print
--
-- Bindings that Omarchy 4.0 already ships identically are NOT repeated here:
--   SUPER+RETURN terminal, SUPER+ALT+RETURN tmux, SUPER+SHIFT+RETURN browser,
--   SUPER+SHIFT+N editor, SUPER+SHIFT+O obsidian, SUPER+SHIFT+SLASH passwords,
--   SUPER+SHIFT+ALT+B private browser, SUPER+SHIFT+A ChatGPT,
--   SUPER+SHIFT+ALT+A Grok, SUPER+SHIFT+CTRL+G Google Messages,
--   SUPER+SHIFT+ALT+X X post, SUPER+CTRL+W network panel.

-- ---------------------------------------------------------------------------
-- Vim-style focus and window movement
-- ---------------------------------------------------------------------------

-- SUPER+J (toggle split), SUPER+K (keybindings) and SUPER+L (workspace layout)
-- are Omarchy defaults, so they have to be released before HJKL can take over.
hl.unbind("SUPER + J")
hl.unbind("SUPER + K")
hl.unbind("SUPER + L")

o.bind("SUPER + H", "Focus left", hl.dsp.focus({ direction = "l" }))
o.bind("SUPER + J", "Focus down", hl.dsp.focus({ direction = "d" }))
o.bind("SUPER + K", "Focus up", hl.dsp.focus({ direction = "u" }))
o.bind("SUPER + L", "Focus right", hl.dsp.focus({ direction = "r" }))

o.bind("SUPER + SHIFT + H", "Move left", hl.dsp.window.move({ direction = "l" }))
o.bind("SUPER + SHIFT + J", "Move down", hl.dsp.window.move({ direction = "d" }))
o.bind("SUPER + SHIFT + K", "Move up", hl.dsp.window.move({ direction = "u" }))
o.bind("SUPER + SHIFT + L", "Move right", hl.dsp.window.move({ direction = "r" }))

-- Homes for what HJKL displaced.
hl.unbind("SUPER + CTRL + K") -- was: Herdr keybindings
o.bind("SUPER + CTRL + K", "Show key bindings", "omarchy-menu-keybindings")
o.bind("SUPER + CTRL + J", "Toggle window split", hl.dsp.layout("togglesplit"))
o.bind("SUPER + ALT + L", "Toggle workspace layout", "omarchy-hyprland-workspace-layout-toggle")

-- ---------------------------------------------------------------------------
-- Workspaces, GlazeWM style
-- ---------------------------------------------------------------------------

hl.unbind("SUPER + S") -- was: Toggle scratchpad
hl.unbind("SUPER + ALT + S") -- was: Move window to scratchpad (dropped on purpose)
hl.unbind("SUPER + SHIFT + S") -- was: Google Maps
hl.unbind("SUPER + SHIFT + A") -- was: ChatGPT

o.bind("SUPER + S", "Next workspace", hl.dsp.focus({ workspace = "r+1" }))
o.bind("SUPER + A", "Previous workspace", hl.dsp.focus({ workspace = "r-1" }))
o.bind("SUPER + SHIFT + S", "Move window to next workspace", hl.dsp.window.move({ workspace = "r+1" }))
o.bind("SUPER + SHIFT + A", "Move window to previous workspace", hl.dsp.window.move({ workspace = "r-1" }))

-- ---------------------------------------------------------------------------
-- Window management
-- ---------------------------------------------------------------------------

hl.unbind("SUPER + ALT + F") -- was: Full width
o.bind("SUPER + D", "Full width", hl.dsp.window.fullscreen({ mode = "maximized" }))

-- Native dispatcher; the old config shelled out to a nonexistent
-- `forcekillactive` binary, so this binding never actually worked.
-- o.bind("SUPER + Q", "Force kill active", hl.dsp.window.kill())

-- ---------------------------------------------------------------------------
-- Applications
-- ---------------------------------------------------------------------------

hl.unbind("SUPER + SHIFT + E") -- was: Email webapp
o.bind("SUPER + SHIFT + E", "File manager", { tui = "yazi" })

o.bind("SUPER + SHIFT + T", "Activity", { tui = "btop" })

hl.unbind("SUPER + SHIFT + D") -- was: Docker (lazydocker, now on SUPER+CTRL+D)
hl.unbind("SUPER + CTRL + D") -- was: Display panel
o.bind("SUPER + CTRL + D", "Docker", { tui = "lazydocker" })

hl.unbind("SUPER + SHIFT + P") -- was: Google Photos
o.bind("SUPER + SHIFT + P", "Perplexity", { launch = "firefox --new-window https://www.perplexity.ai/" })

hl.unbind("SUPER + SHIFT + X") -- was: X webapp
o.bind("SUPER + SHIFT + X", "Tuxedo", { tui = "tuxedo" })

hl.unbind("SUPER + SHIFT + M") -- was: Music (Spotify)
o.bind("SUPER + SHIFT + M", "Music", { tui = "cliamp", focus = true })

-- Herdr, like cliamp: launch it if it isn't running, otherwise just focus the
-- existing window (which pulls us over to its 🐑 workspace, see workspaces.lua).
o.bind("SUPER + ALT + H", "Herdr", { tui = "herdr", focus = true })

-- The 🐑 workspace has no number, so SUPER+SHIFT+<digit> can't reach it. This is
-- its stand-in: same modifiers as the launch bind, plus SHIFT, like the stock
-- switch/move pairs.
o.bind("SUPER + SHIFT + ALT + H", "Move window to 🐑", hl.dsp.window.move({ workspace = "name:🐑" }))

hl.unbind("SUPER + SHIFT + C") -- was: Calendar webapp
o.bind("SUPER + SHIFT + C", "Chromium", { launch = "chromium" })

-- ---------------------------------------------------------------------------
-- Hardware panels and notifications
-- ---------------------------------------------------------------------------

-- Bluetooth moves off SUPER+CTRL+B so that key can report the battery.
o.bind("SUPER + B", "Bluetooth", "omarchy-shell shell toggle omarchy.bluetooth")

-- Battery/power panel. Omarchy also keeps it on its stock SUPER+CTRL+P, which
-- is left alone -- both keys open the same panel.
hl.unbind("SUPER + CTRL + B") -- was: Bluetooth panel (now on SUPER+B)
o.bind("SUPER + CTRL + B", "Battery", "omarchy-shell shell toggle omarchy.power")

hl.unbind("SUPER + CTRL + T") -- was: Activity (btop, now on SUPER+SHIFT+T)
o.bind("SUPER + CTRL + T", "Show time", "omarchy-notification-time")

-- ---------------------------------------------------------------------------
-- Utilities
-- ---------------------------------------------------------------------------

o.bind("SUPER + ALT + V", "Fix clipboard newlines", [[wl-paste | perl -0pe 's/(?<!\n)\n(?!\n)/ /g' | wl-copy]])

-- SUPER+CTRL+M used to run ~/.config/hypr/scripts/toggle-edge-scroll.sh, which
-- is missing from the dotfiles repo. Restore the script, then uncomment.
-- o.bind("SUPER + CTRL + M", "Toggle edge scrolling", os.getenv("HOME") .. "/.config/hypr/scripts/toggle-edge-scroll.sh")

-- ---------------------------------------------------------------------------
-- Screen rotation
-- ---------------------------------------------------------------------------

-- Re-apply a monitor's transform while preserving its position and scale, which
-- a bare `hyprctl keyword monitor` would reset. Lua port of the old
-- scripts/set-monitor-transform.sh, with no shell or jq involved.
local function set_transform(output, transform)
  return function()
    local monitor = hl.get_monitor(output)
    if not monitor then
      return
    end

    hl.monitor({
      output = output,
      mode = string.format("%dx%d@%d", monitor.width, monitor.height, math.floor(monitor.refresh_rate + 0.5)),
      position = string.format("%dx%d", monitor.x, monitor.y),
      scale = monitor.scale,
      transform = transform,
    })
  end
end

o.bind("SUPER + bracketleft", "Screen normal", set_transform("eDP-1", 0))
o.bind("SUPER + bracketright", "Screen flipped 180", set_transform("eDP-1", 2))
o.bind("SUPER + SHIFT + bracketleft", "Screen rotate left", set_transform("eDP-1", 1))
o.bind("SUPER + SHIFT + bracketright", "Screen rotate right", set_transform("eDP-1", 3))

-- ---------------------------------------------------------------------------
-- Dictation
-- ---------------------------------------------------------------------------

-- Push-to-talk on HOME, alongside Omarchy's default F9 binding.
if o.cmd_present("voxtype") then
  o.bind("HOME", "Start dictation", "voxtype record start")
  o.bind("HOME", "Stop dictation", "voxtype record stop", { release = true })
end
