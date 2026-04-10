vim.pack.add({ "gh:neovim/nvim-lspconfig" })
vim.lsp.enable("lua_ls")
vim.lsp.enable("eslint")
vim.lsp.enable("vtsls")

vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP code action" })
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "LSP code diagnostics" })
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "Format current buffer" })
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "LSP Rename", buffer = bufnr })

-- Native autocomplete -- using mini for now
-- vim.api.nvim_create_autocmd("BufEnter", {
--   callback = function()
--     vim.bo.autocomplete = vim.bo.buftype == ""
--   end,
-- })
--
-- vim.api.nvim_create_autocmd("LspAttach", {
--   group = vim.api.nvim_create_augroup("lsp_completion", { clear = true }),
--   callback = function(args)
--     local client_id = args.data.client_id
--     if not client_id then
--       return
--     end
--
--     local client = vim.lsp.get_client_by_id(client_id)
--     if client and client:supports_method("textDocument/completion") then
--       vim.lsp.completion.enable(true, client_id, args.buf, {
--         autotrigger = true,
--       })
--     end
--   end,
-- })
--
-- vim.cmd("set completeopt+=noselect")
