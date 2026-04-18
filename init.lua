
vim.cmd.colorscheme("3min");
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
vim.o.wildignore = "*/node_modules/*" -- add some form of changing this
vim.opt.iskeyword:remove("_")
vim.o.omnifunc = "v:lua.vim.lsp.omnifunc"
vim.o.completeopt = "menuone,noselect"
vim.o.makeprg = "make" --quiet
vim.o.grepprg = "rg --vimgrep --smart-case --no-ignore --follow"

function _G.find(text, _)
    local files = vim.fn.glob("**/*", true, true)
    return vim.fn.matchfuzzy(files, text)
end

vim.opt.findfunc = "v:lua.find"

vim.opt.fillchars = { vert = " ", horiz = " " }

function branch()
    local handle = io.popen('git rev-parse --abbrev-ref HEAD 2>/dev/null')
    if not handle then return '' end
    local result = handle:read("*a")
    handle:close()

    result = result:gsub("\n", "")
    if result ~= '' and result ~= ' ' then
        return "• [" .. result .. "]"
    end
    return ''
end

vim.o.statusline = "%t%r%h%q %{v:lua.branch()}%m%=%{&filetype} • %L •%3l:%-2c "

vim.diagnostic.config({
    virtual_lines = {
        current_line = true,
    },
})

vim.api.nvim_create_autocmd('BufEnter', {
    pattern = { "*.md", "*.tex", "*.nabo", "*.adoc" },
    callback = function ()
        vim.o.linebreak = true
    end
})

vim.filetype.add({
    extension = {
        njk = "html"
        --njk = "jinja"
    }
})

local map = vim.keymap.set

map({"i", "v", "t"}, "jk", "<esc>")

map("t", "<esc>", "<c-\\><c-n>")
map("n", "<space>;", "q:", {})

map("n", "<leader>ls", ":ls<CR>")
map("n", "<leader>b", ":b#<CR>")
map("n", "<leader>B", ":%bdelete<CR>")
map("n", "<leader>f", ":find ")
map("n", "<leader>h", ":help ")
map("n", "<leader>c", ":copen<CR>")
map("n", "<leader>m", ":make<CR>")
map("n", "<leader>g", ":grep ")
map("n", "<leader>e", ":e ")
map("n", "<leader>t", ":enew<CR>:terminal<CR>i")

map({"n", "v", "x", "c", "t"}, "<C-y>", '"+y', {})
map({"n", "v", "x", "c", "t"}, "<C-p>", '"+p', {})
map("i", "<C-p>", '<esc>"+pa')

map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "<C-f>", "<C-f>zz")
map("n", "<C-b>", "<C-b>zz")

map("n", "<leader>w", ":up<CR>", {})
map("n", "<leader>x", ":up<CR> :Oil<CR>", {})
map("n", "<leader>q", ":bd!<CR>", {})

map("n", "-", ":Oil<CR>", {})

vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ timeout = 200, visual = true })
	end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "help", "man" },
    command = "wincmd L"
})

vim.pack.add({
    "https://github.com/stevearc/oil.nvim",
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
       ["g,"] = { "actions.cd", mode = "n" }
   }
})

local servers = { "luals", "ts_ls", "clangd", "cssls", "gopls" }
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
    cmd = { vim.fs.normalize("~/.config/go/bin/gopls") },
    filetypes = { "go", "gomod" },
    root_markers = { "go.mod", "go.sum" }
}

vim.lsp.config["cssls"] = {
    cmd = { "vscode-css-language-server", "--stdio" },
    filetypes = { "css", "scss", "less" },
    root_markers = { "package.json", ".git" }
}

vim.lsp.enable(servers)
for _, s in ipairs(servers) do
    vim.lsp.config[s].capabilities = capabilities
end

local cmds = {}

cmds.get_license = function (d)
    vim.cmd("vsplit | terminal licenses.sh")
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

vim.api.nvim_create_user_command("License", cmds.get_license, { nargs = "*" })
vim.api.nvim_create_user_command("White", cmds.white, {})
vim.api.nvim_create_user_command("Quotes", cmds.quotes, { nargs = "*" })

