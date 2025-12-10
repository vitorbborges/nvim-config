-- alpha-nvim: A fast and fully programmable greeter for Neovim.
-- This plugin provides a customizable start screen (greeter) for Neovim.
-- It's built to be fast and allows for extensive configuration through themes.
-- The current setup uses the "dashboard" theme to provide quick access to common actions.
-- For more information, see: https://github.com/goolord/alpha-nvim
return {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        -- Set header
        dashboard.section.header.val = {
            "                                   ",
            "                                   ",
            "                                   ",
            "   ⣴⣶⣤⡤⠦⣤⣀⣤⠆     ⣈⣭⣿⣶⣿⣦⣼⣆          ",
            "    ⠉⠻⢿⣿⠿⣿⣿⣶⣦⠤⠄⡠⢾⣿⣿⡿⠋⠉⠉⠻⣿⣿⡛⣦       ",
            "          ⠈⢿⣿⣟⠦ ⣾⣿⣿⣷    ⠻⠿⢿⣿⣧⣄     ",
            "           ⣸⣿⣿⢧ ⢻⠻⣿⣿⣷⣄⣀⠄⠢⣀⡀⠈⠙⠿⠄    ",
            "          ⢠⣿⣿⣿⠈    ⣻⣿⣿⣿⣿⣿⣿⣿⣿⣛⣳⣤⣀⣀   ",
            "   ⢠⣧⣶⣥⡤⢄ ⣸⣿⣿⠘  ⢀⣴⣿⣿⡿⠛⣿⣿⣧⠈⢿⠿⠟⠛⠻⠿⠄  ",
            "  ⣰⣿⣿⠛⠻⣿⣿⡦⢹⣿⣷   ⢊⣿⣿⡏  ⢸⣿⣿⡇ ⢀⣠⣄⣾⠄   ",
            " ⣠⣿⠿⠛ ⢀⣿⣿⣷⠘⢿⣿⣦⡀ ⢸⢿⣿⣿⣄ ⣸⣿⣿⡇⣪⣿⡿⠿⣿⣷⡄  ",
            " ⠙⠃   ⣼⣿⡟  ⠈⠻⣿⣿⣦⣌⡇⠻⣿⣿⣷⣿⣿⣿ ⣿⣿⡇ ⠛⠻⢷⣄ ",
            "      ⢻⣿⣿⣄   ⠈⠻⣿⣿⣿⣷⣿⣿⣿⣿⣿⡟ ⠫⢿⣿⡆     ",
            "       ⠻⣿⣿⣿⣿⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⡟⢀⣀⣤⣾⡿⠃     ",
            "                                   ",
        }

        -- Set menu
        dashboard.section.buttons.val = {
            -- Icon: 📝 (Pencil - for new file)
            dashboard.button("e", " 📝 New File", "<cmd>ene<CR>"),
            -- Icon: 📁 (Open Folder - for find project)
            dashboard.button("SPC fp", " 📁 Find Project", "<cmd>Telescope project<CR>"),
            -- Icon: 🔄 (Clockwise Arrows - for recent sessions)
            dashboard.button("SPC sl", " 🔄 Recent Sessions", "<cmd>Telescope session-lens<CR>"),
            -- Icon: 📚 (Books - for recent files)
            dashboard.button("SPC fr", " 📚 Recent Files", "<cmd>Telescope oldfiles<cr>"),
            -- Icon: ⚙️ (Gear - for configuration)
            dashboard.button("c", " ⚙️ Configure Neovim", "<cmd>cd ~/.config/nvim/ | NvimTreeOpen<CR>"),
            -- Icon: 🚪 (Door - for quit)
            dashboard.button("q", " 🚪 Quit NVIM", "<cmd>qa<CR>"),
        }

        -- Close alpha buffer after opening a project
        vim.api.nvim_create_autocmd("User", {
            pattern = "TelescopeProjectPost",
            callback = function()
                -- Find and close alpha buffer
                for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                    if vim.bo[buf].filetype == "alpha" then
                        vim.api.nvim_buf_delete(buf, { force = true })
                        break
                    end
                end
            end,
        })

        -- Send config to alpha
        alpha.setup(dashboard.opts)

        -- Disable folding on alpha buffer
        vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
    end,
}
