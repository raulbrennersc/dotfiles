local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux
local config = {}
local user = os.getenv("USER")
local transparent = false

if wezterm.config_builder then
	config = wezterm.config_builder()
end
local color_scheme_name = "Moonfly (Gogh)"
local color_scheme = wezterm.color.get_builtin_schemes()[color_scheme_name]
-- color_scheme.background = "black"
local background_color = color_scheme.background
config.color_scheme = color_scheme_name
if transparent then
	config.window_background_opacity = 0.9
	background_color = "transparent"
end

color_scheme.cursor_border = "#80a0ff"
color_scheme.cursor_bg = "#80a0ff"
config.cursor_blink_ease_in = "Linear"
config.cursor_blink_ease_out = "Linear"
config.animation_fps = 60

config.default_cursor_style = "BlinkingUnderline"
config.cursor_blink_rate = 400
config.tab_max_width = 20
color_scheme.tab_bar = {
	active_tab = {
		bg_color = "#80a0ff",
		fg_color = color_scheme.background,
		intensity = "Bold",
	},
	inactive_tab = {
		bg_color = "#303030",
		fg_color = "#80a0ff",
	},
	new_tab = {
		bg_color = background_color,
		fg_color = "#80a0ff",
	},
	background = background_color,
}

config.color_schemes = {
	[color_scheme_name] = color_scheme,
}

config.font = wezterm.font({
	family = "JetBrainsMono Nerd Font",
})
config.font_size = 15
config.window_decorations = "NONE"
config.enable_tab_bar = false
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.default_workspace = user

config.window_padding = {
	top = "0.3cell",
	bottom = "0.2cell",
	left = "0.9cell",
	right = "0.2cell",
}

config.unix_domains = {
	{
		name = user,
	},
}

config.default_gui_startup_args = { "connect", user }

local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

local function tab_title(tab_info)
	local title = tab_info.tab_title
	if title and #title > 0 then
		return title
	end
	return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab, tabs, _, config_from_event)
	local background = color_scheme.tab_bar.inactive_tab.bg_color
	local foreground = color_scheme.tab_bar.inactive_tab.fg_color
	local edge_background = background
	local is_last_tab = tab.tab_index == (#tabs - 1)
	local is_first_tab = tab.tab_index == 0
	local is_active = tab.is_active
	local is_previous_active = not is_first_tab and tabs[tab.tab_index].is_active

	if is_active then
		edge_background = color_scheme.tab_bar.inactive_tab.bg_color
		background = color_scheme.tab_bar.active_tab.bg_color
		foreground = color_scheme.tab_bar.active_tab.fg_color
	end

	local edge_foreground = background
	local title = tab_title(tab)

	local tab_content = {}

	if not is_first_tab and is_active then
		table.insert(tab_content, { Background = { Color = edge_foreground } })
		table.insert(tab_content, { Foreground = { Color = edge_background } })
		table.insert(tab_content, { Text = SOLID_RIGHT_ARROW .. " " })
	else
		table.insert(tab_content, { Background = { Color = background } })
		table.insert(tab_content, { Foreground = { Color = foreground } })
		if is_first_tab or is_previous_active then
			table.insert(tab_content, { Text = " " })
		else
			table.insert(tab_content, { Text = " " })
		end
	end

	title = wezterm.truncate_right(title, config_from_event.tab_max_width - 3)
	table.insert(tab_content, { Background = { Color = background } })
	table.insert(tab_content, { Foreground = { Color = foreground } })
	table.insert(tab_content, { Text = title })

	if is_last_tab then
		table.insert(tab_content, { Background = { Color = color_scheme.tab_bar.background } })
	else
		table.insert(tab_content, { Background = { Color = edge_background } })
	end
	table.insert(tab_content, { Foreground = { Color = edge_foreground } })
	table.insert(tab_content, { Text = SOLID_RIGHT_ARROW })

	return tab_content
end)

wezterm.on("update-right-status", function(window, pane)
	local cells = {
		{
			text = wezterm.strftime("%a %b %-d %H:%M") .. " ",
			bg = color_scheme.tab_bar.inactive_tab.bg_color,
			fg = color_scheme.tab_bar.inactive_tab.fg_color,
		},
		{
			text = pane:get_domain_name(),
			bg = color_scheme.tab_bar.active_tab.bg_color,
			fg = color_scheme.tab_bar.active_tab.fg_color,
		},
	}

	local elements = {}
	local function push(cell)
		table.insert(elements, { Foreground = { Color = cell.bg } })
		table.insert(elements, { Text = SOLID_LEFT_ARROW })
		table.insert(elements, { Foreground = { Color = cell.fg } })
		table.insert(elements, { Background = { Color = cell.bg } })
		table.insert(elements, { Text = " " .. cell.text })
	end

	while #cells > 0 do
		local cell = table.remove(cells, 1)
		push(cell)
	end

	window:set_right_status(wezterm.format(elements))
end)

config.scrollback_lines = 90000

-- config.leader = {
-- 	key = "a",
-- 	mods = "CTRL",
-- 	timeout_milliseconds = 2000,
-- }

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
		key = "d",
		mods = "LEADER",
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

return config
