local wezterm = require("wezterm")
local mux = wezterm.mux
local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end

require("status").setup()
require("tabs").setup()
require("domains").setup(config)
require("keybinds").setup(config)

wezterm.on("gui-attached", function(domain)
	-- maximize all displayed windows on startup
	local workspace = mux.get_active_workspace()
	for _, window in ipairs(mux.all_windows()) do
		if window:get_workspace() == workspace then
			window:gui_window():maximize()
		end
	end
end)

require("theme").setup(config, false)

config.scrollback_lines = 90000

return config
