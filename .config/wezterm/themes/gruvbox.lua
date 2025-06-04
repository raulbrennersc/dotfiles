local wezterm = require("wezterm")
local color_scheme = wezterm.color.get_builtin_schemes()["Gruvbox Dark (Gogh)"]
local primary_color = "#83a598"
local secondary_color = "#fe8019"
local inactive_color = "#504945"
local background_color = color_scheme.background

return {
	primary_color = primary_color,
	secondary_color = secondary_color,
	inactive_color = inactive_color,
	background_color = background_color,
	builtin_color_scheme_name = "Gruvbox Dark (Gogh)",
	color_scheme = color_scheme,
}
