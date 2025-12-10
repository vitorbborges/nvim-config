--[[
gitsigns.nvim is a Neovim plugin that provides powerful Git integration
directly within your editor buffers. Its main purpose is to visualize Git changes
(additions, modifications, deletions) in the sign column, and offer a rich set of
actions to interact with these changes, such as staging, resetting, and previewing
"hunks" (blocks of changes). It also provides blame information and diffing capabilities.

Key concepts and examples:

*   **Signs**: Visual indicators in the editor's sign column (the far left column)
    that show the status of lines relative to your Git repository.
    Example: A `+` sign indicates a new line, `~` indicates a changed line,
    and `_` indicates a deleted line.

*   **Hunks**: A contiguous block of changes (additions, modifications, or deletions)
    in your file. gitsigns.nvim allows you to interact with these hunks individually.
    Example: If you've modified three separate functions in a file, gitsigns.nvim will
    identify them as three distinct hunks. You can then stage just one of these hunks
    using a command like `:GitsignsStageHunk`.

*   **Blame**: Shows who last modified each line of code, along with the commit hash and timestamp.
    Example: Running `:GitsignsBlameLine` might show `lewis6991 2023-01-15 (main.lua:10)`
    next to a line, indicating the author, date, and original line number.
--]]
return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        on_attach = function(bufnr)
            local gs = package.loaded.gitsigns

            local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
            end

            -- Navigation
            map("n", "]h", function() gs.next_hunk() end, { desc = "]h - Jump to the next Git hunk (e.g., ]h)" })
            map("n", "[h", function() gs.prev_hunk() end, { desc = "[h - Jump to the previous Git hunk (e.g., [h)" })

            -- Actions
            map("n", "<leader>hs", function() gs.stage_hunk() end, { desc = "<leader>hs - Stage the current Git hunk (e.g., <leader>hs)" })
            map("n", "<leader>hr", function() gs.reset_hunk() end, { desc = "<leader>hr - Reset the current Git hunk (e.g., <leader>hr)" })
            map("v", "<leader>hs", function()
                gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end, { desc = "<leader>hs - Stage selected lines as a hunk (e.g., v<leader>hs)" })
            map("v", "<leader>hr", function()
                gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end, { desc = "<leader>hr - Reset selected lines in a hunk (e.g., v<leader>hr)" })

            map("n", "<leader>hS", function() gs.stage_buffer() end, { desc = "<leader>hS - Stage all changes in the current buffer (e.g., <leader>hS)" })
            map("n", "<leader>hR", function() gs.reset_buffer() end, { desc = "<leader>hR - Reset all changes in the current buffer (e.g., <leader>hR)" })

            map("n", "<leader>hu", function() gs.undo_stage_hunk() end, { desc = "<leader>hu - Undo the last staged hunk (e.g., <leader>hu)" })

            map("n", "<leader>hp", function() gs.preview_hunk() end, { desc = "<leader>hp - Preview the changes in the current hunk (e.g., <leader>hp)" })

            map("n", "<leader>hb", function()
                gs.blame_line({ full = true })
            end, { desc = "<leader>hb - Show Git blame info for the current line (e.g., <leader>hb)" })
            map("n", "<leader>hB", function() gs.toggle_current_line_blame() end, { desc = "<leader>hB - Toggle inline Git blame details (e.g., <leader>hB)" })

            map("n", "<leader>hd", function() gs.diffthis() end, { desc = "<leader>hd - Diff current buffer against HEAD (e.g., <leader>hd)" })
            map("n", "<leader>hD", function()
                gs.diffthis("~")
            end, { desc = "<leader>hD - Diff current buffer against the index (e.g., <leader>hD)" })

            -- Text object
            map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "ih - Select inner Git hunk as a text object (e.g., dih to delete inner hunk)" })
        end,
    },
}
