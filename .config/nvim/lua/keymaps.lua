local map = vim.keymap.set

vim.g.mapleader = " "

map("n", "<leader>pv", vim.cmd.Ex, { desc = "File explorer" })
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })
