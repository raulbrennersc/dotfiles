vim.pack.add({
  "gh:williamboman/mason.nvim",
  "gh:williamboman/mason-lspconfig.nvim",
  "gh:neovim/nvim-lspconfig",
})

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "eslint",
    "vtsls",
  },
})

vim.lsp.enable("lua_ls")
vim.lsp.enable("eslint")
vim.lsp.enable("vtsls")

vim.lsp.enable("nixd", {
  settings = {
    nixd = {
      nixpkgs = {
        expr = "import <nixpkgs> { }",
      },
      formatting = {
        command = { "nixfmt" },
      },
    },
  },
})

vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP code action" })
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "LSP code diagnostics" })
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "Format current buffer" })
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "LSP Rename", buffer = bufnr })

-- Autocomplete
vim.o.autocomplete = true
vim.o.autocompletedelay = 250
vim.o.completeopt = "menuone,noselect,fuzzy"
vim.o.complete = "o"

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "Enable LSP completion source",
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client:supports_method("textDocument/completion") then
      vim.bo[args.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
    end
  end,
})
