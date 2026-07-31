local M = {}

M.setup = function()
    vim.keymap.set("n", "<leader>n", M.new, {buffer = true})
    vim.keymap.set("n", "<leader>d", M.remove, {buffer = true})
    vim.keymap.set("n", "<leader>m", M.mkdir, {buffer = true})
    vim.keymap.set("n", "r", M.move, {buffer = true})
    vim.keymap.set("n", "a", ":edit %/", { buffer = true})
end

M.get_file_under_cursor = function()
    local bufname = vim.api.nvim_buf_get_name(0)
    local line = vim.api.nvim_get_current_line()
    return vim.fs.joinpath(bufname, line)
end

M.reload = function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>(nvim-dir-reload)", true, false, true), "m", false)
end

M.remove = function()
    local file = M.get_file_under_cursor()
    local bufname = vim.api.nvim_buf_get_name(0)

    local path = vim.fs.joinpath(bufname, file)

    local prompt = "you really want to remove: `" .. path .. "`? (y/n) "
    vim.ui.input({prompt = prompt}, function(choice)
        if choice == "y" then
            vim.fs.rm(path, { recursive = true })
        else
            return
        end
    end)

    M.reload()
end

M.move = function()
    if vim.bo.filetype ~= "directory" then
        return
    end

    local path = M.get_file_under_cursor()
    local prompt = "move from: " .. path .. " to: "

    vim.ui.input({prompt = prompt}, function(choice)
        if not choice then
            return
        end
        vim.cmd("!mv " .. path .. " " .. choice)
    end)

    M.reload()
end

M.mkdir = function()
    if vim.bo.filetype ~= "directory" then
        return
    end

    vim.ui.input({prompt = "mkdir: "}, function(choice)
        if not choice then
            return
        end

        vim.cmd("!mkdir -p " .. choice)
    end)
    M.reload()
end

M.new = function ()
    if vim.bo.filetype ~= "directory" then
        return
    end

    vim.ui.input({prompt = "file: "}, function(choice)
        if not choice then
            return
        end

        local bufname = vim.api.nvim_buf_get_name(0)
        local path = vim.fs.joinpath(bufname, choice)
        vim.cmd("!touch " .. path)
    end)

    M.reload()
end

return M
