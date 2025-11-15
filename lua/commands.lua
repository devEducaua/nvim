local M = {}

M.get_path = function(file)
    local dir = require("oil").get_current_dir(vim.api.nvim_get_current_buf())
    print("dir: ", dir)
    local temp_path = dir .. "/" .. file
    local full_path = string.gsub(temp_path, "//", "/")

    local pwd = vim.fn.getcwd()
    local local_path = string.gsub(full_path, pwd .. "/", "")

    return local_path
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

M.permissions = function()
    local file = M.get_path(require("oil").get_cursor_entry().name)
    vim.ui.input({ prompt = "permissions: "}, function (perm)
        vim.cmd("!chmod " .. perm .. " " .. file)
    end)
end

M.command = function ()
    vim.ui.input({ prompt = "command: "}, function (cmd)
        local file = M.get_path(require("oil").get_cursor_entry().name) or " "

        if cmd then

            cmd = cmd:gsub("%%", file)

            cmd = "term " .. cmd

            vim.cmd.new()
            vim.cmd.wincmd("J")

            vim.cmd(cmd)
        end
    end)
end

M.man = function ()
    vim.ui.input({ prompt = "man: "}, function (page)
        vim.cmd("Man " .. page)
        vim.cmd.wincmd("L")
    end)
end

M.gopher = function ()
    vim.ui.input({ prompt = "gopher://" }, function (url)
        local cmd = "term sacc " .. url

        vim.cmd.vnew()
        vim.cmd.wincmd("L")

        -- vim.cmd(cmd)

        vim.fn.termopen("sacc " .. url, {
            on_exit = function (_, _, _)
                vim.schedule(function ()
                    if vim.api.nvim_win_is_valid(0) then
                        vim.cmd("bd!")
                    end
                end)
            end
        })
    end)
end

local commands = {
    executable = "./&f",
    video = "mpv &f",
    audio = "mpv &f",
    image = "feh &f",
    pdf = "zathura &f",
    html = "xdg-open &f"
}

M.exec_by_name = function (name)
    name = M.get_path(name)
    local cmd
    local ext = name:match("%.[^%.]+$")

    local dict = {
        ['.html'] = commands.html,
        ['.sh'] = commands.executable,
        ['.mkv'] = commands.video,
        ['.mp4'] = commands.video,
        ['.avi'] = commands.video,
        ['.mp3'] = commands.audio,
        ['.ogg'] = commands.audio,
        ['.flac'] = commands.audio,
        ['.png'] = commands.image,
        ['.jpg'] = commands.image,
        ['.webp'] = commands.image,
        ['.pdf'] = commands.pdf,
    }

    if ext == nil then
        cmd = commands.executable
    else
        cmd = dict[ext]
    end

    cmd = string.gsub(cmd, "&f", name)

    if (name == "Makefile") then
        vim.cmd(":Cmd make")
    else
        vim.cmd("Cmd " .. cmd)
    end
end

M.white = function ()
    vim.cmd("%s/\t/    /g")
end

M.notes = function ()
    vim.cmd("e ~/notes")
    vim.cmd("cd ~/notes")
end

-- M.git = function (d)
--     local args = d.args
--
--     vim.cmd("!git " .. args)
-- end

vim.api.nvim_create_user_command("Cmd", M.run_command, { nargs = "*" })
vim.api.nvim_create_user_command("T", M.run_command, { nargs = "*" })
vim.api.nvim_create_user_command("Mp", M.man, { nargs = "*" })
vim.api.nvim_create_user_command("License", M.get_license, {})
vim.api.nvim_create_user_command("Gopher", M.gopher, {})
vim.api.nvim_create_user_command("White", M.white, {})
vim.api.nvim_create_user_command("Notes", M.notes, { nargs = "*" })
-- vim.api.nvim_create_user_command("Git", M.git, { nargs = "*" })

return M
