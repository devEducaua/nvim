require("commands")
require("plugins")

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
map("n", "<leader>c", ":Cmd<CR>")

map("t", "<esc>", "<c-\\><c-n>")
map("n", "<space>;", "q:", {})
map("t", "<A-q>", "<esc><esc>bd<CR>")

map("n", "<leader>b", ":b#<CR>")
map("n", "<leader>B", ":bn<CR>")
map("n", "<leader>ls", ":ls<CR>")

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

map("n", "<leader>f", ":find ")
map("n", "<leader>h", ":help ")
map("n", "<leader>g", ":b ")
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

local servers = { "luals", "ts_ls", "clangd", "bashls", "gopls", "cssls", "html","pyright", "texlab" } --denols

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

vim.lsp.config("denols", {
    cmd = { "deno", "lsp" },
    filetypes = { "javascript", "typescript" },
    root_markers = { "deno.json", "deno.jsonc", "deno.lock" },
})

vim.lsp.config["clangd"] = {
    cmd = { "clangd" },
    filetypes = { "c", "cpp" },
    root_markers = { "Makefile", ".git" }
}

vim.lsp.config["bashls"] = {
    cmd = { "bash-language-server" },
    filetypes = { "sh" }
}

vim.lsp.config["gopls"] = {
    cmd = { "gopls" },
    filetypes = { "go", "gomod" },
    root_markers = { "go.mod" }
}

vim.lsp.config["cssls"] = {
    cmd = { "vscode-css-language-server", "--stdio" },
    filetypes = { "css", "scss", "less" },
    root_markers = { "package.json", ".git" }
}

vim.lsp.config["html"] = {
    cmd = { "vscode-html-language-server", "--stdio" },
    filetypes = { "html", "astro", "jinja" },
    root_markers = { ".git" }
}

vim.lsp.config["pyright"] = {
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_markers = { "requirements.txt" }
}

vim.lsp.config["texlab"] = {
    cmd = { "texlab" },
    filetypes = { "tex", "plaintex" },
}

vim.lsp.enable(servers)
for _, s in ipairs(servers) do
    vim.lsp.config[s].capabilities = capabilities
end
