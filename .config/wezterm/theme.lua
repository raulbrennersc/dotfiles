local wezterm = require("wezterm")
local main_theme = require("themes.tokyonight")

local function setup(config, is_transparent)
	config.inactive_pane_hsb = {
		saturation = 1,
		brightness = 1,
	}

	config.font = wezterm.font({
		family = "Hack Nerd Font",
	})
	config.font_size = 15
	config.window_decorations = "NONE"
	config.enable_tab_bar = true
	config.use_fancy_tab_bar = false
	config.tab_bar_at_bottom = true

	config.window_padding = {
		top = "0.3cell",
		bottom = "0.2cell",
		left = "0.9cell",
		right = "0.2cell",
	}
	config.cursor_blink_ease_in = "Linear"
	config.cursor_blink_ease_out = "Linear"
	config.animation_fps = 144
	config.default_cursor_style = "BlinkingUnderline"
	config.cursor_blink_rate = 400
	config.tab_max_width = 25

	config.color_scheme = main_theme.builtin_color_scheme_name

	if is_transparent then
		config.window_background_opacity = 0.85
		main_theme.color_scheme.background = "black"
		main_theme.background_color = "transparent"
	end

	main_theme.color_scheme.cursor_border = main_theme.primary_color
	main_theme.color_scheme.cursor_bg = main_theme.primary_color

	main_theme.color_scheme.tab_bar = {
		active_tab = {
			bg_color = main_theme.primary_color,
			fg_color = main_theme.background_color,
		},
		inactive_tab_hover = {
			italic = false,
			bg_color = main_theme.inactive_color,
			fg_color = main_theme.primary_color,
		},
		inactive_tab = {
			bg_color = main_theme.inactive_color,
			fg_color = main_theme.primary_color,
		},
		new_tab = {
			bg_color = main_theme.background_color,
			fg_color = main_theme.primary_color,
		},
		new_tab_hover = {
			bg_color = main_theme.inactive_color,
			fg_color = main_theme.primary_color,
		},
		background = main_theme.background_color,
	}

	config.color_schemes = {
		[main_theme.builtin_color_scheme_name] = main_theme.color_scheme,
	}
end

local dividers = {
	left = wezterm.nerdfonts.ple_left_half_circle_thick,
	right = wezterm.nerdfonts.ple_right_half_circle_thick,
}

return {
	setup = setup,
	colors = main_theme,
	dividers = dividers,
}
