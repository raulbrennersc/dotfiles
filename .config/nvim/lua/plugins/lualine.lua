   return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function()
    local opts = {
      options = {
    component_separators = { left = '|', right = '|'},
    section_separators = { left = '', right = ''},
      },
    }
    return opts
  end,
}
