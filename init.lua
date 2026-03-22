
vim.cmd.colorscheme("oradark");
vim.o.termguicolors = true
vim.o.syntax = "on"
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
vim.o.path = "**"
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
vim.o.omnifunc = "v:lua.vim.lsp.omnifunc"
vim.o.completeopt = "menuone,noselect"
vim.o.makeprg = "make --quiet"
vim.o.grepprg = "rg --vimgrep --smart-case --no-ignore --follow"

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
        return "• git::" .. result
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
}

vim.o.statusline = table.concat(statusline, '')

vim.diagnostic.config({
    virtual_lines = {
        current_line = true,
    },
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

local map = vim.keymap.set

map({"i", "v", "t"}, "jk", "<esc>")

map("t", "<esc>", "<c-\\><c-n>")
map("n", "<space>;", "q:", {})
map("t", "<A-q>", "<esc><esc>bd<CR>")

map("n", "<leader>ls", ":ls<CR>")
map("n", "<leader>b", ":b#<CR>")
map("n", "<leader>B", ":b ")
map("n", "<leader>f", ":find ")
map("n", "<leader>h", ":help ")

map("n", "<leader>c", ":copen<CR>")
map("n", "<leader>m", ":make<CR>")
map("n", "<leader>g", ":grep ")

map({"n", "v", "x", "c", "t"}, "<C-y>", '"+y', {})
map({"n", "v", "x", "c", "t"}, "<C-p>", '"+p', {})
map("i", "<C-p>", '<esc>"+pa')

map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "<C-f>", "<C-f>zz")
map("n", "<C-b>", "<C-b>zz")

map("n", "<leader>w", ":up<CR>", {})
map("n", "<leader>x", ":up<CR> :Oil<CR>", {})
map("n", "<leader>!", ":q!<CR>", {})
map("n", "<leader>q", ":bd!<CR>", {})
map("n", "<leader>s", ":w<CR>:so<CR>", {})

map("n", "-", "<cmd>Oil<CR>", {})

vim.api.nvim_create_autocmd("CmdwinEnter", {
  callback = function()
    map("n", "<Esc>", "<C-c>", { buffer = true, noremap = true })
  end,
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

vim.pack.add({
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/stevearc/oil.nvim",
})

require("nvim-treesitter.configs").setup({
    ensure_installed = { "c", "lua", "bash", "typescript", "html", "css", "javascript", "markdown", "go", "python" },
    sync_install = false,
    auto_install = false,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    indent = {
        enable = true,
        disable = { "html" }
    },
})

require("oil").setup({
    default_file_explorer = true,
    skip_confirm_for_simple_edits = true,
    watch_for_changes = true,
    view_options = {
        show_hidden = true,
    },
    columns = {
        "icon",
        "type",
        "permissions",
        "size",
        "mtime",
    },
    keymaps = {
        ["g."] = { "actions.toggle_hidden", mode = "n" },
        ["g,"] = { "actions.cd", mode = "n" },
    },
})

local servers = { "luals", "ts_ls", "clangd", "cssls", "texlab", "gopls" }
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        if client:supports_method('textDocument/implementation') then
            vim.keymap.set("n", "gli", vim.lsp.buf.implementation, { buffer = args.buf })
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = args.buf })
        end

        vim.keymap.set({ "n", "v", "x" }, "<leader>lf", vim.lsp.buf.format, {})
    end
})

vim.lsp.config["luals"] = {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = { "stylua.json", ".luarc.json", ".git" },
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim', 'love', 'core' }
            },
            workspace = {
                library = {
                    "/usr/share/luanti/builtin",
                    "/usr/share/luanti",
                    vim.env.VIMRUNTIME
                },
                checkThirdParty = true
            }
        }
    }
}

vim.lsp.config["ts_ls"] = {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = { "typescript", "javascript" },
    root_markers = { "node_modules/", "package.json", ".git" }
}

vim.lsp.config["tsgo"] = {
    cmd = { "tsgo", "--lsp", "--stdio" },
    filetypes = { "typescript", "javascript"},
    root_markers = { "node_modules", "package.json", "bun.lock" }
}

vim.lsp.config["clangd"] = {
    cmd = { "clangd" },
    filetypes = { "c", "cpp" },
    root_markers = { "Makefile", "include", ".git" }
}

vim.lsp.config["gopls"] = {
    cmd = { "gopls" },
    filetypes = { "go", "gomod" },
    root_markers = { "go.mod", "go.sum" }
}

vim.lsp.config["cssls"] = {
    cmd = { "vscode-css-language-server", "--stdio" },
    filetypes = { "css", "scss", "less" },
    root_markers = { "package.json", ".git" }
}

vim.lsp.config["texlab"] = {
    cmd = { "texlab" },
    filetypes = { "tex", "plaintex" },
}

vim.lsp.enable(servers)
for _, s in ipairs(servers) do
    vim.lsp.config[s].capabilities = capabilities
end

local cmds = {}

cmds.pluginSelectToRemove = function ()
    local list = vim.pack.get()
    local names = {}

    for _, p in ipairs(list) do
        table.insert(names, p.spec.name)
    end

    vim.ui.select(names, { prompt = "delete: "}, function (name)
        vim.pack.del({name})
    end)
end

cmds.get_license = function ()
    vim.ui.input({ prompt = "license: "}, function (license)
        vim.cmd("!cp ~/doc/licenses/" .. license .. ".txt LICENSE")
    end)
end

cmds.white = function ()
    vim.cmd("%s/\t/    /g")
end

cmds.quotes = function (d)
    local args = d.args

    local cmd = "%s/'/\"/g"

    if (args == "c") then
        cmd = cmd .. "c"
    end

    vim.cmd(cmd)
end

vim.api.nvim_create_user_command("License", cmds.get_license, {})
vim.api.nvim_create_user_command("White", cmds.white, {})
vim.api.nvim_create_user_command("Quotes", cmds.quotes, { nargs = "*" })
vim.api.nvim_create_user_command("Packrm", cmds.pluginSelectToRemove, { nargs = "*" })

