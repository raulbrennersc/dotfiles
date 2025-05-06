-- copied from https://github.com/bluz71/vim-moonfly-colors/blob/master/lua/lualine/themes/moonfly.lua

local colors = {
  color0 = "#303030",
  color1 = "#80a0ff",
  color2 = "#36c692",
  color3 = "#ae81ff",
  color4 = "#e3c78a",
  color5 = "#ff5189",
  color6 = "#080808",
  color7 = "#9e9e9e",
}

local theme = {
  normal = {
    a = { fg = colors.color6, bg = colors.color1 },
    b = { fg = colors.color1, bg = colors.color0 },
    c = { fg = colors.color1, bg = colors.color6 },
  },
  insert = {
    a = { fg = colors.color6, bg = colors.color2 },
    b = { fg = colors.color2, bg = colors.color0 },
  },
  visual = {
    a = { fg = colors.color6, bg = colors.color3 },
    b = { fg = colors.color3, bg = colors.color0 },
  },
  command = {
    a = { fg = colors.color6, bg = colors.color4 },
    b = { fg = colors.color4, bg = colors.color0 },
  },
  replace = {
    a = { fg = colors.color6, bg = colors.color5 },
    b = { fg = colors.color5, bg = colors.color0 },
  },
  terminal = {
    a = { fg = colors.color6, bg = colors.color2 },
    b = { fg = colors.color2, bg = colors.color0 },
  },
  inactive = {
    a = { fg = colors.color7, bg = colors.color0 },
    b = { fg = colors.color7, bg = colors.color0 },
    c = { fg = colors.color7, bg = colors.color0 },
  },
}

return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      require("lualine").setup({
        options = { theme = theme },
      })
    end,
  },
}
