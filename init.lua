
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
map("t", "<M-c>", "<c-\\><c-n>")

map("n", "<leader>w", ":update<CR>")
map("n", "<leader>q", ":bd!<CR>")
map("n", "<leader>;", "q:")
map("n", "<leader>so", ":source $MYVIMRC<CR>")

map("n", "<leader>f", ":find ")
map("n", "<leader>b", ":buffer ")
map("n", "<leader>e", ":edit ")
map("n", "<leader>t", ":Term ")

map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "<C-f>", "<C-f>zz")
map("n", "<C-b>", "<C-b>zz")

map("n", "<M-CR>", ":vnew<CR>:wincmd L<CR>")
map("n", "<M-h>", "<C-w>h")
map("n", "<M-j>", "<C-w>j")
map("n", "<M-k>", "<C-w>k")
map("n", "<M-l>", "<C-w>l")

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

function _G.find(text, _)
    local files = vim.fn.glob("**/*", true, true)
    return vim.fn.matchfuzzy(files, text)
end

local function project_note()
    local folder = vim.env.HOME .. "/not/prj/" .. vim.fs.basename(vim.fn.getcwd())
    vim.fn.mkdir(folder, "p")
    vim.cmd(":enew")
    vim.cmd(":edit " .. folder)
end

local function get_license(d)
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

local function term(d)
    local arg = d.args
    vim.cmd(":vsplit")
    vim.cmd(":wincmd L")

    local cmd = ":terminal"
    if arg ~= "" then
         cmd = cmd .. " " .. arg
    end
    vim.cmd(cmd)
end

local function mq_list()
    vim.cmd.vnew()
    vim.cmd.wincmd("L")
    local buf = vim.api.nvim_get_current_buf();
    vim.bo.filetype = "mq-select"
    vim.bo.modifiable = true
    vim.bo.bufhidden = "wipe"
    vim.bo.swapfile = false
    vim.bo.buftype = "nofile"

    vim.cmd(":read !mq list")

    local r = vim.system({"mq", "list"}):wait().stdout
    if not r then return end
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(r, "\n", {trimempty=true}))

    vim.bo.modifiable = false
    vim.keymap.set("n", "<CR>", function()
        local line = vim.api.nvim_get_current_line();
        local id = line:format("^(%S+)")
        vim.cmd("!mq play " .. id)
        vim.api.nvim_win_close(0, false)
    end, {buffer = buf})


    vim.keymap.set("n", "q", function()
        vim.api.nvim_win_close(0, false)
    end, {buffer = buf})
end

local function git_commit(d)
    local arg = d.args

    if arg ~= "" then
        vim.system({"git", "commit", "-m", arg}):wait()
        return
    end

    local f = ".git/COMMIT_EDITMSG"
    vim.cmd.edit(f)
    vim.api.nvim_create_autocmd("BufDelete", {
        callback = function()
            vim.system({"git", "commit", "-F", f}):wait()
        end
    })
end

local function menu()
    local commands = {
        { name = "btop", command = "btop"},
        { name = "mq", command = "mq"},
    }

    vim.cmd.vnew()
    local buf = vim.api.nvim_get_current_buf();
    vim.bo.filetype = "my-menu"
    vim.bo.modifiable = true
    vim.bo.bufhidden = "wipe"
    vim.bo.swapfile = false
    vim.bo.buftype = "nofile"

    local lines = {}
    local imap = {}

    for i,v in ipairs(commands) do
        local line = string.format("- %s", v.name)
        table.insert(lines, line)
        imap[i] = v.command
    end

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo.modifiable = false

    vim.keymap.set("n", "<CR>", function()
        local line = vim.api.nvim_get_current_line();
        if not vim.startswith(line, "- ") then
            return
        end

        local ln = vim.fn.line(".")
        local command = imap[ln]
        if command then
            vim.cmd.terminal()
            local job = vim.b.terminal_job_id
            vim.fn.chansend(job, command .. "\n")
        end
    end, {buffer = buf})

    vim.keymap.set("n", "q", function()
        vim.api.nvim_buf_delete(buf, {force=true})
    end, {buffer = buf})
