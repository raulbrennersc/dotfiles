local wezterm = require("wezterm")
local theme = require("theme")
local color_scheme = theme.colors.color_scheme
local function tab_title(tab_info)
	local title = tab_info.tab_title
	if title and #title > 0 then
		return title
	end
	return tab_info.active_pane.title
end

local function setup()
	wezterm.on("format-tab-title", function(tab, _, _, event_config)
		local background = color_scheme.tab_bar.active_tab.bg_color
		local foreground = color_scheme.tab_bar.active_tab.fg_color
		local is_active = tab.is_active

		if not is_active then
			background = color_scheme.tab_bar.inactive_tab.bg_color
			foreground = color_scheme.tab_bar.inactive_tab.fg_color
		end

		local title = tab_title(tab)

		local tab_content = {}
		-- left tab divider
		table.insert(tab_content, { Foreground = { Color = background } })
		table.insert(tab_content, { Background = { Color = color_scheme.tab_bar.background } })
		table.insert(tab_content, { Text = theme.dividers.to_right_inverse })

		-- tab title
		title = wezterm.truncate_right(title, event_config.tab_max_width - 1)
		table.insert(tab_content, { Background = { Color = background } })
		table.insert(tab_content, { Foreground = { Color = foreground } })
		table.insert(tab_content, { Text = " " .. title .. " " })

		-- right tab divider
		table.insert(tab_content, { Background = { Color = color_scheme.tab_bar.background } })
		table.insert(tab_content, { Foreground = { Color = background } })
		table.insert(tab_content, { Text = theme.dividers.to_right })

		return tab_content
	end)
end
return {
	setup = setup,
}
