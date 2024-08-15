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
