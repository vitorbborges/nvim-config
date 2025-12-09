--[[
Comment.nvim is a plugin for Neovim that provides smart and powerful commenting functionalities.
It leverages Treesitter for language-aware commenting for both line and block comments,
and works seamlessly with motions and text-objects. It also supports:
- **Dot Repeat**: After performing a comment action (e.g., `<leader>c`), you can move to another line and press `.` to repeat the exact same commenting action.
- **Count Prefixes**: When using operator-pending mappings (like `gc`), you can precede the command with a number (e.g., `3gc`) to apply the comment action across multiple lines. For instance, `3gc` would toggle comments for 3 lines, or `gc3j` would toggle comments for the current line and the 3 lines below it.
--]]
return {
    "numToStr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function()
        -- import comment plugin safely
        local comment = require("Comment")

        local ts_context_commentstring = require("ts_context_commentstring.integrations.comment_nvim")

        -- enable comment
        comment.setup({
            -- for commenting tsx, jsx, svelte, html files
            pre_hook = ts_context_commentstring.create_pre_hook(),
        })

        local keymap = vim.keymap
        keymap.set("n", "<leader>c", function()
            require("Comment.api").toggle.linewise.current()
        end, { desc = "Toggle line comment for the current line (e.g. 'code' -> '//code')" })

        keymap.set("v", "<leader>c", function()
            require("Comment.api").toggle.linewise(vim.fn.visualmode())
        end, { desc = "Toggle line comment for the selected lines" })

        -- Block comments
        keymap.set("n", "<leader>C", function()
            require("Comment.api").toggle.blockwise.current()
        end, { desc = "Toggle block comment for the current line (e.g. 'code' -> '/* code */')" })
        keymap.set("v", "<leader>C", function()
            require("Comment.api").toggle.blockwise(vim.fn.visualmode())
        end, { desc = "Toggle block comment for the selected lines" })

        -- Operator-pending mapping for linewise comments, enabling dot repeat and count prefixes
        keymap.set('n', 'gc', '<Plug>(comment_toggle_linewise_op)', { desc = 'gc{motion} - Toggle line comment (e.g. gc2j)' })
    end,
}
