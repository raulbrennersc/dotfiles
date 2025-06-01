local path = vim.fn.fnamemodify(vim.fn.getcwd(), ":~:t")
vim.opt.title = true
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.titlestring = " " .. path

for _, source in ipairs {
  "lazy",
    "options",
    "keymaps",
    "autocmds",
} do
    local ok, fault = pcall(require, "config." .. source)
    if not ok then vim.api.nvim_err_writeln("Failed to load " .. source .. "\n\n" .. fault) end
end

local stats = vim.uv.fs_stat(vim.fn.argv(0))
if stats and stats.type == "directory" then
  require("persistence").load()
end
