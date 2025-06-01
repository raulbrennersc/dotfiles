local wezterm = require("wezterm")
local color_scheme = wezterm.color.get_builtin_schemes()["Moonfly (Gogh)"]
local accent_color = "#80a0ff"
local inactive_color = "#303030"
local background_color = color_scheme.background

return {
	accent_color = accent_color,
	inactive_color = inactive_color,
	background_color = background_color,
	builtin_color_scheme_name = "Moonfly (Gogh)",
	color_scheme = color_scheme,
}
