-- ~/.config/nvim/lua/vitor/plugins/telescope.lua
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
                    order_by = "recent",
                    search_by = "title",
                    detection_methods = { "pattern" },
                    patterns = { ".git" },

                    on_project_selected = function(prompt_bufnr)
                        local state = require("telescope.actions.state")
                        local selection = state.get_selected_entry()
                        local path = selection.path

                        require("telescope.actions").close(prompt_bufnr)

                        -- Change directory to project
                        vim.cmd("cd " .. vim.fn.fnameescape(path))

                        -- Open nvim-tree for the project
                        if package.loaded["nvim-tree"] then
                            local api = require("nvim-tree.api")
                            api.tree.open({ path = path })
                        end

                        vim.notify("Opened project: " .. vim.fn.fnamemodify(path, ":~"), vim.log.levels.INFO)
                    end,
                },
            },
            file_ignore_patterns = {},
            layout_strategy = "horizontal",
            layout_config = {
                prompt_position = "top",
            },
            winblend = 0,
            sorting_strategy = "ascending",
            attach_mappings = function(_, map)
                map("i", "<CR>", actions.select_default + actions.center)
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
