local M = {}

M.pluginSelectToRemove = function ()
    local list = vim.pack.get()
    local names = {}

    for _, p in ipairs(list) do
        table.insert(names, p.spec.name)
    end

    vim.ui.select(names, { prompt = "delete: "}, function (name)
        vim.pack.del({name})
    end)
end

M.pluginUpdate = function ()
    vim.pack.update()
end

M.get_license = function ()
    vim.ui.input({ prompt = "license: "}, function (license)
        vim.cmd("!cp ~/doc/licenses/" .. license .. ".txt LICENSE")
    end)
end

M.run_command = function(args)
    local arg = 'term'

    vim.cmd.new()
    vim.cmd.wincmd("J")

    if (args['args']) then
        arg = arg .. ' ' .. args['args']
    end

    if (#arg == 5) then
        vim.cmd("startinsert")
    end

    vim.cmd(arg)
end

M.white = function ()
    vim.cmd("%s/\t/    /g")
end

M.quotes = function (d)
    local args = d.args

    local cmd = "%s/'/\"/g"

    -- vim.inspect(print(args))
    if (args == "c") then
        cmd = cmd .. "c"
    end

    vim.cmd(cmd)
end

M.notes = function ()
    local dir = "~/not"
    vim.cmd("e " .. dir)
    --vim.cmd("cd " .. dir)
end

vim.api.nvim_create_user_command("Cmd", M.run_command, { nargs = "*" })
vim.api.nvim_create_user_command("T", M.run_command, { nargs = "*" })
vim.api.nvim_create_user_command("License", M.get_license, {})
vim.api.nvim_create_user_command("White", M.white, {})
vim.api.nvim_create_user_command("Quotes", M.quotes, { nargs = "*" })
vim.api.nvim_create_user_command("Packrm", M.pluginSelectToRemove, { nargs = "*" })
vim.api.nvim_create_user_command("Packup", M.pluginUpdate, {})

return M
