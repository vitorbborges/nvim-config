return {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local lint = require("lint")

        lint.linters_by_ft = {
            python = { "ruff" },
            yaml = { "yamllint" },
            markdown = { "markdownlint" },
            json = { "jsonlint" },
            c = { "cpplint" },
            cpp = { "cpplint" },
        }

        local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
            group = lint_augroup,
            callback = function()
                lint.try_lint()
            end,
        })

        vim.keymap.set("n", "<leader>l", function()
            lint.try_lint()
        end, { desc = "Trigger linting for current file" })

        -- Default: Hide inline warnings but keep yellow signs
        local warnings_enabled = false

        vim.diagnostic.config({
            virtual_text = false, -- Hide inline warnings (text boxes)
            signs = true, -- Keep yellow signs in the left gutter
            underline = false, -- Remove underlines for warnings
            float = { source = "always" }, -- Keep floating diagnostics
        })

        -- Function to toggle inline warnings while keeping signs
        function ToggleWarnings()
            if warnings_enabled then
                vim.diagnostic.config({
                    virtual_text = false, -- Hide inline text
                    signs = true, -- Keep signs
                    underline = false, -- No underline warnings
                })
                print("Inline warnings hidden")
            else
                vim.diagnostic.config({
                    virtual_text = { severity = { min = vim.diagnostic.severity.WARN } }, -- Show inline warnings
                    signs = true, -- Keep signs
                    underline = true, -- Restore underline warnings
                })
                print("Inline warnings shown")
            end
            warnings_enabled = not warnings_enabled
        end

        -- Keymap to toggle inline warnings
        vim.keymap.set("n", "<leader>vw", ToggleWarnings, { desc = "Toggle inline warnings" })
    end,
}
