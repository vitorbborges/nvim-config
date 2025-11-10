return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        "nvim-tree/nvim-web-devicons",
        "folke/todo-comments.nvim",
        {
            "nvim-telescope/telescope-project.nvim",
            config = function()
                require("telescope").load_extension("project")
            end,
        },
    },

    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")
        local transform_mod = require("telescope.actions.mt").transform_mod

        local trouble = require("trouble")
        local trouble_telescope = require("trouble.sources.telescope")

        local custom_actions = transform_mod({
            open_trouble_qflist = function(prompt_bufnr)
                trouble.toggle("quickfix")
            end,
        })

        telescope.setup({
            defaults = {
                path_display = { "smart" },
                mappings = {
                    i = {
                        ["<C-k>"] = actions.move_selection_previous,
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-q>"] = actions.send_selected_to_qflist + custom_actions.open_trouble_qflist,
                        ["<C-t>"] = trouble_telescope.open,
                    },
                },
            },
            extensions = {
                project = {
                    base_dirs = {
                        { "~/Desktop/Projects", max_depth = 10 },
                        { "~/Desktop/Education", max_depth = 10 },
                        { "~/Desktop/Programming", max_depth = 10 },
                    },
                    hidden_files = false,
                    auto_ignore = false,
                    theme = "dropdown",
                    detection_methods = { "pattern" },
                    patterns = { ".git" },

                    -- 👇 Add this custom function to control what happens on selection
                    on_project_selected = function(prompt_bufnr)
                        -- Get selected entry
                        local state = require("telescope.actions.state")
                        local selection = state.get_selected_entry()
                        local path = selection.path

                        -- Close telescope
                        require("telescope.actions").close(prompt_bufnr)

                        -- Change Neovim's working directory
                        vim.cmd("cd " .. vim.fn.fnameescape(path))

                        -- Notify user
                        vim.notify("Switched to project: " .. vim.fn.fnamemodify(path, ":~"))

                        -- Tell NvimTree to cd into the same directory
                        if package.loaded["nvim-tree"] then
                            vim.cmd("NvimTreeClose")
                            vim.cmd("NvimTreeCd")
                            -- Optionally reopen it if you auto-closed it
                            -- vim.cmd("NvimTreeOpen")
                        end
                    end,
                },
            },
            file_ignore_patterns = {}, -- optional: ignore node_modules, etc.
            layout_strategy = "horizontal",
            layout_config = {
                prompt_position = "top",
            },
            winblend = 0,
            sorting_strategy = "ascending",
            -- Automatically close after selection
            attach_mappings = function(_, map)
                map("i", "<CR>", actions.select_default + actions.center) -- keep this
                return true
            end,
        })

        telescope.load_extension("fzf")
        telescope.load_extension("project")

        -- set keymaps
        local keymap = vim.keymap

        keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
        keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
        keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
        keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
        keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
        keymap.set("n", "<leader>fp", "<cmd>Telescope project<cr>", { desc = "Find and open recent projects" })
    end,
}
