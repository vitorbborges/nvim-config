-- catppuccin/nvim: A soothing pastel theme for Neovim.
-- This plugin provides the Catppuccin color scheme, which is designed to be
-- easy on the eyes while maintaining clarity. It comes in four "flavors":
-- Latte, Frappé, Macchiato, and Mocha. The current setup uses the "Mocha" flavor.
-- The plugin offers deep integration with many other plugins for a cohesive look.
-- For more information, see: https://github.com/catppuccin/nvim
return {
    "catppuccin/nvim",
    as = "catppuccin",
    priority = 1000,
    config = function()
        require("catppuccin").setup({
            flavour = "mocha",
            transparent_backgorund = true,
            integrations = {
                nvimtree = false,
            },
        })

        vim.cmd("colorscheme catppuccin-mocha")
    end,
}
