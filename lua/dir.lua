local M = {}

M.get_file_under_cursor = function()
    local bufname = vim.api.nvim_buf_get_name(0)
    local line = vim.api.nvim_get_current_line()
    return vim.fs.joinpath(bufname, line)
end

M.reload = function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>(nvim-dir-reload)", true, false, true), "m", false)
end

M.remove = function()
    local path = M.get_file_under_cursor()
    local prompt = "you really want to remove: `" .. path .. "`? (y/n) "
    vim.ui.input({prompt = prompt}, function(choice)
        if choice == "y" then
            local bufname = vim.api.nvim_buf_get_name(0)
            print(vim.fs.joinpath(bufname, path))
        end
    end)

    vim.fs.rm(path, { recursive = true })
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
