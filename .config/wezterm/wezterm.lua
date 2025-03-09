local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font({
	family = "FiraCode Nerd Font",
})
config.font_size = 15
config.window_background_opacity = 0.7
config.window_decorations = "RESIZE"
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.window_padding = {
	top = "0.4cell",
	bottom = 0,
	left = 0,
	right = 0,
}
config.colors = {
	background = "black",
	tab_bar = {
		background = "#181825",
		active_tab = {
			bg_color = "#89b4fa",
			fg_color = "#181825",
			intensity = "Bold",
		},
	},
}
return config
