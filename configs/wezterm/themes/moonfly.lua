local wezterm = require("wezterm")
local color_scheme = wezterm.color.get_builtin_schemes()["Moonfly (Gogh)"]
local primary_color = "#80a0ff"
local secondary_color = "#ae81ff"
local inactive_color = "#303030"
local background_color = color_scheme.background

return {
  builtin_color_scheme_name = "Moonfly (Gogh)",
  color_scheme = color_scheme,
}
