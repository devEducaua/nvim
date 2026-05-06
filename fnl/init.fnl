
(macro custom-command [n f ?a]
    (var a {})
    (when ?a
      (tset a :nargs ?a))
    `(vim.api.nvim_create_user_command ,n ,f ,a))

(macro map [mode key cmd ?settings]
    (var opts {:silent true :noremap true})
    (when ?settings
      (set opts ?settings))
    `(vim.keymap.set ,mode ,key ,cmd ,opts))

(macro nmap [key cmd settings]
    `(map ["n"] ,key ,cmd ,settings))

(macro map-cmd [key cmd]
    `(nmap ,(.. "<leader>" key) ,cmd ,{:nowait true}))

(vim.pack.add 
    ["https://github.com/neovim-treesitter/nvim-treesitter"
    "https://github.com/neovim-treesitter/treesitter-parser-registry"
    "https://codeberg.org/mfussenegger/nvim-dap"
    "https://github.com/leoluz/nvim-dap-go"
    ;"https://github.com/stevearc/oil.nvim"
    "https://github.com/Olical/conjure"])

(local dap-go (require :dap-go))
(dap-go.setup 
  {:delve
    { :path (vim.fs.normalize "~/.config/go/bin/dlv")}})

(require :nvim-treesitter.install ["go" "markdown" "json"])

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

(set vim.opt.findfunc "v:lua.find") ;; can add a keymap to change it dynamic
(set vim.o.statusline "%t%r%h%q%m %= %3l:%-2c %{&filetype}")

(map ["i" "v" "t" ] "jk" "<esc>")
(map ["n" "v" "x" "c" "t"] "<C-y>" "\"+y")
(map ["n" "v" "x" "c" "t"] "<C-p>" "\"+p")
(map ["i"] "<C-p>" "<esc>\"+pa")

(map ["t"] "<leader><esc>" "<c-\\><c-n>")

(nmap "<leader>w" ":update<CR>")
(nmap "<leader>q" ":bd!<CR>")
(nmap "<leader>;" "q:")
(nmap "<leader>t" ":tabnew<CR>:terminal<CR>i")
(nmap "<leader>n" ":enew<CR><leader>e" { :remap true })

(map-cmd "f" ":find ")
(map-cmd "g" ":grep ")
(map-cmd "e" ":edit ")
(map-cmd "b" ":buffer ")

(nmap "-" ":Explore<CR>")

(nmap "<leader>dd" ":DapContinue")
(nmap "<leader>db" ":DapToggleBreakpoint")
(nmap "<leader>dr" ":DapToggleRepl")
(nmap "<leader>dsi" ":DapStepInto")
(nmap "<leader>dso" ":DapStepOver")

(each [_ k (ipairs [:<C-d> :<C-u> :<C-f> :<C-b>])]
    (nmap k (.. k "zz")))

(vim.diagnostic.config {
    :virtual_text {:current_line true}
    :virtual_lines false})

(vim.filetype.add 
  {:extension 
    { :fnl "scheme"}})

(vim.api.nvim_create_autocmd "FileType"
    {:pattern [ "help" "man"]
    :command "wincmd L"})

(vim.api.nvim_create_autocmd "BufEnter" 
    {:pattern ["*.md"]
    :callback (fn []
        (set vim.o.linebreak true))})

(vim.api.nvim_create_autocmd "LspAttach"
    {:callback 
        (fn [args]
          (local client (assert (vim.lsp.get_client_by_id args.data.client_id)))
          (nmap "gli" vim.lsp.buf.implementation { :buffer args.buf })
          (nmap "gd" vim.lsp.buf.definition { :buffer args.buf })
          (map ["n" "v" "x"] "<leader>lf" vim.lsp.buf.format))})

(vim.api.nvim_create_autocmd "FileType"
    {:pattern ["markdown" "*.md"]
    :callback (fn [args]
        (nmap "<A-t>" toggle-todo {:buffer args.buf}))})

(vim.api.nvim_create_autocmd "FileType"
    {:pattern ["markdown" "*.md"]
    :callback (fn [] 
         (vim.treesitter.start))})

(fn get-license [d]
    (local licenses 
        {:mit "/usr/share/licenses/man-pages/MIT.txt"
        :gpl3 "https://www.gnu.org/licenses/gpl-3.0.txt"
        :agpl3 "https://www.gnu.org/licenses/agpl-3.0.txt"})
    (var arg d.args)
    (when (= arg "")
      (set arg "gpl3"))
    (let [url (. licenses arg)]
        (when url
          (if (= (url:sub 1 1 ) "/")
            (vim.cmd (.. "!cp " url " ./LICENSE"))
            (vim.cmd (.. "!wget -O LICENSE " url))))))

(fn toggle-todo []
    (var line (vim.api.nvim_get_current_line))
    (if (line:match "%[ %]")
          (set line (line:gsub "%[ %]" "[x]" 1))
        (line:match "%[x%]")
          (set line (line:gsub "%[x%]" "[ ]" 1))
        (print "not a md todo line"))
    (vim.api.nvim_set_current_line line))
(fn _G.find [text _]
    (let [files (vim.fn.glob "**/*" true true)]
      (vim.fn.matchfuzzy files text)))

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

(fn project-note []
    (let [folder (.. vim.env.HOME "/not/prj/" (vim.fs.basename (vim.fn.getcwd)))]
      (vim.fn.mkdir folder "p")
      (vim.cmd (.. ":badd " folder))))

(fn configure-lsp [server [cmd filetypes markers ?settings]]
  (let [cfg {
        :cmd cmd
        :filetypes filetypes
        :root_markers markers}]
    (when ?settings
      (tset cfg :settings ?settings))
    (tset vim.lsp.config server cfg)))



(custom-command "ProjectNote" project-note)
(custom-command "DeletePack" delete-pack)
(custom-command "License" get-license 1)

(local lsps {
    :gopls [[(vim.fs.normalize "~/.config/go/bin/gopls")] [ "go" "gomod" ] [ "go.mod" "go.sum" ]]
    :clangd [["clangd"] [ "c" "cpp" ] [ "Makefile" "include" ".git" ]]
    :rust-analyzer [[(vim.fs.normalize "~/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin/rust-analyzer")] [ "rust" ] [ "Cargo.toml" "target" ".git" ]]})

(each [k v (pairs lsps)]
  (configure-lsp k v)
  (vim.lsp.enable k))


