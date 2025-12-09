--[[
conform.nvim is a lightweight and powerful Neovim plugin for code formatting.
Its core purpose is to provide an efficient and flexible way to format code
using various external formatters, while also addressing common issues like
preserving Neovim's state (extmarks, folds) during formatting.

Key concepts and examples:

*   **Efficient Formatting**: Instead of formatters replacing the entire buffer,
    conform.nvim calculates minimal differences (diffs) and applies only those changes.
    Example: Formatting a large file will only modify the lines that need it,
    keeping your cursor position stable.

*   **Universal Range Formatting**: Even if an external formatter doesn't natively
    support formatting only a selected range of code, conform.nvim can simulate this.
    Example: Select a few lines of Python code in visual mode, then trigger a
    conform.nvim range format.

*   **Simple API**: It provides a straightforward Lua API, making it easy to integrate.
    Example: `require("conform").format({ bufnr = vim.api.nvim_get_current_buf() })` formats the current buffer.

*   **`format_on_save`**: Automatically formats your code every time you save a file.
    Example: Setting `format_on_save = { lsp_format = "fallback" }` will format
    your file on save using available formatters and falling back to LSP if no others are found.
--]]
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
            end, { desc = "<leader>mp - Format current file (normal mode) or selected range (visual mode)" })
        end,
    },
}
