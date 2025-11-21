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

vim.api.nvim_create_user_command("Cmd", M.run_command, { nargs = "*" })
vim.api.nvim_create_user_command("T", M.run_command, { nargs = "*" })
vim.api.nvim_create_user_command("License", M.get_license, {})
vim.api.nvim_create_user_command("White", M.white, {})
vim.api.nvim_create_user_command("Notes", M.notes, { nargs = "*" })

return M
