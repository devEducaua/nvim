
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

(fn map [mode key cmd ?settings]
    (var opts {:silent true :noremap true})
    (when ?settings
      (set opts ?settings))
    (vim.keymap.set mode key cmd opts))

(macro nmap [key cmd settings]
    `(map ["n"] ,key ,cmd ,settings))

(macro map-cmd [key cmd]
    `(nmap ,(.. "<leader>" key) ,cmd ,{:nowait true}))

(map ["i" "v" "t" ] "jk" "<esc>")
(map ["n" "v" "x" "c" "t"] "<C-y>" "\"+y")
(map ["n" "v" "x" "c" "t"] "<C-p>" "\"+p")
(map ["i"] "<C-p>" "<esc>\"+pa")

(map ["t"] "<leader><esc>" "<c-\\><c-n>")

(nmap "<leader>w" ":update<CR>")
(nmap "<leader>x" ":x<CR>:Oil<CR>")
(nmap "<leader>q" ":bd!<CR>")

(nmap "<leader>ls" ":ls<CR>")
(nmap "<leader>B" ":%bdelete<CR>")
(nmap "<leader>t" ":enew<CR>:terminal<CR>i")

(map-cmd "f" ":find ")
(map-cmd "h" ":help ")
(map-cmd "g" ":grep ")
(map-cmd "e" ":edit ")
(map-cmd "b" ":buffer ")

(nmap "-" ":Explore<CR>")

(each [_ k (ipairs [:<C-d> :<C-u> :<C-f> :<C-b>])]
    (nmap k (.. k "zz")))

(vim.api.nvim_create_autocmd "FileType" {
    :pattern [ "help" "man"]
    :command "wincmd L"})

(vim.api.nvim_create_autocmd "BufEnter" {
    :pattern ["*.md"]
    :command "set linebreak"})

(vim.filetype.add 
  {:extension 
    { :fnl "scheme"}})

;; plugin
;(vim.pack.add ["https://github.com/stevearc/oil.nvim"])
;(let [oil (require :oil)]
;    (oil.setup {
;       :default_file_explorer true
;       :skip_confirm_for_simple_edits true
;       :watch_for_changes true
;       :view_options { :show_hidden true }
;       :columns [ "icons" "type" "permissions" "size" "mtime" ]
;    }))
;(nmap "-" ":Oil<CR>")

(vim.api.nvim_create_autocmd "LspAttach"
    {:callback 
        (fn [args]
          (local client (assert (vim.lsp.get_client_by_id args.data.client_id)))
          (vim.keymap.set ["n"] "gli" vim.lsp.buf.implementation { :buffer args.buf })
          (vim.keymap.set ["n"] "gd" vim.lsp.buf.definition { :buffer args.buf })
          (vim.keymap.set ["n" "v" "x"] "<leader>lf" vim.lsp.buf.format))
    })

(fn get-license [d]
  (vim.cmd "vsplit | terminal licenses.sh"))

(fn tabs-to-spaces []
    (vim.cmd "%s\t/   /g"))

(fn delete-pack []
    (local packs (vim.pack.get))
    (local names 
        (icollect [_ p (ipairs packs)]
            p.spec.name))
    (vim.ui.select names
       { :prompt "pack:"} 
       (fn [choice] 
	 (when choice
	     (vim.pack.del [choice])))))

(vim.api.nvim_create_user_command "DeletePack" delete-pack {})
(vim.api.nvim_create_user_command "License" get-license {})
(vim.api.nvim_create_user_command "White" tabs-to-spaces {})

(lambda configure-lsp [server [cmd filetypes markers ?settings]]
  (let [cfg {
        :cmd cmd
        :filetypes filetypes
        :root_markers markers}]
    (when ?settings
      (tset cfg :settings ?settings))
    (tset vim.lsp.config server cfg)))

(local lsps {
    :gopls [[(vim.fs.normalize "~/.config/go/bin/gopls")] [ "go" "gomod" ] [ "go.mod" "go.sum" ]]
    :clangd [["clangd"] [ "c" "cpp" ] [ "Makefile" "include" ".git" ]]
    :rust-analyzer [[(vim.fs.normalize "~/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin/rust-analyzer")] [ "rust" ] [ "Cargo.toml" "target" ".git" ]]})

(each [k v (pairs lsps)]
  (configure-lsp k v)
  (vim.lsp.enable k))

