require("bindings")

hl.monitor({
  output = "DP-1",
  mode = "2560x1440@144",
  position = "0x0",
  scale = 1,
})
hl.device({
  name = "logitech-g502-x-plus-1",
  scroll_factor = 6,
})

hl.on("hyprland.start", function()
  hl.exec_cmd("uwsm-app -- qs")
  hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
end)

hl.config({
  general = {
    border_size = 2,
    col = {
      active_border = 0xff7aa2f7,
      inactive_border = "rgba(595959aa)",
    },

    resize_on_border = true,
    allow_tearing = false,
    layout = "dwindle",
  },

  decoration = {
    active_opacity = 1.0,
    inactive_opacity = 0.9,

    shadow = {
      enabled = true,
      range = 4,
      render_power = 3,
      color = "rgba(1a1a1aee)",
    },

    blur = {
      enabled = true,
      size = 2,
      passes = 1,
    },
  },

  layout = {
    single_window_aspect_ratio = { 1.6, 1 },
  },

  misc = {
    force_default_wallpaper = 0,
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
  },
})

hl.animation({ leaf = "windows", enabled = true, speed = 4, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 3, bezier = "default" })

hl.workspace_rule({ workspace = "w[t1]", gaps_out = { top = 0, bottom = 0, right = 300, left = 300 } })
hl.workspace_rule({ workspace = "w[t2-10]", gaps_out = { top = 4, bottom = 4, right = 10, left = 10 }, gaps_in = 2 })

hl.window_rule({
  name = "apply-something",
  match = {
    class = "my-window",
  },
  border_size = 10,
})

hl.window_rule({
  name = "suppress-maximize-events",
  match = {
    class = ".*",
  },
  suppress_event = "maximize",
})

hl.window_rule({
  name = "fix-xwayland-drags",
  match = {
    class = "^$",
    title = "^$",
    xwayland = true,
    float = true,
    fullscreen = false,
    pin = false,
  },

  no_focus = true,
})

hl.window_rule({
  name = "tui-popup",
  float = true,
  center = true,
  size = { 1000, 700 },
  match = {
    class = "tui-popup",
  },
})

hl.window_rule({
  name = "steam-popups",
  float = true,
  center = true,
  match = {
    class = "steam",
    title = "(Friends List)|(Steam Settings)|(Steam - Browser)",
  },
})
