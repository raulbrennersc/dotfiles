require("vim._core.ui2").enable({})
local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.expandtab = true
opt.shiftwidth = 2
opt.smartindent = true
opt.termguicolors = true
opt.signcolumn = "yes:1"
opt.swapfile = false
opt.confirm = true
opt.smoothscroll = true

opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.lsp.foldexpr()"
opt.foldtext = "v:lua.vim.lsp.foldtext()"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true

opt.ignorecase = true
opt.smartcase = true

opt.clipboard = "unnamedplus"
