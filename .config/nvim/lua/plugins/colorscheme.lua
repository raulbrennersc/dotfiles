local config_moonfly = function()
  vim.g.moonflyTransparent = true
  vim.g.moonflyNormalFloat = true
end

return {
  { "ellisonleao/gruvbox.nvim", priority = 1000, config = true, opts = { transparent_mode = true } },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
  { "catppuccin/nvim", name = "catppuccin", priority = 1000, config = {
    transparent_background = true,
  } },
  {
    "bluz71/vim-moonfly-colors",
    name = "moonfly",
    lazy = false,
    priority = 1000,
    config = config_moonfly,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
}
