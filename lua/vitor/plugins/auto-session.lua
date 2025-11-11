-- ~/.config/nvim/lua/vitor/plugins/auto-session.lua
return {
    "rmagatti/auto-session",
    dependencies = {
        "nvim-telescope/telescope.nvim", -- Ensure telescope is a dependency
    },
    config = function()
        local auto_session = require("auto-session")

        -- Configure auto-session
        auto_session.setup({
            log_level = "error",
            auto_restore = true,
            auto_save = true,
            auto_create = true, -- Ensure new session files are created automatically
            bypass_save_filetypes = { "gitcommit" },
            enabled = true,
            root_dir = vim.fn.stdpath("data") .. "/sessions/",
            suppressed_dirs = { "~/", "~/Downloads", "~/Documents" },

            -- Git-related option: Include the current git branch name in the session name
            git_use_branch_name = true,

            -- Purge sessions older than 30 days (30 * 24 * 60 minutes)
            -- Requires Neovim version >= 0.10
            purge_after_minutes = 43200,

            -- Configure the session-lens picker options
            session_lens = {
                -- Use the picker_opts table to pass Telescope-specific settings
                picker_opts = {
                    -- This is where the path_display option needs to go
                    -- "tail": Shows only the last part of the path (e.g., /home/user/project -> project)
                    -- "hidden": Hides the path completely (shows only the session identifier, often the directory/branch name)
                    -- "shorten": Shortens the path (e.g., /home/user/very/long/path -> ~/v/l/path)
                    path_display = { "tail" }, -- Use "tail" to show the directory/branch name part clearly
                    -- Example for "hidden" style: path_display = { "hidden" },
                    -- Example for "shorten" style: path_display = { "shorten" },

                    -- You can add other Telescope options here if needed
                    -- theme = 'dropdown', -- Example: use dropdown theme
                    -- layout_config = { width = 0.8, height = 0.8 }, -- Example: custom layout
                },
                -- Ensure the Telescope extension is loaded on setup
                load_on_setup = true,
            },
        })

        -- Load the telescope extension provided by auto-session
        -- This is the correct way now that session-lens is integrated
        local telescope = require("telescope")
        telescope.load_extension("session-lens") -- auto-session now provides this extension internally

        -- Add keymaps
        local keymap = vim.keymap

        keymap.set("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "Restore session for cwd" })
        keymap.set("n", "<leader>ws", "<cmd>SessionSave<CR>", { desc = "Save session for cwd" })
        keymap.set("n", "<leader>wd", "<cmd>SessionDelete<CR>", { desc = "Delete session for cwd" })
        -- Use the integrated telescope picker from auto-session
        keymap.set("n", "<leader>sl", "<cmd>Telescope session-lens<CR>", { desc = "List sessions (Telescope)" })

        -- Expose the function globally for alpha if you still prefer the Lua call,
        -- though the command is now the standard way
        -- _G.open_sessions_picker = function()
        --     require("telescope").extensions["session-lens"]["search_session"]()
        -- end
    end,
}
