
vim.cmd.colorscheme("3min")
vim.o.number = true
vim.o.relativenumber = true
vim.o.syntax = "on"
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.cmdheight = 1
vim.o.swapfile = false
vim.o.showmode = false
vim.o.winborder = "rounded"
vim.o.pumborder = "rounded"

vim.opt.iskeyword:remove("_")
vim.opt.fillchars = {eob = " ", vert = " ", horiz = " "}

vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.g.loaded_netrwPlugin = 0

vim.o.makeprg = "make"
vim.o.grepprg = "rg --vimgrep --smart-case --no-ignore --follow"

vim.o.path = "**"
vim.o.wildmenu = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.fileignorecase = false
vim.o.wildignorecase = false
vim.o.wildoptions = "fuzzy"
vim.o.wildmode = "longest:full,full"
vim.o.wildignore = "*/node_modules/*"
vim.o.completeopt = "menuone,noselect"
vim.o.omnifunc = "v:lua.vim.lsp.omnifunc"

vim.opt.findfunc = "v:lua.find"
vim.o.statusline = "%t%r%h%q%m %= %3l:%-2c %{&filetype}"

local map = vim.keymap.set

map({"i", "v", "t"}, "jk", "<esc>")
map({"n", "v", "x", "c", "t"}, "<C-y>", "\"+y")
map({"n", "v", "x", "c", "t"}, "<C-p>", "\"+p")
map("t", "<leader>c", "<c-\\><c-n>")

map("n", "<leader>w", ":update<CR>")
map("n", "<leader>q", ":bd!<CR>")
map("n", "<leader>;", "q:")

map("n", "<leader>f", ":find ")
map("n", "<leader>b", ":buffer ")
map("n", "<leader>t", ":Term ")

map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "<C-f>", "<C-f>zz")
map("n", "<C-b>", "<C-b>zz")

map("n", "<A-CR>", ":Term<CR>")
map("n", "<A-h>", "<C-w>h") 
map("n", "<A-j>", "<C-w>j") 
map("n", "<A-k>", "<C-w>k") 
map("n", "<A-l>", "<C-w>l") 


vim.diagnostic.config({
    virtual_text = {
        current_line = true
    },
    virtual_lines = false
})

vim.filetype.add({
    extension = {
        fnl = "scheme"
    }
})

function find(text, _)
    local files = vim.fn.glob("**/*", true, true)
    return vim.fn.matchfuzzy(files, text)
end

function project_note()
    local folder = vim.env.HOME .. "/not/prj/" .. vim.fs.basename(vim.fn.getcwd)
    vim.fn.mkdir(folder, "p")
    vim.cmd(":enew")
    vim.cmd(":edit " .. folder)
end

function get_license(d)
    local arg = d.args
    local l = {
        mit = "/usr/share/licenses/man-pages/MIT.txt",
        gpl3 = "https://www.gnu.org/licenses/gpl-3.0.txt",
        agpl3 = "https://www.gnu.org/licenses/agpl-3.0.txt"
    }
    if arg == "" then
        arg = "agpl3"
    end

    local url = l[arg]
    if url:sub(1,1) == "/" then
        vim.cmd("!cp " .. url .. " ./LICENSE")
    else
        vim.cmd("!wget -O LICNSE " .. url)
    end
end

function term(d)
    local arg = d.args
    vim.cmd(":vsplit")
    vim.cmd(":wincmd L")

    local cmd = ":terminal"
    if arg ~= "" then
         cmd = cmd .. " " .. arg
    end
    vim.cmd(cmd)
end

vim.api.nvim_create_user_command("ProjectNote", project_note, {})
vim.api.nvim_create_user_command("License", get_license, {nargs = 1})
vim.api.nvim_create_user_command("Term", term, {nargs = "?", complete = "file"})

vim.api.nvim_create_autocmd("FileType", {
    pattern = {"help", "man"},
    callback = function()
        vim.cmd("wincmd L")
    end
})

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = {"*.md"},
    callback = function()
        vim.o.linebreak = true
    end
})

vim.api.nvim_create_autocmd("TermOpen", {
    callback = function()
        vim.cmd("startinsert")
    end
})

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function() 
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        map("n", "gli", vim.lsp.buf.implementation, { buffer = args.buf })
        map("n", "gd", vim.lsp.buf.definition, { buffer = args.buf })
        map("n", "glf", vim.lsp.buf.format)
    end
})

local lsps = {
    gopls = {"gopls", {"go", "gomod"}, {"go.mod", "go.sum"}}
}

vim.lsp.config["gopls"] = {
    cmd = "gopls",
    filetypes = {"go", "gomod"},
    root_markers = {"go.mod", "go.sum", "internal"}
}

vim.lsp.config["clangd"] = {
    cmd = "clangd",
    filetypes = {"c", "cpp"},
    root_markers = {"Makefile", "include"}
}

vim.lsp.config["jdtls"] = {
    cmd = "jdtls",
    filetypes = {"java"},
    root_markers = {"pom.xml", "mvnw"}
}

vim.lsp.config["ols"] = {
    cmd = vim.fs.normalize("~/sou/ols/ols"),
    filetypes = {"odin"},
    root_markers = {"main.odin"}
}

vim.lsp.config["rust-analyzer"] = {
    cmd = vim.fs.normalize("~/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin/rust-analyzer"),
    filetypes = {"rust"},
    root_markers = {"Cargo.toml", "target"}
}

vim.pack.add({
    "https://codeberg.org/mfussenegger/nvim-dap",
    "https://github.com/leoluz/nvim-dap-go",
    "https://github.com/stevearc/oil.nvim"
 })

require("dap-go").setup()

