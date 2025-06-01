local path = vim.fn.fnamemodify(vim.fn.getcwd(), ":~:t")
vim.opt.title = true
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.titlestring = " " .. path

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

for _, source in ipairs {
    "plugins",
    "options",
    "keymaps",
    "autocmds",
} do
    local ok, fault = pcall(require, source)
    if not ok then vim.api.nvim_err_writeln("Failed to load " .. source .. "\n\n" .. fault) end
end

-- local stats = vim.uv.fs_stat(vim.fn.argv(0))
-- if stats and stats.type == "directory" then
--   require("persistence").load()
-- end
