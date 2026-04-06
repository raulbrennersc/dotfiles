vim.pack.add ({{src="gh:saghen/blink.cmp", branch='v1'}})
require('blink.cmp').setup({
    fuzzy = { implementation = "lua" },
    completion = {
        documentation = {
            auto_show = true
        }
    }
})
