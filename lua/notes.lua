
local M = {}

local config = {
    headers = {"***", "**", "*"},
    todos = {"[x]", "[ ]"}
}

M.setup = function(c)
    config = vim.tbl_extend("force", config, c)
end

local advance_cursor = function(n)
    vim.api.nvim_win_set_cursor(0, {vim.fn.line("."), n+2})
end

local is_header = function(line)
    for _,p in ipairs(config.headers) do
        if vim.startswith(line, p .. " ") then
            return p, true
        end
    end

    return "", false
end

local modify_header = function(default, inc)
    local line = vim.api.nvim_get_current_line()

    local p, ok = is_header(line)

    local new

    local s = p
    if ok then
        if inc and #s < #config.headers then
            s = s .. config.headers[#config.headers]
        elseif not inc and #s > 1 then
            s = s:sub(1, -2)
        else
            s = default
        end
        new = line:gsub(p, s, 1)
    else
        new = default .. " " .. line
    end

    advance_cursor(#s)
    vim.api.nvim_set_current_line(new)
end

M.increase_header = function()
    modify_header(config.headers[#config.headers], true)
end

M.decrease_header = function()
    modify_header(config.headers[1], false)
end

M.toggle_todo = function()
    local line = vim.api.nvim_get_current_line()

    local new
    local m = config.todos[1]
    local n = config.todos[2]
    local offset = 0

    if line:match("^" .. vim.pesc(n)) then
        new = line:gsub(vim.pesc(n), m, 1)
        offset = #m
    elseif line:match("^" .. vim.pesc(m)) then
        new = line:gsub(vim.pesc(m), n, 1)
        offset = #n
    else
        new = n .. " " .. line
        offset = #n
    end

    advance_cursor(offset)
    vim.api.nvim_set_current_line(new)
end

return M
