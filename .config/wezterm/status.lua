local wezterm = require("wezterm")
local theme = require("theme")
local color_scheme = theme.colors.color_scheme
local function setup()
	local handle = io.popen("cat /etc/os-release")
	local os_release = string.gsub(handle:read("*a"), "\n", "")
	handle:close()

	wezterm.on("update-status", function(window, pane)
		local os_icon = ""
		if string.find(pane:get_domain_name(), ".devcontainer") then
			os_icon = ""
		elseif string.find(os_release, "arch") then
			os_icon = ""
		elseif string.find(os_release, "debian") then
			os_icon = ""
		end
		local left_status = {
			{ Background = { Color = color_scheme.tab_bar.inactive_tab.bg_color } },
			{ Foreground = { Color = color_scheme.tab_bar.inactive_tab.fg_color } },
			{ Text = " " .. os_icon .. " " },
			{ Background = { Color = color_scheme.tab_bar.background } },
			{ Foreground = { Color = color_scheme.tab_bar.inactive_tab.bg_color } },
			{ Text = theme.dividers.to_right },
		}

		local right_status_cells = {
			-- {
			-- 	text = " " .. user .. " ",
			-- bg = background_color,
			-- fg = color_scheme.tab_bar.inactive_tab.fg_color,
			-- },
			{
				first = true,
				text = "󱩛 " .. pane:get_domain_name() .. " ",
				bg = color_scheme.tab_bar.background,
				fg = color_scheme.tab_bar.inactive_tab.fg_color,
			},
			{
				text = " " .. wezterm.strftime("%-d/%b") .. " ",
				bg = color_scheme.tab_bar.inactive_tab.bg_color,
				fg = color_scheme.tab_bar.inactive_tab.fg_color,
			},
			{
				text = wezterm.strftime(" %H:%M") .. " ",
				bg = color_scheme.tab_bar.active_tab.bg_color,
				fg = color_scheme.tab_bar.active_tab.fg_color,
			},
		}

		local right_status = {}
		local function push(cell)
			if not cell.first then
				table.insert(right_status, { Foreground = { Color = cell.bg } })
				table.insert(right_status, { Text = theme.dividers.to_left })
			end
			table.insert(right_status, { Foreground = { Color = cell.fg } })
			table.insert(right_status, { Background = { Color = cell.bg } })
			table.insert(right_status, { Text = " " .. cell.text })
		end

		while #right_status_cells > 0 do
			local cell = table.remove(right_status_cells, 1)
			push(cell)
		end

		window:set_left_status(wezterm.format(left_status))
		window:set_right_status(wezterm.format(right_status))
	end)
end
return { setup = setup }
