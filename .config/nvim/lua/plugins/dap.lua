local js_based_languages = {
  "typescript",
  "javascript",
}

local function get_pkg_path(pkg, path)
  pcall(require, "mason")
  local root = vim.env.MASON or (vim.fn.stdpath("data") .. "/mason")
  path = path or ""
  local ret = root .. "/packages/" .. pkg .. "/" .. path
  return ret
end

return {
  -- { "nvim-neotest/nvim-nio" },
  -- {
  --   "mfussenegger/nvim-dap",
  --   config = function()
  --     local dap = require("dap")
  --
  --     local Config = require("lazyvim.config")
  --     vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
  --
  --     for name, sign in pairs(Config.icons.dap) do
  --       sign = type(sign) == "table" and sign or { sign }
  --       vim.fn.sign_define(
  --         "Dap" .. name,
  --         { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
  --       )
  --     end
  --
  --     for _, language in ipairs(js_based_languages) do
  --       dap.configurations[language] = {
  --         -- Debug single nodejs files
  --         {
  --           type = "pwa-node",
  --           request = "launch",
  --           name = "Launch file",
  --           program = "${file}",
  --           cwd = vim.fn.getcwd(),
  --           sourceMaps = true,
  --         },
  --         -- Debug nodejs processes (make sure to add --inspect when you run the process)
  --         {
  --           type = "pwa-node",
  --           request = "attach",
  --           name = "Attach",
  --           -- processId = require("dap.utils").pick_process,
  --           -- cwd = vim.fn.getcwd(),
  --           port = "9229",
  --           sourceMaps = true,
  --           executable = {
  --             command = "node",
  --             args = {
  --               get_pkg_path("js-debug-adapter", "/js-debug/src/dapDebugServer.js"),
  --               "${port}",
  --             },
  --           },
  --         },
  --         -- Debug web applications (client side)
  --         {
  --           type = "pwa-chrome",
  --           request = "launch",
  --           name = "Launch & Debug Chrome",
  --           url = function()
  --             local co = coroutine.running()
  --             return coroutine.create(function()
  --               vim.ui.input({
  --                 prompt = "Enter URL: ",
  --                 default = "http://localhost:3000",
  --               }, function(url)
  --                 if url == nil or url == "" then
  --                   return
  --                 else
  --                   coroutine.resume(co, url)
  --                 end
  --               end)
  --             end)
  --           end,
  --           webRoot = vim.fn.getcwd(),
  --           protocol = "inspector",
  --           sourceMaps = true,
  --           userDataDir = false,
  --         },
  --         -- Divider for the launch.json derived configs
  --         {
  --           name = "----- ↓ launch.json configs ↓ -----",
  --           type = "",
  --           request = "launch",
  --         },
  --       }
  --     end
  --   end,
  --   keys = {
  --     {
  --       "<leader>dO",
  --       function()
  --         require("dap").step_out()
  --       end,
  --       desc = "Step Out",
  --     },
  --     {
  --       "<leader>do",
  --       function()
  --         require("dap").step_over()
  --       end,
  --       desc = "Step Over",
  --     },
  --     {
  --       "<leader>da",
  --       function()
  --         if vim.fn.filereadable(".vscode/launch.json") then
  --           local dap_vscode = require("dap.ext.vscode")
  --           dap_vscode.load_launchjs(nil, {
  --             ["pwa-node"] = js_based_languages,
  --             ["chrome"] = js_based_languages,
  --             ["pwa-chrome"] = js_based_languages,
  --           })
  --         end
  --         require("dap").continue()
  --       end,
  --       desc = "Run with Args",
  --     },
  --   },
  --   dependencies = {
  --   },
  -- },
}
