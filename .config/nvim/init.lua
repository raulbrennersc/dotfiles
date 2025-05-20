vim.g.sessions_path = vim.fn.stdpath("state") .. "/sessions/"  
vim.g.session_name = vim.fn.getcwd():gsub("[\\/:]+", "%%")

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
require("config.lazy")

vim.lsp.enable({'luals'})

local stats = vim.uv.fs_stat(vim.fn.argv(0))
if stats and stats.type == "directory" then
	local session_file = vim.fn.fnameescape(vim.g.sessions_path .. vim.g.session_name .. ".vim")
	if vim.fn.filereadable(vim.fn.expand(session_file)) ~= 0 then
		vim.cmd("source " .. session_file)
	end
end


local foo = {bar="bar",baz="baz"}
