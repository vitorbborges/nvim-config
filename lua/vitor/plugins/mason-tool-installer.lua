-- ~/.config/nvim/lua/vitor/plugins/mason-tool-installer.lua
return {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
        local ok, mti = pcall(require, "mason-tool-installer")
        if not ok then
            vim.notify("Failed to load mason-tool-installer", vim.log.levels.ERROR)
            return
        end

        mti.setup({
            ensure_installed = {
                "prettier",
                "stylua",
                "black",
                "isort",
                "ruff",
                "clang-format",
                "sql-formatter",
                "jupytext",
                "markdownlint",
                "ast-grep",
            },
            -- Optional: Add this to avoid permission issues with /home/vitor/projects
            -- You can set a different root directory if needed
            -- root_dir = vim.fn.stdpath("data") .. "/mason-tools",
        })
    end,
}
