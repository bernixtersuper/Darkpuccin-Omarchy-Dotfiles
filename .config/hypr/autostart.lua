-- Extra autostart processes, ported from the pre-4.0 hyprlang autostart.conf.

-- NOTE: the old config's `exec-once = fcitx5` is deliberately NOT ported.
-- Omarchy 4.0 starts the input-method daemon itself via the enabled
-- omarchy-fcitx5.service user unit (plus an XDG autostart entry), so launching
-- it here again would just duplicate the daemon.

-- Cursor theme. Omarchy's default is size 24 with the theme left to the
-- active Omarchy theme; this pins Breeze Dark at 30 as the old config did.
--
-- NOTE: the theme is named "breeze-dark" on this machine -- the old config's
-- "Breeze_Dark" was the naming on the previous install and would silently
-- fail here.
o.exec_on_start("hyprctl setcursor breeze-dark 30")

-- ThinkPad hardware bluetooth switch sometimes comes up soft-blocked.
o.exec_on_start("rfkill unblock bluetooth")

-- Experimental: pre-bind the B&W filter shader once at login then clear it,
-- in case Hyprland caches the compiled shader by path -- see
-- scripts/warm-bw-filter.sh. Meant to hide the stutter reported when
-- SUPER+CTRL+M first turns the shader on during a session.
o.exec_on_start(os.getenv("HOME") .. "/.config/hypr/scripts/warm-bw-filter.sh")
