local builtin_plugins = {
    { "nvim-lua/plenary.nvim" },
    -- Telescope
    -- Find, Filter, Preview, Pick. All lua, all the time.
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
            },
        },
        cmd = "Telescope",
        config = function(_)
            require("telescope").setup({
            pickers= {
            find_files = {
            hidden=true
          }
        }
      })
            -- To get fzf loaded and working with telescope, you need to call
            -- load_extension, somewhere after setup function:
            require("telescope").load_extension "fzf"
            require "plugins.configs.telescope"
        end,
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function() require("which-key").setup() end,
    },
      {
        -- Rose-pine - Soho vibes for Neovim
        "rose-pine/neovim",
        name = "rose-pine",
        opts = {
            dark_variant = "main",
        },
    },
    {
        "nvim-lualine/lualine.nvim",
        opts = function() require "plugins.configs.lualine" end,
    },
    -- require "plugins.configs.lualine",
    -- colorscheme
    require "plugins.configs.colorscheme",


}

local exist, custom = pcall(require, "custom")
local custom_plugins = exist and type(custom) == "table" and custom.plugins or {}

-- Check if there is any custom plugins
-- local ok, custom_plugins = pcall(require, "plugins.custom")
require("lazy").setup {
    spec = { builtin_plugins, custom_plugins },
    lockfile = vim.fn.stdpath "config" .. "/lazy-lock.json", -- lockfile generated after running update.
    defaults = {
        lazy = false, -- should plugins be lazy-loaded?
        version = nil,
        -- version = "*", -- enable this to try installing the latest stable versions of plugins
    },
    ui = {
        icons = {
            ft = "",
            lazy = "󰂠",
            loaded = "",
            not_loaded = "",
        },
    },
    install = {
        -- install missing plugins on startup
        missing = true,
        -- try to load one of these colorschemes when starting an installation during startup
        colorscheme = { "adfjkasdflkj" },
    },
    checker = {
        -- automatically check for plugin updates
        enabled = true,
        -- get a notification when new updates are found
        -- disable it as it's too annoying
        notify = false,
        -- check for updates every day
        frequency = 86400,
    },
    change_detection = {
        -- automatically check for config file changes and reload the ui
        enabled = true,
        -- get a notification when changes are found
        -- disable it as it's too annoying
        notify = false,
    },
    performance = {
        cache = {
            enabled = true,
        },
    },
    state = vim.fn.stdpath "state" .. "/lazy/state.json", -- state info for checker and other things
}

