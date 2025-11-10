-- ~/.config/nvim/lua/vitor/plugins/mason.lua
return {
    "mason-org/mason.nvim",
    cmd = "Mason",
    keys = {
        { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
    },
    opts = {
        ui = {
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗",
            },
        },
    },
}
