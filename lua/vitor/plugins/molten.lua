-- ~/.config/nvim/lua/vitor/plugins/molten.lua
return {
    "benlubas/molten-nvim",
    version = "^1.0.0",
    dependencies = { "3rd/image.nvim" },
    build = ":UpdateRemotePlugins",
    init = function()
        -- ✅ CORRECT path based on your `which python` output
        local python_host = vim.fn.expand("~/.local/share/mamba/envs/nvim/bin/python")

        -- Optional: verify it exists
        if vim.fn.executable(python_host) == 0 then
            vim.notify("Python host not found: " .. python_host, vim.log.levels.ERROR)
        else
            vim.g.python3_host_prog = python_host
        end

        -- Rest of your Molten config...
        vim.g.molten_image_provider = "image.nvim"
        vim.g.molten_output_win_max_height = 20
        vim.g.molten_auto_open_output = false
        vim.g.molten_virt_text_output = true
        vim.g.molten_virt_lines_off_by_1 = true
        vim.g.molten_output_virt_lines = true
        vim.g.molten_wrap_output = true

        -- Extend PATH to include mamba base (optional but helpful)
        vim.env.PATH = vim.fn.expand("~/.local/share/mamba/bin") .. ":" .. vim.env.PATH
    end,
    config = function()
        -- Keybindings for Molten
        vim.keymap.set("n", "<localleader>mi", ":MoltenInit<CR>", { silent = true, desc = "Initialize Molten" })

        vim.keymap.set(
            "n",
            "<localleader>e",
            ":MoltenEvaluateOperator<CR>",
            { silent = true, desc = "Evaluate operator selection" }
        )

        vim.keymap.set("n", "<localleader>rl", ":MoltenEvaluateLine<CR>", { silent = true, desc = "Evaluate line" })

        vim.keymap.set(
            "n",
            "<localleader>rr",
            ":MoltenReevaluateCell<CR>",
            { silent = true, desc = "Re-evaluate cell" }
        )

        vim.keymap.set(
            "v",
            "<localleader>r",
            ":<C-u>MoltenEvaluateVisual<CR>gv",
            { silent = true, desc = "Evaluate visual selection" }
        )

        vim.keymap.set("n", "<localleader>rd", ":MoltenDelete<CR>", { silent = true, desc = "Delete cell" })

        vim.keymap.set("n", "<localleader>oh", ":MoltenHideOutput<CR>", { silent = true, desc = "Hide output" })

        vim.keymap.set(
            "n",
            "<localleader>os",
            ":noautocmd MoltenEnterOutput<CR>",
            { silent = true, desc = "Show/enter output" }
        )

        -- Import/Export for .ipynb files
        vim.keymap.set(
            "n",
            "<localleader>ip",
            ":MoltenImportOutput<CR>",
            { silent = true, desc = "Import output from ipynb" }
        )

        vim.keymap.set(
            "n",
            "<localleader>ex",
            ":MoltenExportOutput<CR>",
            { silent = true, desc = "Export output to ipynb" }
        )

        -- Save/Load Molten state
        vim.keymap.set("n", "<localleader>ms", ":MoltenSave<CR>", { silent = true, desc = "Save Molten state" })

        vim.keymap.set("n", "<localleader>ml", ":MoltenLoad<CR>", { silent = true, desc = "Load Molten state" })

        -- Navigation between cells
        vim.keymap.set("n", "]c", ":MoltenNext<CR>", { silent = true, desc = "Next cell" })

        vim.keymap.set("n", "[c", ":MoltenPrev<CR>", { silent = true, desc = "Previous cell" })

        -- Kernel management
        vim.keymap.set("n", "<localleader>kr", ":MoltenRestart<CR>", { silent = true, desc = "Restart kernel" })

        vim.keymap.set("n", "<localleader>ki", ":MoltenInterrupt<CR>", { silent = true, desc = "Interrupt kernel" })

        vim.keymap.set("n", "<localleader>kd", ":MoltenDeinit<CR>", { silent = true, desc = "Deinit Molten" })

        -- Optional: Auto-import outputs when opening .ipynb files
        -- Uncomment if you want automatic import after MoltenInit
        -- vim.api.nvim_create_autocmd("User", {
        --   pattern = "MoltenInitPost",
        --   callback = function()
        --     vim.cmd("MoltenImportOutput")
        --   end,
        -- })
    end,
}
