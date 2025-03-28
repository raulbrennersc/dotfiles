local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux
local config = {}
local user = os.getenv("USER")

if wezterm.config_builder then
	config = wezterm.config_builder()
end
local color_scheme_name = "Moonfly (Gogh)"
local color_scheme = wezterm.color.get_builtin_schemes()[color_scheme_name]
config.color_scheme = color_scheme_name

config.window_background_opacity = 0.5
color_scheme.background = "black"

color_scheme.tab_bar = {
	active_tab = {
		bg_color = "#80a0ff",
		fg_color = "#181825",
		intensity = "Bold",
	},
	inactive_tab = {
		bg_color = "transparent",
		fg_color = "#808080",
	},
	new_tab = {
		bg_color = "transparent",
		fg_color = "#808080",
	},
	background = "transparent",
}

config.color_schemes = {
	[color_scheme_name] = color_scheme,
}

config.font = wezterm.font({
	family = "FiraCode Nerd Font",
})
config.font_size = 15
config.window_decorations = "NONE"
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
-- config.enable_tab_bar = false
config.default_workspace = user

config.window_padding = {
	top = "0.9cell",
}

config.unix_domains = {
	{
		name = user,
	},
}

config.default_gui_startup_args = { "connect", user }

wezterm.on("update-right-status", function(window, pane)
	local cells = {
		{
			text = wezterm.strftime("%a %b %-d %H:%M"),
			bg = color_scheme.tab_bar.new_tab.bg_color,
			fg = color_scheme.tab_bar.active_tab.bg_color,
		},
		{
			text = pane:get_domain_name(),
			bg = color_scheme.tab_bar.active_tab.bg_color,
			fg = color_scheme.tab_bar.active_tab.fg_color,
		},
	}

	local LEFT_ARROW = utf8.char(0xe0b3)
	local SOLID_LEFT_ARROW = utf8.char(0xe0b2)

	local elements = {}
	function push(cell)
		table.insert(elements, { Foreground = { Color = cell.bg } })
		table.insert(elements, { Text = SOLID_LEFT_ARROW })
		table.insert(elements, { Foreground = { Color = cell.fg } })
		table.insert(elements, { Background = { Color = cell.bg } })

		table.insert(elements, { Text = " " .. cell.text .. " " })
	end

	while #cells > 0 do
		local cell = table.remove(cells, 1)
		push(cell)
	end

	window:set_right_status(wezterm.format(elements))
end)

config.scrollback_lines = 90000

config.leader = {
	key = "a",
	mods = "CTRL",
	timeout_milliseconds = 2000,
}

local muxDomains = {}
local status, allDomains = pcall(wezterm.mux.all_domains)
if not status then
	allDomains = {}
end
print(wezterm.mux.all_domains)
for index, value in ipairs(allDomains) do
	print(value:name())
	local isMux = string.find(value:name(), "SSHMUX")
	local isDevcontainer = string.find(value:name(), ".devcontainer")
	local isFromuser = value:name() == user
	if (isMux and isDevcontainer) or isFromuser then
		local muxDomain = {
			label = value:name(),
		}
		table.insert(muxDomains, muxDomain)
	end
end

config.keys = {
	{
		key = "E",
		mods = "CTRL|SHIFT",
		action = act.InputSelector({
			action = wezterm.action_callback(function(window, pane, id, label)
				window:perform_action(
					wezterm.action({
						SwitchToWorkspace = {
							name = label,
							spawn = {
								domain = { DomainName = label },
							},
						},
					}),
					pane
				)
			end),
			title = "Select domain",
			choices = muxDomains,
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
		key = "&",
		mods = "LEADER|SHIFT",
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
	{
		key = "d",
		mods = "LEADER",
		action = act.ShowLauncherArgs({ flags = "DOMAINS" }),
	},
}

return config
