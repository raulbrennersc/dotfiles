-- Native autocompletion
vim.opt.completeopt = { "menuone", "noselect", "popup" }
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

-- Autocompletion with blink
-- vim.api.nvim_create_autocmd("PackChanged", {
--   desc = "Automatically build blink.cmp when added or updated",
--   callback = function(args)
--     if args.data and args.data.name == "blink.cmp" then
--       require("blink.cmp").build()
--     end
--   end,
-- })
--
-- vim.pack.add({
--   { src = "https://github.com/saghen/blink.lib" },
--   { src = "https://github.com/saghen/blink.cmp" },
-- })
--
-- local cmp = require("blink.cmp")
--
-- cmp.setup({
--   keymap = { preset = "default", ["<CR>"] = { "accept", "fallback" } },
--   sources = {
--     default = { "lsp", "path", "snippets", "buffer" },
--   },
--   completion = {
--     documentation = {
--       auto_show = true,
--       auto_show_delay_ms = 200,
--       window = {
--         border = "rounded",
--       },
--     },
--   },
-- })
