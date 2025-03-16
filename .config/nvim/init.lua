-- bootstrap lazy.nvim, LazyVim and your plugins
vim.opt.title = true
local path = vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
-- vim.opt.titlestring = "\u{e62b} " .. path
-- vim.opt.titlestring = "\u{e7c5} " .. path
vim.opt.titlestring = "\u{f36f} " .. path
require("config.lazy")
require("persistence").load()
