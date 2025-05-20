vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
	vim.cmd("mksession! " .. vim.fn.fnameescape(vim.g.sessions_path .. vim.g.session_name .. ".vim"))
    end,
  })

