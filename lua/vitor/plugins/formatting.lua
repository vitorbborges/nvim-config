return {
    {
        "stevearc/conform.nvim",
        branch = "nvim-0.9",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local conform = require("conform")
            conform.setup({
                formatters_by_ft = {
                    json = { "prettier" },
                    yaml = { "prettier" },
                    markdown = { "prettier" },
                    lua = { "stylua" },
                    python = { "ruff_organize_imports", "ruff_format", "isort", "black" },
                    bibtex = { "bibtex-tidy" },
                    latex = { "latexindent" },
                    sql = { "sql-formatter" },
                    rust = { "rustfmt" },
                    c = { "clang-format" },
                    cpp = { "clang-format" },
                },
                format_on_save = {
                    lsp_fallback = true,
                    async = false,
                    timeout_ms = 1000,
                },
            })

            vim.keymap.set({ "n", "v" }, "<leader>mp", function()
                conform.format({
                    lsp_fallback = true,
                    async = false,
                    timeout_ms = 1000,
                })
            end, { desc = "Format file or range (in visual mode)" })
        end,
    },
}
