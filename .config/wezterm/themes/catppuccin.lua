local wezterm = require("wezterm")
local color_scheme = wezterm.color.get_builtin_schemes()["Catppuccin Mocha"]
local primary_color = "#89b4fa"
local secondary_color = "#cba6f7"
local inactive_color = "#313244"
local background_color = color_scheme.background

return {
	primary_color = primary_color,
	secondary_color = secondary_color,
	inactive_color = inactive_color,
	background_color = background_color,
	builtin_color_scheme_name = "Catppuccin Mocha",
	color_scheme = color_scheme,
}
