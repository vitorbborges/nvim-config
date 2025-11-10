-- ~/.config/nvim/lua/vitor/plugins/nvim-tree.lua
return {
    "nvim-tree/nvim-tree.lua",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
        local nvimtree = require("nvim-tree")
        -- Disable built-in netrw
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        nvimtree.setup({
            view = {
                width = 35,
                relativenumber = true,
                preserve_window_proportions = true,
            },
            renderer = {
                indent_markers = {
                    enable = true,
                },
                icons = {
                    glyphs = {
                        folder = {
                            arrow_closed = "", -- arrow when folder is closed
                            arrow_open = "", -- arrow when folder is open
                        },
                    },
                },
            },
            actions = {
                open_file = {
                    window_picker = {
                        enable = false,
                    },
                    quit_on_open = false,
                },
            },
            -- ✅ CRITICAL: These settings make nvim-tree respect per-tab cwd
            hijack_directories = {
                enable = false, -- Don't auto-open tree when changing dir
            },
            sync_root_with_cwd = false, -- Don't sync tree root with global cwd changes
            respect_buf_cwd = false, -- Don't follow buffer changes
            update_focused_file = {
                enable = false, -- Don't auto-update tree when opening files
                update_root = false, -- Don't change tree root
            },
            filters = {
                custom = { ".DS_Store" },
            },
            git = {
                ignore = false,
            },
            on_attach = function(bufnr)
                local api = require("nvim-tree.api")
                local function opts(desc)
                    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
                end

                -- Default mappings
                vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open"))
                vim.keymap.set("n", "o", api.node.open.edit, opts("Open"))
                vim.keymap.set("n", "<2-LeftMouse>", api.node.open.edit, opts("Open"))
                vim.keymap.set("n", "v", api.node.open.vertical, opts("Open: Vertical Split"))
                vim.keymap.set("n", "h", api.node.open.horizontal, opts("Open: Horizontal Split"))
                vim.keymap.set("n", "t", api.node.open.tab, opts("Open: New Tab"))

                -- File operations
                vim.keymap.set("n", "a", api.fs.create, opts("Create"))
                vim.keymap.set("n", "d", api.fs.remove, opts("Delete"))
                vim.keymap.set("n", "r", api.fs.rename, opts("Rename"))
                vim.keymap.set("n", "x", api.fs.cut, opts("Cut"))
                vim.keymap.set("n", "c", api.fs.copy.node, opts("Copy"))
                vim.keymap.set("n", "p", api.fs.paste, opts("Paste"))

                -- Navigation
                vim.keymap.set("n", "P", api.node.navigate.parent, opts("Parent Directory"))
                vim.keymap.set("n", "K", api.node.navigate.sibling.first, opts("First Sibling"))
                vim.keymap.set("n", "J", api.node.navigate.sibling.last, opts("Last Sibling"))
                vim.keymap.set("n", "-", api.tree.change_root_to_parent, opts("Up"))
                vim.keymap.set("n", "s", api.tree.search_node, opts("Search"))

                -- Display
                vim.keymap.set("n", "R", api.tree.reload, opts("Refresh"))
                vim.keymap.set("n", "I", api.tree.toggle_gitignore_filter, opts("Toggle Git Ignore"))
                vim.keymap.set("n", "H", api.tree.toggle_hidden_filter, opts("Toggle Hidden"))
                vim.keymap.set("n", "U", api.tree.toggle_custom_filter, opts("Toggle Custom"))

                -- Other useful mappings
                vim.keymap.set("n", "y", api.fs.copy.filename, opts("Copy Name"))
                vim.keymap.set("n", "Y", api.fs.copy.relative_path, opts("Copy Relative Path"))
                vim.keymap.set("n", "gy", api.fs.copy.absolute_path, opts("Copy Absolute Path"))
                vim.keymap.set("n", "q", api.tree.close, opts("Close"))
                vim.keymap.set("n", "g?", api.tree.toggle_help, opts("Help"))
            end,
        })

        -- ✅ Per-tab nvim-tree state tracking
        local tab_trees = {}

        -- Store tree state when leaving a tab
        vim.api.nvim_create_autocmd("TabLeave", {
            callback = function()
                local current_tab = vim.api.nvim_get_current_tabpage()
                local tree_visible = vim.fn.bufname():match("NvimTree_") ~= nil

                -- Check if tree is open by looking for NvimTree buffer in any window
                for _, win in ipairs(vim.api.nvim_tabpage_list_wins(current_tab)) do
                    local buf = vim.api.nvim_win_get_buf(win)
                    if vim.bo[buf].filetype == "NvimTree" then
                        tree_visible = true
                        break
                    end
                end

                tab_trees[current_tab] = {
                    visible = tree_visible,
                    cwd = vim.fn.getcwd(-1, current_tab), -- Get tab-local cwd
                }
            end,
        })

        -- Restore tree state when entering a tab
        vim.api.nvim_create_autocmd("TabEnter", {
            callback = function()
                local current_tab = vim.api.nvim_get_current_tabpage()
                local tree_state = tab_trees[current_tab]

                -- Check if tree is currently visible
                local tree_visible = false
                for _, win in ipairs(vim.api.nvim_tabpage_list_wins(current_tab)) do
                    local buf = vim.api.nvim_win_get_buf(win)
                    if vim.bo[buf].filetype == "NvimTree" then
                        tree_visible = true
                        break
                    end
                end

                if tree_state then
                    -- Get the tab's cwd
                    local tab_cwd = vim.fn.getcwd(-1, current_tab)

                    -- If tree should be visible but isn't, open it
                    if tree_state.visible and not tree_visible then
                        vim.schedule(function()
                            require("nvim-tree.api").tree.open({ path = tab_cwd })
                        end)
                    -- If tree is visible but shouldn't be, close it
                    elseif not tree_state.visible and tree_visible then
                        vim.schedule(function()
                            require("nvim-tree.api").tree.close()
                        end)
                    -- If tree is visible and should be, update its root to tab's cwd
                    elseif tree_visible then
                        vim.schedule(function()
                            require("nvim-tree.api").tree.change_root(tab_cwd)
                        end)
                    end
                end
            end,
        })

        -- Enhanced keymaps that work with tab-local cwd
        local keymap = vim.keymap

        keymap.set("n", "<leader>ee", function()
            local api = require("nvim-tree.api")
            local current_tab = vim.api.nvim_get_current_tabpage()
            local tab_cwd = vim.fn.getcwd(-1, current_tab)

            -- Check if tree is open
            local tree_open = false
            for _, win in ipairs(vim.api.nvim_tabpage_list_wins(current_tab)) do
                local buf = vim.api.nvim_win_get_buf(win)
                if vim.bo[buf].filetype == "NvimTree" then
                    tree_open = true
                    break
                end
            end

            if tree_open then
                api.tree.close()
            else
                api.tree.open({ path = tab_cwd })
            end
        end, { desc = "Toggle file explorer (tab-local)" })

        keymap.set("n", "<leader>ef", function()
            local api = require("nvim-tree.api")
            local current_tab = vim.api.nvim_get_current_tabpage()
            local tab_cwd = vim.fn.getcwd(-1, current_tab)
            api.tree.open({ path = tab_cwd })
            api.tree.focus()
        end, { desc = "Focus file explorer (tab-local)" })

        keymap.set("n", "<leader>et", function()
            local api = require("nvim-tree.api")
            api.tree.find_file({ open = true, focus = true })
        end, { desc = "Find current file in explorer" })

        keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" })

        keymap.set("n", "<leader>er", function()
            local api = require("nvim-tree.api")
            local current_tab = vim.api.nvim_get_current_tabpage()
            local tab_cwd = vim.fn.getcwd(-1, current_tab)
            api.tree.change_root(tab_cwd)
            api.tree.reload()
        end, { desc = "Refresh file explorer (tab-local)" })
    end,
}
