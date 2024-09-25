-- disable netrw at the very start of your init.lua (strongly advised)
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup()

local width = 40

require("nvim-tree").setup({
    sort_by = "case_sensitive",
    view = {
        width = width,
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = false,
    },
})

local function toggle_width()
    if width == 40 then
        width = 80
    else
        width = 40
    end

    vim.cmd("NvimTreeResize " .. width)
end

vim.api.nvim_set_keymap('n', '<leader>ft', ':NvimTreeToggle<CR>', { noremap = true, desc = 'Toggle file tree' })
vim.api.nvim_set_keymap('n', '<leader>fc', ':NvimTreeClose<CR>', { noremap = true, desc = 'Close file tree' })
vim.api.nvim_set_keymap('n', '<leader>ff', ':NvimTreeFindFile<CR>', { noremap = true, desc = 'Show file in tree' })
vim.keymap.set('n', '<leader>fw', toggle_width, { noremap = true, silent = true, desc = "Yank all text" })
