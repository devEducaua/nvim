local M = {}

M.setup = function()
    vim.pack.add({"file:///home/indu/sou/nwm"})
    require("nxwm").setup({
        delhidden=true,
        unfocus_map="<M-c>",
        ---@diagnostic disable-next-line: unused-local
        on_win_open=function (buf,xwin)
            vim.cmd.enew()
            vim.api.nvim_set_current_buf(buf)
        end,
    })

    vim.api.nvim_create_user_command("Launch", M.launch, {nargs = "+", complete ="shellcmd"})
end

M.autostart = function(commands)
    for _,c in ipairs(commands) do
        vim.fn.jobstart(c, {detach = true})
    end
end

M.launch = function (d)
    local args = d.args
    vim.fn.jobstart(args, {detach = true})
end

return M
