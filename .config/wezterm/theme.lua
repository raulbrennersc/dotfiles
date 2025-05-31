local wezterm = require("wezterm")
IS_TRANSPARENT = false
local main_theme = require("moonfly")

local function setup(config, is_transparent)
	IS_TRANSPARENT = is_transparent
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

	if IS_TRANSPARENT then
		config.window_background_opacity = 0.85
	end

	main_theme.color_scheme.cursor_border = main_theme.accent_color
	main_theme.color_scheme.cursor_bg = main_theme.accent_color

	main_theme.color_scheme.tab_bar = {
		active_tab = {
			bg_color = main_theme.accent_color,
			fg_color = main_theme.background_color,
		},
		inactive_tab_hover = {
			italic = false,
			bg_color = main_theme.inactive_color,
			fg_color = main_theme.accent_color,
		},
		inactive_tab = {
			bg_color = main_theme.inactive_color,
			fg_color = main_theme.accent_color,
		},
		new_tab = {
			bg_color = main_theme.background_color,
			fg_color = main_theme.accent_color,
		},
		new_tab_hover = {
			bg_color = main_theme.inactive_color,
			fg_color = main_theme.accent_color,
		},
		background = main_theme.background_color,
	}
	config.color_schemes = {
		[main_theme.builtin_color_scheme_name] = main_theme.color_scheme,
	}
end

local dividers = {
	to_left = wezterm.nerdfonts.pl_right_hard_divider,
	to_left_inverse = wezterm.nerdfonts.ple_right_hard_divider_inverse,
	to_right = wezterm.nerdfonts.pl_left_hard_divider,
	to_right_inverse = wezterm.nerdfonts.ple_left_hard_divider_inverse,
}

return {
	setup = setup,
	colors = main_theme,
	dividers = dividers,
}
