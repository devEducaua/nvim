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
vim.opt.fillchars = {vert = " ", horiz = " "}
vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.o.makeprg = "make"
vim.o.grepprg = "rg --vimgrep --smart-case --no-ignore --follow"
vim.o.path = "**"
vim.o.wildmenu = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.fileignorecase = true
vim.o.wildignorecase = true
vim.o.wildoptions = "fuzzy"
vim.o.wildmode = "longest:full,full"
vim.o.wildignore = "*/node_modules/*"
vim.o.completeopt = "menuone,noselect"
vim.o.omnifunc = "v:lua.vim.lsp.omnifunc"
vim.opt.findfunc = "v:lua.find"
_G.find = function(text, _)
  local files = vim.fn.glob("**/*", true, true)
  return vim.fn.matchfuzzy(files, text)
end
vim.o.statusline = "%t%r%h%q %{v:lua.branch()}%m%=%{&filetype} \226\128\162 %L \226\128\162%3l:%-2c"
_G.branch = function()
  local handle = io.popen("git rev-parse --abbrev-ref HEAD 2>/dev/null")
  if not handle then
    return ""
  else
  end
  local result = handle:read("*a")
  handle:close()
  result = result:gsub("\n", "")
  if ((result ~= "") and (result ~= " ")) then
    local ___antifnl_rtn_1___ = ("\226\128\162 [" .. result .. "]")
    return ___antifnl_rtn_1___
  else
  end
  return ""
end
local function map(mode, key, cmd)
  return vim.keymap.set(mode, key, cmd, {silent = true, noremap = true})
end
map({"i", "v", "t"}, "jk", "<esc>")
map({"n", "v", "x", "c", "t"}, "<C-y>", "\"+y")
map({"n", "v", "x", "c", "t"}, "<C-p>", "\"+p")
map({"i"}, "<C-p>", "<esc>\"+pa")
map({"n"}, "<leader>w", ":update<CR>")
map({"n"}, "<leader>x", ":x<CR>:Oil<CR>")
map({"n"}, "<leader>q", ":bd!<CR>")
map({"n"}, "<leader>ls", ":ls<CR>")
map({"n"}, "<leader>b", ":b#<CR>")
map({"n"}, "<leader>B", ":%bdelete<CR>")
map({"n"}, "<leader>c", ":copen<CR>")
map({"n"}, "<leader>m", ":make<CR>")
map({"n"}, "<leader>f", ":find ")
map({"n"}, "<leader>h", ":help ")
map({"n"}, "<leader>g", ":grep ")
map({"n"}, "<leader>e", ":e ")
map({"n"}, "<C-d>", "<C-d>zz")
map({"n"}, "<C-u>", "<C-u>zz")
map({"n"}, "<C-f>", "<C-f>zz")
map({"n"}, "<C-b>", "<C-b>zz")
map({"n"}, "-", ":Oil<CR>")
vim.api.nvim_create_autocmd("FileType", {pattern = {"help", "man"}, command = "wincmd L"})
vim.pack.add({"https://github.com/stevearc/oil.nvim"})
do
  local oil = require("oil")
  oil.setup({default_file_explorer = true, skip_confirm_for_simple_edits = true, watch_for_changes = true, view_options = {show_hidden = true}, columns = {"icons", "type", "permissions", "size", "mtime"}})
end
local function _3_(args)
  local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
  vim.keymap.set({"n"}, "gli", vim.lsp.buf.implementation, {buffer = args.buf})
  vim.keymap.set({"n"}, "gd", vim.lsp.buf.definition, {buffer = args.buf})
  return vim.keymap.set({"n", "v", "x"}, "<leader>lf", vim.lsp.buf.format)
end
vim.api.nvim_create_autocmd("LspAttach", {callback = _3_})
local function configure_lsp(server, cmd, filetypes, markers, _3fsettings)
  if (nil == markers) then
    _G.error("Missing argument markers on fnl/init.fnl:110", 2)
  else
  end
  if (nil == filetypes) then
    _G.error("Missing argument filetypes on fnl/init.fnl:110", 2)
  else
  end
  if (nil == cmd) then
    _G.error("Missing argument cmd on fnl/init.fnl:110", 2)
  else
  end
  if (nil == server) then
    _G.error("Missing argument server on fnl/init.fnl:110", 2)
  else
  end
  local cfg = {cmd = cmd, filetypes = filetypes, root_markers = markers}
  if _3fsettings then
    cfg["settings"] = _3fsettings
  else
  end
  vim.lsp.config[server] = cfg
  return nil
end
configure_lsp("gopls", {vim.fs.normalize("~/.config/go/bin/gopls")}, {"go", "gomod"}, {"go.mod", "go.sum"})
configure_lsp("clangd", {"clangd"}, {"c", "cpp"}, {"Makefile", "include", ".git"})
vim.lsp.enable({"gopls", "clangd"})
return print("fennel config loaded")
