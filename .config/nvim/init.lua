-- bootstrap lazy.nvim, LazyVim and your plugins
vim.opt.title = true
local path = vim.fn.fnamemodify(vim.fn.getcwd(), ":~:t")
vim.opt.titlestring = " " .. path
require("config.lazy")

local stats = vim.uv.fs_stat(vim.fn.argv(0))
if stats and stats.type == "directory" then
  require("persistence").load()
end
