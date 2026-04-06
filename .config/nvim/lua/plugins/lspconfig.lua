vim.pack.add { "gh:neovim/nvim-lspconfig" }
vim.lsp.enable('lua_ls')
vim.lsp.enable('ts_ls')
vim.lsp.enable('eslint')

vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = "LSP code action" })
vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float, { desc = "LSP code diagnostics" })
vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, { desc = "Format current buffer" })
vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, { desc = 'LSP Rename', buffer = bufnr })

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

vim.lsp.buf.format({
  filter = function(client)
    return client.name == "eslint" -- Only use null-ls for formatting
  end,
})

local supported_ft = {
  "javascript", "typescript", "javascriptreact", "typescriptreact",
  "json", "jsonc", "html", "css", "scss", "markdown", "yaml"
}

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    local ft = vim.bo[args.buf].filetype
    
    -- Only proceed if the filetype is supported
    if not vim.tbl_contains(supported_ft, ft) then
      return
    end

    -- Check if prettier is actually installed in your system PATH
    if vim.fn.executable("prettier") == 0 then
      return
    end

    -- Run prettier and replace buffer content
    -- --stdin-filepath ensures prettier uses the right parser/config
    local file_path = vim.api.nvim_buf_get_name(args.buf)
    local view = vim.fn.winsaveview()
    
    vim.cmd("%!prettier --stdin-filepath " .. vim.fn.shellescape(file_path))
    
    -- If prettier returns an error (e.g. syntax error), undo the change
    if vim.v.shell_error ~= 0 then
      vim.cmd("undo")
      print("Prettier: formatting failed (check syntax)")
    end
    
    vim.fn.winrestview(view)
  end,
})