end

--local function cli_wrapper(command, outputs, arg)
--    local f = arg:match("^(%S+)") or ""
--    for _,v in ipairs(outputs) do
--        if v == f then
--            vim.cmd.vnew()
--            vim.cmd.wincmd("L")
--            vim.cmd.terminal(command .. " " .. arg)
--            return
--        end
--    end
--    vim.cmd("!" .. command .. " " .. arg)
--end

local function opendot(path)
    vim.cmd(":enew")
    --vim.cmd(":tabnew")
    vim.cmd(":edit " .. path)
    --vim.cmd(":lcd " .. vim.fs.dirname(path))
end

local function opennote()
    opendot(vim.fs.normalize("~/not"))
end

local function openvimrc()
    opendot(vim.env.MYVIMRC)
end

vim.api.nvim_create_user_command("ProjectNote", project_note, {})
vim.api.nvim_create_user_command("License", get_license, {nargs = 1})
vim.api.nvim_create_user_command("Term", term, {nargs = "?", complete = "file"})
vim.api.nvim_create_user_command("Nvc", openvimrc, {})
vim.api.nvim_create_user_command("Not", opennote, {})
vim.api.nvim_create_user_command("Menu", menu, {})
vim.api.nvim_create_user_command("Mq", mq_list, {})
vim.api.nvim_create_user_command("Commit", git_commit, {nargs = "?"})

vim.api.nvim_create_autocmd("FileType", {
    pattern = {"help", "man"},
    callback = function()
        vim.cmd("wincmd L")
    end
})

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = {"*.md"},
    callback = function()

        local n = require("notes")
        n.setup({
            headers = {"######", "#####", "####", "###", "##", "#"},
            todos = {"- [ ]", "- [x]"}
        })
        map({"n", "i"}, "<A-a>", n.increase_header, {buffer = true})
        map({"n", "i"}, "<A-x>", n.decrease_header, {buffer = true})
        map({"n", "i"}, "<A-t>", n.toggle_todo, {buffer = true})
        vim.o.linebreak = true
    end
})

vim.api.nvim_create_autocmd("TermOpen", {
    callback = function()
        vim.cmd("startinsert")
    end
})

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        --local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        map("n", "gli", vim.lsp.buf.implementation, { buffer = args.buf })
        map("n", "gd", vim.lsp.buf.definition, { buffer = args.buf })
        map("n", "glf", vim.lsp.buf.format)
    end
})

vim.lsp.config["gopls"] = {
    cmd = { "gopls" },
    filetypes = {"go", "gomod"},
    root_markers = {"go.mod", "go.sum", "internal"}
}

vim.lsp.config["clangd"] = {
    cmd = { "clangd" },
    filetypes = {"c", "cpp"},
    root_markers = {"Makefile", "include"}
}

vim.lsp.config["jdtls"] = {
    cmd = { "jdtls" },
    filetypes = {"java"},
    root_markers = {"pom.xml", "mvnw"}
}

vim.lsp.config["ols"] = {
    cmd = { vim.fs.normalize("~/sou/ols/ols") },
    filetypes = {"odin"},
    root_markers = {"main.odin"}
}

vim.lsp.config["rust-analyzer"] = {
    cmd = { vim.fs.normalize("~/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin/rust-analyzer") },
    filetypes = {"rust"},
    root_markers = {"Cargo.toml", "target"}
}

vim.lsp.config["lua_ls"] = {
    cmd = { vim.fs.normalize("~/sou/lua-ls/bin/lua-language-server") },
    filetypes = {"lua"},
    settings = {
        Lua = {
            workspace = {
                library = { vim.env.VIMRUNTIME }
            }
        }
    }
}
vim.lsp.enable({"gopls", "clangd", "jdtls", "ols", "rust-analyzer", "lua_ls"})

vim.pack.add({
    "https://codeberg.org/mfussenegger/nvim-dap",
    "https://github.com/leoluz/nvim-dap-go"
 })

require("dap-go").setup()

