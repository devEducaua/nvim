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

M.white = function ()
    vim.cmd("%s/\t/    /g")
end

M.quotes = function (d)
    local args = d.args

    local cmd = "%s/'/\"/g"

    if (args == "c") then
        cmd = cmd .. "c"
    end

    vim.cmd(cmd)
end

vim.api.nvim_create_user_command("License", M.get_license, {})
vim.api.nvim_create_user_command("White", M.white, {})
vim.api.nvim_create_user_command("Quotes", M.quotes, { nargs = "*" })
vim.api.nvim_create_user_command("Packrm", M.pluginSelectToRemove, { nargs = "*" })
vim.api.nvim_create_user_command("Packup", M.pluginUpdate, {})

return M
