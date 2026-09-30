vim.api.nvim_create_autocmd("PackChanged", {
  desc = "Automatically build blink.cmp when added or updated",
  callback = function(args)
    if args.data and args.data.name == "blink.cmp" then
      require("blink.cmp").build()
    end
  end,
})

vim.pack.add({
  { src = "https://github.com/saghen/blink.lib" },
  { src = "https://github.com/saghen/blink.cmp" },
})

local cmp = require("blink.cmp")

cmp.setup({
  keymap = { preset = "default", ["<CR>"] = { "accept", "fallback" } },
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },
  completion = {
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
      window = {
        border = "rounded",
      },
    },
  },
})
