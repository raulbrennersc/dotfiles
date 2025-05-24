local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux
local config = {}
local user = os.getenv("USER")
local transparent = false
local hostname = wezterm.hostname()

if wezterm.config_builder then
	config = wezterm.config_builder()
end
local color_scheme_name = "Moonfly (Gogh)"
local color_scheme = wezterm.color.get_builtin_schemes()[color_scheme_name]
local background_color = color_scheme.background
config.color_scheme = color_scheme_name
if transparent then
	config.window_background_opacity = 0.9
	background_color = "transparent"
end

-- WTF why lua doesn't have built in string.split?!?!?!? I DON'T KNOW
-- split hack
local function split(input, separator)
	local t = {}
	for str in string.gmatch(input, "([^" .. separator .. "]+)") do
		table.insert(t, str)
	end
	return t
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
	},
	inactive_tab_hover = {
		italic = false,
		bg_color = "#303030",
		fg_color = "#80a0ff",
	},
	inactive_tab = {
		bg_color = "#303030",
		fg_color = "#80a0ff",
	},
	new_tab = {
		bg_color = background_color,
		fg_color = "#80a0ff",
	},
	new_tab_hover = {
		bg_color = "#303030",
		fg_color = "#80a0ff",
	},
	background = background_color,
}

config.inactive_pane_hsb = {
	saturation = 1,
	brightness = 1,
}

config.color_schemes = {
	[color_scheme_name] = color_scheme,
}

config.font = wezterm.font({
	family = "Hack Nerd Font",
})
config.font_size = 15
config.window_decorations = "NONE"
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.default_workspace = user

config.window_padding = {
	top = "0.3cell",
	bottom = "0.2cell",
	left = "0.9cell",
	right = "0.2cell",
}

config.ssh_domains = {}
config.unix_domains = {
	{
		name = hostname,
	},
}

local handle = io.popen("devcontainer list")
local devcontainers = split(string.gsub(handle:read("*a"), "\n", ""), " ")
handle:close()

for _, devcontainer in pairs(devcontainers) do
	local name = split(devcontainer, "|")[1]
	local port = split(devcontainer, "|")[2]
	local domain = {
		name = name,
		remote_address = "localhost",
		ssh_option = {
			hostname = "localhost",
			user = "dev",
			forwardx11 = "yes",
			forwardagent = "yes",
			port = port,
		},
	}

	table.insert(config.ssh_domains, domain)
end

config.default_gui_startup_args = { "connect", hostname }

local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

local function tab_title(tab_info)
	local title = tab_info.tab_title
	if title and #title > 0 then
		return title
	end
	return tab_info.active_pane.title
end

handle = io.popen("cat /etc/os-release")
local os_release = string.gsub(handle:read("*a"), "\n", "")
handle:close()

wezterm.on("format-tab-title", function(tab, tabs, panes, event_config)
	local background = color_scheme.tab_bar.inactive_tab.bg_color
	local foreground = color_scheme.tab_bar.inactive_tab.fg_color
	local edge_background = background
	local is_last_tab = tab.tab_index == (#tabs - 1)
	local is_first_tab = tab.tab_index == 0
	local is_active = tab.is_active
	local is_previous_active = not is_first_tab and tabs[tab.tab_index].is_active
	local is_next_active = not is_last_tab and tabs[tab.tab_index + 1].is_active

	if is_active then
		edge_background = color_scheme.tab_bar.inactive_tab.bg_color
		background = color_scheme.tab_bar.active_tab.bg_color
		foreground = color_scheme.tab_bar.active_tab.fg_color
	end

	local edge_foreground = background
	local title = tab_title(tab)

	local tab_content = {}
	local os_icon = ""
	if string.find(panes[1].domain_name, ".devcontainer") then
		os_icon = ""
	elseif string.find(os_release, "arch") then
		os_icon = ""
	elseif string.find(os_release, "debian") then
		os_icon = ""
	end

	-- show OS icon
	if is_first_tab then
		table.insert(tab_content, { Background = { Color = color_scheme.tab_bar.inactive_tab.bg_color } })
		table.insert(tab_content, { Foreground = { Color = color_scheme.tab_bar.inactive_tab.fg_color } })
		table.insert(tab_content, { Text = " " .. os_icon .. " " })
		table.insert(tab_content, { Foreground = { Color = color_scheme.tab_bar.inactive_tab.bg_color } })
		table.insert(tab_content, { Background = { Color = color_scheme.tab_bar.background } })
		table.insert(tab_content, { Text = SOLID_RIGHT_ARROW })
		table.insert(tab_content, { Foreground = { Color = color_scheme.tab_bar.background } })
		table.insert(tab_content, { Background = { Color = background } })
		table.insert(tab_content, { Text = SOLID_RIGHT_ARROW })

	-- left tab separator
	else
		table.insert(tab_content, { Background = { Color = edge_foreground } })
		table.insert(tab_content, { Foreground = { Color = color_scheme.tab_bar.background } })
		table.insert(tab_content, { Text = SOLID_RIGHT_ARROW })
	end

	-- tab title
	title = wezterm.truncate_right(title, event_config.tab_max_width - 4)
	table.insert(tab_content, { Background = { Color = background } })
	table.insert(tab_content, { Foreground = { Color = foreground } })
	table.insert(tab_content, { Text = " " .. title .. " " })

	-- right tab separator
	table.insert(tab_content, { Background = { Color = color_scheme.tab_bar.background } })
	if is_active then
		table.insert(tab_content, { Foreground = { Color = edge_foreground } })
	else
		table.insert(tab_content, { Foreground = { Color = edge_background } })
	end
	table.insert(tab_content, { Text = SOLID_RIGHT_ARROW })

	return tab_content
end)

wezterm.on("update-right-status", function(window, pane)
	local cells = {
		{
			text = " " .. user .. " ",
			bg = color_scheme.background,
			fg = color_scheme.tab_bar.inactive_tab.fg_color,
		},
		{
			text = "󱩛 " .. pane:get_domain_name() .. " ",
			bg = color_scheme.tab_bar.inactive_tab.bg_color,
			fg = color_scheme.tab_bar.inactive_tab.fg_color,
		},
		{
			text = " " .. wezterm.strftime("%b %-d  %H:%M") .. " ",
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

config.leader = {
	key = "a",
	mods = "CTRL",
	timeout_milliseconds = 2000,
}

local function get_mux_domains()
	local mux_domains = {}
	local status, all_domains = pcall(wezterm.mux.all_domains)
	if not status then
		all_domains = {}
	end

	for _, value in ipairs(all_domains) do
		local is_devcontainer = string.find(value:name(), ".devcontainer")
		local is_host = value:name() == hostname
		if is_devcontainer or is_host then
			table.insert(mux_domains, {
				label = value:name(),
			})
		end
	end
	return mux_domains
end

config.keys = {
	{
		key = "d",
		mods = "LEADER",
		action = act.InputSelector({
			action = wezterm.action_callback(function(window, pane, _, label)
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
			description = "Select domain",
			title = "Select domain",
			choices = get_mux_domains(),
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
