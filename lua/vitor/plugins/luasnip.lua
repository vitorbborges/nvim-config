-- ~/.config/nvim/lua/vitor/plugins/luasnip.lua
return {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    dependencies = {
        "rafamadriz/friendly-snippets",
    },
    config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
        local ls = require("luasnip")

        vim.keymap.set("i", "<C-K>", function()
            ls.expand()
        end, { silent = true })
        vim.keymap.set("i", "<C-L>", function()
            ls.jump(1)
        end, { silent = true })
        vim.keymap.set("i", "<C-J>", function()
            ls.jump(-1)
        end, { silent = true })
    end,
}
