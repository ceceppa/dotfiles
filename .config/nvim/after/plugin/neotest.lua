vim.keymap.set('n', '<leader>tf', function()
    local neotest = require("neotest")

    neotest.run.run(vim.fn.expand("%"))
    neotest.summary.open()
end, { desc = '@: Run test for current file' })
vim.keymap.set('n', '<leader>tp', function() require("neotest").output_panel.toggle() end,
    { desc = '@: Toggle output panel' })
vim.keymap.set('n', '<leader>ts', function() require("neotest").summary.toggle() end,
    { desc = '@: Toggle summary panel' })
vim.keymap.set('n', '<leader>to', function()
        require("neotest").output.open({ enter = true })
    end,
    { desc = '@: Open test output window' })
