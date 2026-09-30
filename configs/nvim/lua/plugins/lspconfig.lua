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
