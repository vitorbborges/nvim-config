-- ~/.config/nvim/lua/vitor/core/keymaps.lua
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- Keymap: Create a new tmux vertical pane at the bottom of the session
-- This assumes Neovim is running *inside* a tmux session.
keymap.set("n", "<leader>tt", function()
    -- Use tmux to create a new vertical split (-v) with a specific height (-l 20)
    -- and run the shell inside the current directory of the Neovim buffer.
    -- The -c flag sets the working directory for the new shell.
    -- Adjust -l 20 to your preferred initial height percentage if needed.
    local tmux_cmd = string.format("tmux split-window -v -l 20 -c %s", vim.fn.shellescape(vim.fn.getcwd()))
    -- Execute the system command to run the tmux command
    vim.fn.system(tmux_cmd)
end, { desc = "Create new Tmux vertical pane (20% height) in current dir" })
