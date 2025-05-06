local config_moonfly = function()
  -- vim.g.moonflyTransparent = true
  -- vim.g.moonflyNormalFloat = true
  local custom_highlight = vim.api.nvim_create_augroup("CustomHighlight", {})
  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
      -- vim.api.nvim_set_hl(0, "CursorLine", { bold = true })
      -- vim.api.nvim_set_hl(0, "CursorLineNr", { bold = true })
      vim.api.nvim_set_hl(0, "DiffDelete", { fg = "#e65e72" })
      vim.api.nvim_set_hl(0, "DiffAdd", { fg = "#36c692" })
      vim.api.nvim_set_hl(0, "DiffChange", { bg = "blue" })
      vim.api.nvim_set_hl(0, "DiffText", { bg = "blue" })
    end,
    group = custom_highlight,
  })
end

return {
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
      colorscheme = "moonfly",
    },
  },
}
