return {
    {
      "nvim-lualine/lualine.nvim",
      event = "VeryLazy",
      dependencies = {
        "SmiteshP/nvim-navic", -- Navigational helper using lspconfig
    },
      opts = function(_, opts)
        local icons = require("lazyvim.config").icons
        local Util = require("lazyvim.util")
  
        opts.sections.lualine_c = {}
        opts.sections.lualine_x = {
          {
            "diff",
            symbols = {
              added = icons.git.added,
              modified = icons.git.modified,
              removed = icons.git.removed,
            },
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
          },
          {
            require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
            color = Util.ui.fg("Special"),
          },
        }
  
        opts.winbar = {
          lualine_a = {
            { "filetype", icon_only = true, icon = { align = "left" }, color = {bg = '#1e1e2e'}, separator = { right = '' }  },
          },
          lualine_b = {
            {"filename",},
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
            },
            
          },
          lualine_c = { {
            function()
              return require("nvim-navic").get_location()
            end,
            cond = function()
              return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
            end,
          }},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {},
      }
        return opts
      end,
    },
  }