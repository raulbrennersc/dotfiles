local wezterm = require("wezterm")
local domains = require("domains")
local act = wezterm.action
local mux = wezterm.mux

local function setup(config)
	config.leader = {
		key = "a",
		mods = "CTRL",
		timeout_milliseconds = 2000,
	}

	config.keys = {
		{
			key = "d",
			mods = "LEADER",
			action = act.InputSelector({
				choices = domains.get_mux_domains(),
				action = wezterm.action_callback(domains.switch_domain),
				description = "Switch domain",
				title = "Select domain",
			}),
		},
		{
			key = "f",
			mods = "ALT",
			action = act.TogglePaneZoomState,
		},
		{
			key = "c",
			mods = "LEADER",
			action = act.SpawnTab("CurrentPaneDomain"),
		},
		{
			key = "n",
			mods = "LEADER|CTRL",
			action = wezterm.action.ActivateTabRelative(1),
		},
		{
			key = "p",
			mods = "LEADER|CTRL",
			action = wezterm.action.ActivateTabRelative(-1),
		},
		{
			key = "n",
			mods = "LEADER",
			action = wezterm.action.ActivateTabRelative(1),
		},
		{
			key = "p",
			mods = "LEADER",
			action = wezterm.action.ActivateTabRelative(-1),
		},
		{
			key = ",",
			mods = "LEADER",
			action = act.PromptInputLine({
				description = "Enter new name for tab",
				action = wezterm.action_callback(function(window, _, line)
					if line then
						window:active_tab():set_title(line)
					end
				end),
			}),
		},
		{
			key = "w",
			mods = "LEADER",
			action = act.ShowTabNavigator,
		},
		{
			key = "q",
			mods = "LEADER",
			action = act.CloseCurrentTab({ confirm = true }),
		},
		{
			key = "=",
			mods = "LEADER",
			action = act.SplitPane({
				direction = "Right",
				size = { Percent = 50 },
			}),
		},
		{
			key = "-",
			mods = "LEADER",
			action = act.SplitPane({
				direction = "Down",
				size = { Percent = 50 },
			}),
		},
		{
			key = ";",
			mods = "LEADER",
			action = act.ActivatePaneDirection("Prev"),
		},
		{
			key = "h",
			mods = "LEADER",
			action = act.ActivatePaneDirection("Left"),
		},
		{
			key = "j",
			mods = "LEADER",
			action = act.ActivatePaneDirection("Down"),
		},
		{
			key = "k",
			mods = "LEADER",
			action = act.ActivatePaneDirection("Up"),
		},
		{
			key = "l",
			mods = "LEADER",
			action = act.ActivatePaneDirection("Right"),
		},
		{
			key = "o",
			mods = "LEADER",
			action = act.ActivatePaneDirection("Next"),
		},
		{
			key = "$",
			mods = "LEADER|SHIFT",
			action = act.PromptInputLine({
				description = "Enter new name for workspace",
				action = wezterm.action_callback(function(window, _, line)
					if line then
						mux.rename_workspace(window:mux_window():get_workspace(), line)
					end
				end),
			}),
		},
		{
			key = "s",
			mods = "LEADER",
			action = act.ShowLauncherArgs({ flags = "WORKSPACES" }),
		},
	}
end

return {
	setup = setup,
}
