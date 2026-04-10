local wezterm = require("wezterm")
local color_scheme = wezterm.color.get_builtin_schemes()["tokyonight_night"]
local primary_color = "#82aaff"
local inactive_color = "#3b4261"
local background_color = color_scheme.background

return {
  builtin_color_scheme_name = "tokyonight_night",
  color_scheme = color_scheme,
}
