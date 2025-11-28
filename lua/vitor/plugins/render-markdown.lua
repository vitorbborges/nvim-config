return {
    "MeanderingProgrammer/render-markdown.nvim",
    branch = "main",
    ft = { "markdown" },
    config = function()
        require("render-markdown").setup({
            win_options = {
                conceallevel = {
                    rendered = 3,
                },
                concealcursor = {
                    rendered = "n",
                },
            },
            -- Disable conceal for task lists
            conceal = {
                task_list = false, -- This is the key line
            },
        })
    end,
}
