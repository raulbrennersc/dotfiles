vim.pack.add({ { src = "gh:nvim-mini/mini.nvim", branch = "stable" } })
require("mini.icons").setup()
require("mini.icons").tweak_lsp_kind()
require("mini.pairs").setup()
require("mini.ai").setup()
require("mini.completion").setup()

vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    vim.b.minicompletion_disable = vim.bo.buftype ~= ""
  end,
})
