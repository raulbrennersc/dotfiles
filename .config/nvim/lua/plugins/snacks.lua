return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  keys = {
    {
      "<leader>e",
      function()
        Snacks.explorer({ hidden = true })
      end,
      desc = "File Explorer",
    },
    {
      "<leader>fF",
      function()
        Snacks.picker.smart()
      end,
      desc = "Smart Find Files",
    },
    { "<leader><space>", LazyVim.pick("files", { root = false, hidden = true }), desc = "Find Files (cwd)" },
  },
}
