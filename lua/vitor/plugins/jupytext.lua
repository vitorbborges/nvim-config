-- ~/.config/nvim/lua/vitor/plugins/jupytext.lua
return {
    {
        "GCBallesteros/jupytext.nvim",
        lazy = false,
        config = function()
            -- Make Neovim see jupytext from the mamba "nvim" env
            local nvim_env_bin = vim.fn.expand("~/.local/share/mamba/envs/nvim/bin")
            vim.env.PATH = nvim_env_bin .. ":" .. vim.env.PATH

            require("jupytext").setup({
                style = "markdown",
                output_extension = "md",
                force_ft = "markdown",
                -- optional but very explicit:
                -- cmd = nvim_env_bin .. "/jupytext",
            })
        end,
    },
}
