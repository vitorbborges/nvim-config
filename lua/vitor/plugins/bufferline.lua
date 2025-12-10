-- bufferline.nvim: A stylish buffer line for Neovim.
-- This plugin creates a line at the top of the editor that displays your open
-- buffers as tabs, similar to a web browser or GUI text editor. It helps you
-- visualize and manage your open files efficiently.
--
-- Key Features:
-- - Displays open buffers in a single line for easy navigation.
-- - Integrates with LSP to show diagnostic indicators (errors, warnings) per buffer.
-- - Supports hover events for buffer details and offers various styling options.
-- - Allows grouping, sorting, and pinning of buffers.
-- - Highly customizable appearance and behavior.
--
-- For more information and configuration options, see: https://github.com/akinsho/bufferline.nvim
return {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    version = "*",
    opts = {
        options = {
            mode = "tabs",
            diagnostics = "nvim_lsp", -- Show LSP diagnostics
            hover = {
                enabled = true,
                delay = 200,
                reveal = { "close" },
            },
            indicators = {
                buffer_number = true,
                modified = {
                    buffer_index = false,
                    file_icon = false,
                },
                diagnostics = {
                    buffer_index = false,
                    file_icon = false,
                },
            },
            -- You can also enable underline indicator like this, though terminal support varies
            -- (see :h bufferline-styling for more details)
            -- style_preset = { "underline", "slanted" },
        },
    },
}
