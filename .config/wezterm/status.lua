local wezterm = require("wezterm")
local theme = require("theme")
local utils = require("utils")
local user = os.getenv("USER")

local function setup()
	local color_scheme = theme.colors.color_scheme
	wezterm.on("update-status", function(window, pane)
		local left_status = {
			{ Background = { Color = color_scheme.tab_bar.active_tab.bg_color } },
			{ Foreground = { Color = color_scheme.tab_bar.active_tab.fg_color } },
			{ Text = " " .. utils.get_os_icon(pane) .. " " },
			{ Background = { Color = color_scheme.tab_bar.background } },
			{ Foreground = { Color = color_scheme.tab_bar.active_tab.bg_color } },
			{ Text = theme.dividers.right .. " " },
		}

		local right_status_cells = {
			{
				first = true,
				text = " " .. user .. "@" .. pane:get_domain_name() .. " ",
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
				table.insert(right_status, { Text = theme.dividers.left })
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
