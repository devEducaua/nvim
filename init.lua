require("lsp")
require("keymaps")
require("commands")
require("plugins")

vim.cmd("set termguicolors")
vim.cmd("syntax enable")
vim.cmd("colorscheme oradark")
vim.cmd [[ highlight Whitespace guifg=#1e1e1e ]]
vim.cmd [[ highlight NonText guifg=#1e1e1e ]]

vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.swapfile = false
vim.o.showmode = false
vim.o.cmdheight = 1
vim.o.winborder = "rounded"
vim.o.pumborder = "rounded"
vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.o.path = vim.o.path .. "**"
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.fileignorecase = true
vim.o.wildignorecase = true
vim.o.wildmenu = true
vim.o.wildignorecase = true
vim.o.wildoptions = "fuzzy"
vim.o.wildmode = "longest:full,full"
vim.o.wildignore = vim.o.wildignore .. "*/node_modules/*"
vim.opt.iskeyword:remove("_")

function _G.my_find(text, _)
    local files = vim.fn.glob("**/*", true, true)
    return vim.fn.matchfuzzy(files, text)
end

vim.opt.findfunc = "v:lua.my_find"

vim.opt.list = true
vim.opt.listchars = {
    space = "•",
    tab = "▸ ",
    extends = '❯',
    precedes = '❮',
    nbsp = '␣',
}
vim.opt.fillchars = { eob = " ", vert = " ", horiz = " " }

function Git_branch()
    local handle = io.popen('git rev-parse --abbrev-ref HEAD 2>/dev/null')
    if not handle then return '' end
    local result = handle:read("*a")
    handle:close()

    result = result:gsub("\n", "")
    if result ~= '' and result ~= ' ' then
        return 'at •' .. result .. '•'
    end
    return ''
end

local statusline = {
    '%t',
    '%r',
    ' %{v:lua.Git_branch()}',
    '%m',
    '%=',
    '%{&filetype}',
    ' •',
    '%3l:%-2c ',
    -- '• ',
    -- "%{v:lua.os.date('%d/%m %a %H:%M')} ",
}

vim.o.statusline = table.concat(statusline, '')

vim.diagnostic.config({
    virtual_lines = {
        current_line = true,
    },
    -- virtual_text = {
    --     current_line = true
    -- }
})

vim.api.nvim_create_autocmd('BufEnter', {
    pattern = { "*.md", "*.tex" },
    callback = function ()
        vim.o.linebreak = true
    end
})

vim.filetype.add({
    extension = {
        njk = "jinja"
    }
})

vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
	pattern = "*",
	desc = "highlight selection on yank",
	callback = function()
		vim.highlight.on_yank({ timeout = 200, visual = true })
	end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "help", "man" },
    command = "wincmd L"
})
