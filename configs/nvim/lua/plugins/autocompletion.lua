-- Native autocompletion
vim.opt.completeopt = { "menuone", "noselect", "popup", "fuzzy" }
vim.o.pumborder = "rounded"

vim.api.nvim_set_hl(0, "Pmenu", { link = "NormalFloat" })
vim.api.nvim_set_hl(0, "PmenuBorder", { link = "FloatBorder" })
vim.api.nvim_set_hl(0, "PmenuSel", { link = "Visual" })

vim.api.nvim_create_autocmd("CompleteChanged", {
  desc = "Add border to native completion documentation window",
  callback = function()
    vim.schedule(function()
      local info = vim.fn.complete_info({ "selected", "preview_winid" })
      local winid = info.preview_winid
      if winid and winid >= 0 and vim.api.nvim_win_is_valid(winid) then
        pcall(vim.api.nvim_win_set_config, winid, { border = "rounded" })
      end
    end)
  end,
})

vim.keymap.set("i", "<CR>", function()
  if vim.fn.pumvisible() ~= 0 then
    return "<C-y>"
  else
    return "<CR>"
  end
end, { expr = true })

vim.keymap.set("i", "<C-Space>", function()
  vim.lsp.completion.get()
end, { desc = "Trigger LSP completion" })

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client:supports_method("textDocument/completion") then
      local chars = {}
      for i = 32, 126 do
        table.insert(chars, string.char(i))
      end
      if client.server_capabilities.completionProvider then
        client.server_capabilities.completionProvider.triggerCharacters = chars
      end
      vim.lsp.completion.enable(true, client.id, args.buf, {
        autotrigger = true,
        convert = function(item)
          return {
            menu = "",
            info = item.detail,
          }
        end,
      })
    end
  end,
})
