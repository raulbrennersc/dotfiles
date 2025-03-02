return {
  {
    "vague2k/vague.nvim",
    config = function()
      require("vague").setup({
        transparent = true,
      })
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "vague",
    },
  },
}
