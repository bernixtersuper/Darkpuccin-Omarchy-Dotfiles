-- Workspace rules, ported from the pre-4.0 hyprlang workspaces.conf.

-- Smart gaps: drop gaps when a workspace holds a single tiled window (w[tv1])
-- or a single fullscreen one (f[1]).
--
-- With gaps_in/gaps_out already at 0 globally (see looknfeel.lua) these two
-- rules are currently no-ops, but they're kept so smart gaps still work if the
-- global gaps are ever turned back on.
hl.workspace_rule({ workspace = "w[tv1]", gaps_in = 0, gaps_out = 0 })
hl.workspace_rule({ workspace = "f[1]", gaps_in = 0, gaps_out = 0 })

-- ...and strip the border/rounding from that lone window too. Scoped to tiled
-- windows (float 0) so floating windows keep their border.
for _, workspace in ipairs({ "w[tv1]", "f[1]" }) do
  o.window({ float = false, workspace = workspace }, { border_size = 0, rounding = 0 })
end

-- cliamp (music player) always opens on workspace 10.
o.window("org\\.omarchy\\.cliamp", { workspace = "10" })

-- herdr gets its own named 🐑 workspace, reachable via SUPER+ALT+H.
o.window("org\\.omarchy\\.herdr", { workspace = "name:🐑" })
