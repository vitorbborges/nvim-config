return {
    "kylechui/nvim-surround",
    event = { "BufReadPre", "BufNewFile" },
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
        require("nvim-surround").setup()

        local wk = require("which-key")
        wk.add({
            { "ys", desc = "ys{motion}{char} - Add surrounding (e.g., ysiw)", mode = "n" },
            { "ds", desc = "ds{char} - Delete surrounding (e.g., ds')", mode = "n" },
            { "cs", desc = "cs{target}{replacement} - Change surrounding (e.g., cs'\" to change ' to \")", mode = "n" },
            { "S", desc = 'S{char} - Surround visual selection (e.g., S" for "selection")', mode = "v" },
        })
    end,
}
