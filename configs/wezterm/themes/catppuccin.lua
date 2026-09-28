local wezterm = require("wezterm")
local color_scheme = wezterm.color.get_builtin_schemes()["Catppuccin Mocha"]
local primary_color = "#89b4fa"
local secondary_color = "#cba6f7"
local inactive_color = "#313244"
local background_color = color_scheme.background

-- color_scheme.tab_bar = {
--   active_tab = {
--     bg_color = primary_color,
--     fg_color = background_color,
--   },
--   inactive_tab_hover = {
--     bg_color = inactive_color,
--     fg_color = primary_color,
--   },
--   inactive_tab = {
--     bg_color = inactive_color,
--     fg_color = primary_color,
--   },
--   new_tab = {
--     bg_color = background_color,
--     fg_color = primary_color,
--   },
--   new_tab_hover = {
--     bg_color = inactive_color,
--     fg_color = primary_color,
--   },
--   background = background_color,
-- }

return {
  builtin_color_scheme_name = "Catppuccin Mocha",
  color_scheme = color_scheme,
}
