local utils = require('ceceppa.utils')

function display_git_output(output)
    utils.show_popup("Git output", output)
end

local function execute_git_command(description, args, then_callback)
    vim.ceceppa.current_git_action = description

    utils.execute_command('git', description, args, function()
        if then_callback then
            then_callback()
        end

        utils.trigger_event('UpdateGitStatus')
        vim.ceceppa.current_git_action = nil
    end)
end

function get_commit_message()
    local prompt = "Prepend: ! = Force push | ~ = Push with no verify | ? = Push with no verify and force push"
    local input = vim.fn.input(prompt .. "\nEnter the commit message: ")
    local original_input = input

    if string.len(input) == 0 then
        return nil
    end

    if input:sub(1, 1) == '!' or input:sub(1, 1) == '~' or input:sub(1, 1) == '?' then
        input = input:sub(2)
    end

    return { input, original_input }
end

local function get_push_or_commit_params(input, can_force)
    local git_params = {}

    if not input then
        return git_params
    end

    if input:sub(1, 1) == '!' and can_force then
        table.insert(git_params, '--force')
    elseif input:sub(1, 1) == '~' then
        if not can_force then
            return '--no-verify'
        end

        table.insert(git_params, '--no-verify')
    elseif input:sub(1, 1) == '?' then
        table.insert(git_params, '--no-verify')

        if can_force then
            table.insert(git_params, '--force')
        else
            return '--no-verify'
        end
    end

    if not can_force then
        return nil
    end

    return git_params
end

vim.keymap.set('n', '<leader>gw', ':G blame<CR>', { desc = '@: Git praise' });

function git_pull(description, args)
    args = args or {}
    description = description or 'pull'

    local pull_command = { 'pull' }

    for _, arg in ipairs(args) do
        table.insert(pull_command, arg)
    end

    execute_git_command(description, pull_command, function()
        -- if package.json exists
        if vim.fn.filereadable('package.json') == 1 then
            utils.execute_command(vim.ceceppa.package_manager, 'install', { 'install' })
        end
    end)
end

function git_push(input)
    local push_params = get_push_or_commit_params(input, true)

    table.insert(push_params, 1, 'push')
    execute_git_command('push', push_params)
end

function git_get_main_repo_name()
    -- os shell command
    local command = [[git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@']]
    local repo_name = vim.fn.system(command)

    repo_name = repo_name:gsub("^%s*(.-)%s*$", "%1")

    return repo_name
end

vim.keymap.set('n', '<leader>gi', function() git_pull() end, { desc = '@: Git pull' });
vim.keymap.set('n', '<leader>go', function() git_push() end, { desc = '@: Git push' });
vim.keymap.set('n', '<leader>gO', function() git_push('~') end, { desc = '@: Git push --no-verify' });
vim.keymap.set('n', '<leader>gF', function() git_push('?') end, { desc = '@: Git push --force --no-verify' });
vim.keymap.set('n', '<leader>gU', function()
    local repo_name = git_get_main_repo_name()

    execute_git_command('pull rebase ' .. repo_name, { 'rebase', repo_name })
end, { desc = '@: Git pull origin main branch' });
vim.keymap.set('n', '<leader>gu', function()
    local repo_name = git_get_main_repo_name()

    git_pull('pull origin ' .. repo_name, { 'origin', repo_name })
end, { desc = '@: Git pull origin main branch' });
vim.keymap.set('n', '<leader>gn', ':G checkout -b ', { desc = '@: Git checkout new branch' });
vim.keymap.set('n', '<leader>gd', ':GitGutterDiff<cr>', { desc = '@: Git diff' });
vim.keymap.set('n', '<leader>gs', vim.cmd.Git, { desc = '@: Git status' });
vim.keymap.set('n', '<leader>gf', function() execute_git_command('fetch', { 'fetch', '-a' }) end,
    { desc = '@: Git fetch' });
vim.keymap.set('n', '<leader>gm', function()
    local repo_name = git_get_main_repo_name()

    execute_git_command('checkout ' .. repo_name, { 'checkout', repo_name }, function()
        git_pull()
    end)
end, { desc = '@: Git checkout main branch' });
vim.keymap.set('n', '<leader>gv', ':Gvdiffsplit!<CR>', { desc = '@: Git diff' });

vim.keymap.set('n', '<leader>gg', ':LazyGit<CR>', { desc = '@: Open LazyGit' });
vim.keymap.set('n', '<leader>gh', ':LazyGitFilterCurrentFile<CR>', { desc = '@: Git file history' });
vim.keymap.set('n', '<leader>gl', ':LazyGitFilter<CR>', { desc = '@: Git history' });
vim.keymap.set('n', '<leader>gr', function()
    local handle = io.popen([[
        git remote -v | head -n 1 | awk '{print $2}' | 
        sed -E 's#(git@|https://)#https://#' |
        sed -E 's#\.git$##'
    ]])
    if handle then
        local result = handle:read("*a")
        handle:close()
        result = result:gsub("%s+", "") -- Remove any whitespace
        if result ~= "" then
            vim.fn.system({"open", result})
        else
            print("Failed to get repository URL")
        end
    else
        print("Failed to execute git command")
    end
end, { desc = '@: Git open remote repository in Browser' })

vim.keymap.set('n', '<leader>gc', ':Telescope git_commits<CR>', { desc = '@: Git commits' });

function git_fetch_and_branches()
    print('Git branches: Waiting for fetching...')

    execute_git_command('fetch', { 'fetch', '-a' }, function()
        vim.cmd('Telescope git_branches')
    end)
end

vim.keymap.set('n', '<leader>gb', function() git_fetch_and_branches() end, { desc = '@: Git branches' });

vim.keymap.set('n', '<leader>gsl', ':Telescope git_stash<CR>', { desc = '@: Git stash' });

function git_add_all_and_commit()
    local input = get_commit_message()

    if not input then
        return
    end


    execute_git_command("adding all commit", { 'commit', '-am', input[1] },
        function()
            git_push(input[2])
        end)
end

vim.keymap.set('n', '<leader>g.', [[<Cmd>lua git_add_all_and_commit()<CR>]], { desc = '@: Git add all and commit' });

local function maybe_write_and_close_window()
    local current_buffer_name = vim.fn.bufname(vim.fn.bufnr('%'))

    if string.find(current_buffer_name, "fugitive") then
        local input = get_commit_message()

        if not input then
            return
        end

        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-o>:wq<CR>', true, true, true), 'n', true)

        local params = { 'commit', '-m', input[1] }
        local extra_params = get_push_or_commit_params(input[2], false)

        if extra_params then
            table.insert(params, extra_params)
        end

        execute_git_command("commit with message", params,
            function()
                git_push(input[2])
            end)
    end
end

local function git_stash_with_name()
    local input = vim.fn.input("Stash name: ")

    if string.len(input) == 0 then
        return
    end

    execute_git_command("stash with name", { 'stash', 'push', '-m', input })
end


vim.keymap.set('n', ';', function()
    maybe_write_and_close_window()
end, { desc = '@: Git: Write commit message and push' });

vim.keymap.set('n', '<leader>gss', function()
    git_stash_with_name()
end, { desc = '@: Git: stash with name' });
