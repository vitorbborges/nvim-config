-- ~/.config/nvim/lua/vitor/plugins/nvim-tree.lua
return {
    "nvim-tree/nvim-tree.lua",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
        local nvimtree = require("nvim-tree")

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
                            arrow_closed = "",
                            arrow_open = "",
                        },
                    },
                },
            },
            sync_root_with_cwd = true,
            respect_buf_cwd = false,
            update_focused_file = {
                enable = true,
                update_root = false,
            },
            hijack_directories = {
                enable = false,
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

        -- Keymaps for tree management
        local keymap = vim.keymap

        keymap.set("n", "<leader>ee", function()
            local api = require("nvim-tree.api")
            api.tree.toggle({ find_file = true, focus = true })
        end, { desc = "Toggle file explorer" })

        keymap.set("n", "<leader>ef", function()
            local api = require("nvim-tree.api")
            api.tree.open()
            api.tree.focus()
        end, { desc = "Focus file explorer" })

        keymap.set("n", "<leader>er", function()
            local api = require("nvim-tree.api")
            api.tree.reload()
        end, { desc = "Refresh file explorer" })
    end,
}
