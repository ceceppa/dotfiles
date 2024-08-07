-- disable netrw at the very start of your init.lua (strongly advised)
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup()

-- OR setup with some options
require("nvim-tree").setup({
    sort_by = "case_sensitive",
    view = {
        width = 40,
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = false,
    },
})

vim.api.nvim_set_keymap('n', '<leader>ft', ':NvimTreeToggle<CR>', { noremap = true, desc = 'Toggle file tree' })
vim.api.nvim_set_keymap('n', '<leader>fc', ':NvimTreeClose<CR>', { noremap = true, desc = 'Close file tree' })
vim.api.nvim_set_keymap('n', '<leader>ff', ':NvimTreeFindFile<CR>', { noremap = true, desc = 'Show file in tree' })
