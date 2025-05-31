local wezterm = require("wezterm")
local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end

require("status").setup()
require("tabs").setup()
require("domains").setup(config)
require("keybinds").setup(config)
require("theme").setup(config, false)

config.scrollback_lines = 90000

return config
