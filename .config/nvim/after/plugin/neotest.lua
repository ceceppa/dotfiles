vim.keymap.set('n', '<leader>tf', function()
    local neotest = require("neotest")

    neotest.run.run(vim.fn.expand("%"))
    neotest.summary.open()
end, { desc = '@: Run test for current file' })
vim.keymap.set('n', '<leader>tp', function() require("neotest").summary.toggle() end,
    { desc = '@: Toggle summary panel' })
vim.keymap.set('n', '<leader>to', function()
        require("neotest").output.open({ enter = true })
    end,
    { desc = '@: Open test output window' })
vim.keymap.set('n', '<leader>tc', function()
    print("Running current test")
require("neotest").run.run()
    end,
    { desc = '@: Run current test' })
