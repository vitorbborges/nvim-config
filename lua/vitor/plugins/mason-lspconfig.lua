-- ~/.config/nvim/lua/vitor/plugins/mason-lspconfig.lua
return {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
        "neovim/nvim-lspconfig",
        "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
        -- Delay setup to ensure all modules are ready
        vim.schedule(function()
            local mason_lspconfig = require("mason-lspconfig")
            local cmp_nvim_lsp = require("cmp_nvim_lsp")
            local keymap = vim.keymap

            -- ✅ Install LSP servers
            mason_lspconfig.setup({
                ensure_installed = { "lua_ls", "pyright", "clangd" },
            })

            -- 🔧 Set up LSP keymaps on attach
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                callback = function(ev)
                    local opts = { buffer = ev.buf, silent = true }

                    opts.desc = "Show LSP references"
                    keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

                    opts.desc = "Go to declaration"
                    keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

                    opts.desc = "Show LSP definitions"
                    keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

                    opts.desc = "Show LSP implementations"
                    keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

                    opts.desc = "Show LSP type definitions"
                    keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

                    opts.desc = "See available code actions"
                    keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

                    opts.desc = "Smart rename"
                    keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

                    opts.desc = "Show buffer diagnostics"
                    keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

                    opts.desc = "Show line diagnostics"
                    keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

                    opts.desc = "Go to previous diagnostic"
                    keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

                    opts.desc = "Go to next diagnostic"
                    keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

                    opts.desc = "Show documentation"
                    keymap.set("n", "K", vim.lsp.buf.hover, opts)

                    opts.desc = "Restart LSP"
                    keymap.set("n", "<leader>rs", "<cmd>LspRestart<CR>", opts)
                end,
            })

            -- 🔸 Diagnostic signs
            local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
            end

            -- 🔸 Capabilities for cmp
            local capabilities = cmp_nvim_lsp.default_capabilities()

            -- 🔸 Configure servers using the NEW API (vim.lsp.config)
            -- Lua Server
            vim.lsp.config("lua_ls", {
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } },
                        completion = { callSnippet = "Replace" },
                    },
                },
            })

            -- Enable all servers installed by Mason
            -- Instead of using setup_handlers, manually enable them
            vim.lsp.enable("lua_ls")
            vim.lsp.enable("pyright")
            vim.lsp.enable("clangd")

            -- If you need to customize other servers, do it here
            -- vim.lsp.config("pyright", { ... })
            -- vim.lsp.config("clangd", { ... })
        end)
    end,
}
