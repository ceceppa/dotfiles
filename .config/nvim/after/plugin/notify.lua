require("notify").setup({
    max_width = 80,
    foreground_colour = "#20ffa0",
    render = "compact",
    top_down = false,
    on_open = function(win)
        vim.api.nvim_win_set_config(win, { focusable = false })
    end,
})

vim.opt.termguicolors = true
vim.notify = require("notify")
