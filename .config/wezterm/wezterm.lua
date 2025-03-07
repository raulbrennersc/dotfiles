local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font_with_fallback({
	{ family = "FiraCode Nerd Font", scale = 1.5 },
})
config.window_background_opacity = 0.7
config.window_decorations = "RESIZE"
config.enable_tab_bar = false
config.colors = {
	background = "#000000",
}
return config
