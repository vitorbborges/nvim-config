-- ~/.config/nvim/lua/vitor/plugins/obsidian.lua

-- Define options table as a local variable to be accessible in the custom function
local obsidian_opts = {
    dir = "~/Obsidian", -- The path to your Obsidian vault.
    -- Optional: set an icon for Obsidian files
    -- icon = "", -- Example: Nerd Font icon for YouTube
    -- customize how notes are created
    daily_notes = {
        folder = "06 - Daily",
        date_format = "%Y-%m-%d",
        template = "(TEMPLATE) Daily.md",
    },
    new_notes_location = "05 - Fleeting", -- All new notes go to Fleeting for future organizing
    note_id_func = function(title)
        -- Generate a unique ID for the note based on the current date and a counter
        local date = os.date("%y-%m-%d")
        local counter = 1 -- You might need a more robust way to get a daily counter
        -- For now, let's just use a simple counter. In a real setup, you'd query existing notes.
        return string.format("%s-%d-%s", date, counter, title)
    end,
    templates = {
        folder = "99 - Meta/00 - Templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
    },
    -- Optional: Configure markdown preview
    -- This assumes you have a markdown previewer like 'glow' or 'vifm' configured.
    -- For 'glow', you might use:
    -- ui = {
    --   enable = true,
    --   update_debounce = 200,
    --   markdown_ext_pattern = { ".md", ".markdown" },
    --   default_markdown_renderer = "glow",
    -- },
}

-- Custom function to create a daily note with a weekday CSS class.
local function create_daily_note_with_weekday()
    -- Get the path to the vault.
    -- Note: We construct the path manually from the config to be safer.
    local config = obsidian_opts
    local vault_path = vim.fn.expand(config.dir)

    -- Get daily note settings.
    local daily_opts = config.daily_notes
    local folder = daily_opts.folder
    local date_format = daily_opts.date_format
    local template_name = daily_opts.template

    -- Get today's date and weekday.
    local date_str = os.date(date_format)
    local weekday = os.date("%A"):lower() -- %A is full weekday name, e.g., "monday"

    -- Construct the file path for the new note.
    local file_path = vault_path .. "/" .. folder .. "/" .. date_str .. ".md"

    -- Check if the note already exists.
    local f = io.open(file_path, "r")
    if f then
        -- Note exists, just open it.
        f:close()
        vim.cmd("e " .. file_path)
        return
    end

    -- Note doesn't exist, create it from the template.
    -- Get template path.
    local template_path = vault_path .. "/" .. config.templates.folder .. "/" .. template_name

    -- Read template content.
    local template_file = io.open(template_path, "r")
    if not template_file then
        vim.notify("Template file not found: " .. template_path, vim.log.levels.ERROR)
        return
    end
    local template_content = template_file:read("*a")
    template_file:close()

    -- Replace placeholders.
    local content = template_content
    content = content:gsub("{{title}}", date_str)
    content = content:gsub("{{date}}", os.date("%Y-%m-%d"))
    content = content:gsub("{{time}}", os.date("%H:%M"))
    content = content:gsub("{{weekday}}", weekday)

    -- Write the new note.
    local new_file = io.open(file_path, "w")
    if not new_file then
        vim.notify("Failed to create daily note: " .. file_path, vim.log.levels.ERROR)
        return
    end
    new_file:write(content)
    new_file:close()

    -- Open the new note.

        vim.cmd("e " .. file_path)

    end

    

    return {
        "epwalsh/obsidian.nvim",
        branch = "main", -- recommended to use latest release
        dependencies = {
            -- Required for fzf support
            "nvim-telescope/telescope.nvim",
            -- Required for markdown preview and other features
            "nvim-treesitter/nvim-treesitter",
        },
        opts = obsidian_opts,
        keys = {
            -- Keymaps for obsidian.nvim
            { "<leader>on", "<cmd>ObsidianNew<CR>", desc = "Obsidian New Note" },
            -- MODIFIED: Use our custom function for daily notes.
            {
                "<leader>ot",
                function()
                    create_daily_note_with_weekday()
                end,
                desc = "Obsidian Today's Note (Weekday CSS)",
            },
            { "<leader>of", "<cmd>ObsidianQuickSwitch<CR>", desc = "Obsidian Quick Switch" },
            { "<leader>os", "<cmd>ObsidianSearch<CR>", desc = "Obsidian Search" },
            { "<leader>ol", "<cmd>ObsidianLink<CR>", desc = "Obsidian Link" },
            { "<leader>ob", "<cmd>ObsidianBacklinks<CR>", desc = "Obsidian Backlinks" },
            { "<leader>oo", "<cmd>ObsidianOpen<CR>", desc = "Obsidian Open" },
            { "<leader>og", "<cmd>ObsidianTags<CR>", desc = "Obsidian Tags" },
            { "<leader>oc", "<cmd>ObsidianDailies<CR>", desc = "Obsidian Dailies" },
            -- You can add more keymaps as needed
        },
    }

    