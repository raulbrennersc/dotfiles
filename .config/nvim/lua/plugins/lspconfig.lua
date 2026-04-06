vim.pack.add { "gh:neovim/nvim-lspconfig" }
vim.lsp.enable('lua_ls')
vim.lsp.enable('ts_ls')
vim.lsp.enable('eslint')

vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = "LSP code action" })
vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float, { desc = "LSP code diagnostics" })
vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, { desc = "Format current buffer" })
