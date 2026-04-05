local function load(name)
    local ok, err = pcall(vim.pack.add, name)
    if not ok then
        vim.notify("Failed to load plugin: " .. name .. "\n" .. err, vim.log.levels.ERROR)
    end
end

local plugins = {
    "nvim-treesitter",
}

for _, plugin in ipairs(plugins) do
    load(plugin)
end

require('nvim-treesitter.configs').setup({
    ensure_installed = { "lua", "vim", "vimdoc" },
    highlight = { enable = true },
})
