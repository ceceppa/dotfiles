require("ceceppa")

-- Disable Ctrl-Z suspension
vim.api.nvim_set_keymap('n', '<C-Z>', '<Nop>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-Z>', '<Nop>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-Z>', '<Nop>', { noremap = true, silent = true })
