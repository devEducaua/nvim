
(vim.cmd.colorscheme "3min")

(set vim.o.number true)
(set vim.o.relativenumber true)
(set vim.o.syntax "on")
(set vim.o.tabstop 4)
(set vim.o.shiftwidth 4)
(set vim.o.softtabstop 4)
(set vim.o.expandtab true)
(set vim.o.cmdheight 1)
(set vim.o.swapfile false)
(set vim.o.showmode false)
(set vim.o.winborder "rounded")
(set vim.o.pumborder "rounded")

(vim.opt.iskeyword:remove "_")
(set vim.opt.fillchars { :vert " " :horiz " "})

(set vim.g.mapleader " ")
(set vim.g.maplocalleader ",")

(set vim.o.makeprg "make")
(set vim.o.grepprg "rg --vimgrep --smart-case --no-ignore --follow")

(set vim.o.path "**")
(set vim.o.wildmenu true)
(set vim.o.ignorecase true)
(set vim.o.smartcase true)
(set vim.o.fileignorecase true)
(set vim.o.wildignorecase true)
(set vim.o.wildoptions "fuzzy")
(set vim.o.wildmode "longest:full,full")
(set vim.o.wildignore "*/node_modules/*")
(set vim.o.completeopt "menuone,noselect")
(set vim.o.omnifunc "v:lua.vim.lsp.omnifunc")

(set vim.opt.findfunc "v:lua.find")

(fn _G.find [text _]
    (let [files (vim.fn.glob "**/*" true true)]
      (vim.fn.matchfuzzy files text)))

(set vim.o.statusline
  "%t%r%h%q %{v:lua.branch()}%m%=%{&filetype} • %L •%3l:%-2c")

(vim.diagnostic.config {
    :virtual_text {:current_line true}
    :virtual_lines false})

;; this function is auto-generated
(fn _G.branch []
  (let [handle (io.popen "git rev-parse --abbrev-ref HEAD 2>/dev/null")]
    (when (not handle) (lua "return \"\""))
    (var result (handle:read :*a))
    (handle:close)
    (set result (result:gsub "\n" ""))
    (when (and (not= result "") (not= result " "))
      (let [___antifnl_rtn_1___ (.. "• [" result "]")]
        (lua "return ___antifnl_rtn_1___")))
    ""))	

(fn map [mode key cmd]
  (vim.keymap.set mode key cmd {:silent true :noremap true}))

(map ["i" "v" "t" ] "jk" "<esc>")
(map ["n" "v" "x" "c" "t"] "<C-y>" "\"+y")
(map ["n" "v" "x" "c" "t"] "<C-p>" "\"+p")
(map ["i"] "<C-p>" "<esc>\"+pa")

(map ["n"] "<leader>w" ":update<CR>")
(map ["n"] "<leader>x" ":x<CR>:Oil<CR>")
(map ["n"] "<leader>q" ":bd!<CR>")

(map ["n"] "<leader>ls" ":ls<CR>")
(map ["n"] "<leader>b" ":b#<CR>")
(map ["n"] "<leader>B" ":%bdelete<CR>")
(map ["n"] "<leader>c" ":copen<CR>")
(map ["n"] "<leader>m" ":make<CR>")
(map ["n"] "<leader>f" ":find ")
(map ["n"] "<leader>h" ":help ")
(map ["n"] "<leader>g" ":grep ")
(map ["n"] "<leader>e" ":e ")

(map ["n"] "<C-d>" "<C-d>zz")
(map ["n"] "<C-u>" "<C-u>zz")
(map ["n"] "<C-f>" "<C-f>zz")
(map ["n"] "<C-b>" "<C-b>zz")

(map ["n"] "-" ":Oil<CR>")

(vim.api.nvim_create_autocmd "FileType" {
    :pattern [ "help" "man"]
    :command "wincmd L"})

(vim.pack.add ["https://github.com/stevearc/oil.nvim"])
(let [oil (require :oil)]
    (oil.setup {
       :default_file_explorer true
       :skip_confirm_for_simple_edits true
       :watch_for_changes true
       :view_options { :show_hidden true }
       :columns [ "icons" "type" "permissions" "size" "mtime" ]
    }))

(vim.api.nvim_create_autocmd "LspAttach"
    {:callback 
        (fn [args]
          (local client (assert (vim.lsp.get_client_by_id args.data.client_id)))
          (vim.keymap.set ["n"] "gli" vim.lsp.buf.implementation { :buffer args.buf })
          (vim.keymap.set ["n"] "gd" vim.lsp.buf.definition { :buffer args.buf })
          (vim.keymap.set ["n" "v" "x"] "<leader>lf" vim.lsp.buf.format))
    })

(lambda configure_lsp [server cmd filetypes markers ?settings]
  (let [cfg {
        :cmd cmd
        :filetypes filetypes
        :root_markers markers}]
    (when ?settings
      (tset cfg :settings ?settings))
    (tset vim.lsp.config server cfg)))

(configure_lsp "gopls" 
       [(vim.fs.normalize "~/.config/go/bin/gopls")] [ "go" "gomod" ] [ "go.mod" "go.sum" ] )

(configure_lsp "clangd" [ "clangd"] [ "c" "cpp" ] [ "Makefile" "include" ".git" ] )

(vim.lsp.enable ["gopls" "clangd"])

(print "fennel config loaded")

