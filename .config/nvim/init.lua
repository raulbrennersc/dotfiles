-- bootstrap lazy.nvim, LazyVim and your plugins
vim.opt.title = true
local path = vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
-- vim.opt.titlestring = "\u{e62b} " .. path
-- vim.opt.titlestring = "\u{e7c5} " .. path
vim.opt.titlestring = "\u{f36f} " .. path
require("config.lazy")
vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  paste = {
    ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
    ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
  },
}
