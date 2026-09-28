vim.pack.add({
  { src = "gh:folke/tokyonight.nvim", name = "tokyonight" },
})

require("tokyonight").setup({
  transparent = true,
  styles = {
    sidebar = "transparent",
    floats = "transparent",
  },
})

vim.cmd([[colorscheme tokyonight-night]])
