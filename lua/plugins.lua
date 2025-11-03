local function bootstrap_pckr()
    local pckr_path = vim.fn.stdpath("data") .. "/pckr/pckr.nvim"
    --print(pckr_path)
  
    if not (vim.uv or vim.loop).fs_stat(pckr_path) then
        vim.fn.system({
            'git',
            'clone',
            "--filter=blob:none",
            'https://github.com/lewis6991/pckr.nvim',
            pckr_path
        })
    end
  
    vim.opt.rtp:prepend(pckr_path)
end

bootstrap_pckr()

local pckr = require("pckr")

pckr.add{
    { "~/proj/oradark.nvim", branch = "minimal" },

    "nvim-mini/mini.pairs",
    "numToStr/Comment.nvim",
    "williamboman/mason.nvim",
    "L3MON4D3/LuaSnip",

    {
        "saghen/blink.cmp",
        requires = { "rafamadriz/friendly-snippets" },
        config = function ()
            require("blink.cmp").setup({
                snippets = { preset = "luasnip" },
                sources = {
                    default = { "lsp", "path", "snippets", "buffer" }
                },

                keymap = {
                    ['<CR>'] = { 'select_and_accept', 'fallback' },
                    ['<S-Tab>'] = { 'select_prev', 'fallback' },
                    ['<Tab>'] = { 'select_next', 'fallback' },
                },

                completion = { documentation = { auto_show = true }},
                fuzzy = { implementation = "lua" }
            })
        end
    },

    {
        "stevearc/oil.nvim",
        ---@module 'oil'
        ---@type oil.SetupOpts
        requires = { "nvim-tree/nvim-web-devicons" },
    },

    {
        "nvim-telescope/telescope.nvim",
        requires = { 'nvim-lua/plenary.nvim' },
        config = function ()
            require("telescope").setup({
                file_ignore_patterns = { "^node_modules/" },
                defaults = {
                    border = false,
                    prompt_position = "bottom",
                    layout_strategy = 'bottom_pane',
                    sorting_strategy = 'ascending',
                    results_title = false,
                    layout_config = {
                        width = 1,
                        height = 0.15,
                        preview_width = 0
                    },
                }
            })
        end
    },

    {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        config = function ()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "c", "lua", "bash", "typescript", "html", "css", "javascript", "astro", "markdown", "go", "python" },
                sync_install = false,
                auto_install = false,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                indent = {
                    enable = true,
                },
            })
        end
    }
}

require("snippets")
require('mini.pairs').setup({})
require("mason").setup()

local commands = require("commands")

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
    }, keymaps = {
        ["g."] = { "actions.toggle_hidden", mode = "n" },
        ["g,"] = { "actions.cd", mode = "n" },

        ["<space>l"] = {
            desc = "download template license",
            callback = function ()
                vim.fn.feedkeys(":License ")
            end
        },

        ["<space>h"] = {
            desc = "pass file to command",
            callback = function ()
               local name = commands.get_path(require("oil").get_cursor_entry().name)
               local keys = "q:" .. "iCmd " .. name .. "<esc>Bi"
               keys = vim.api.nvim_replace_termcodes(keys, true, false, true)
               vim.api.nvim_feedkeys(keys, 'n', false)
            end
        },

        ["<space>r"] = {
            desc = "run file executables or Makefiles",
            callback = function ()
                local name = require("oil").get_cursor_entry().name
                commands.exec_by_name(name)
            end
        },

        ["<space>ga"] = {
            desc = "stage file on git",
            callback = function ()
                local file = commands.get_path(require("oil").get_cursor_entry().name)
                vim.fn.feedkeys(":Cmd git add " .. get_path(file), "nt")
            end
        },

        ["<space>grm"] = {
            desc = "remove file from git",
            callback = function ()
                local file = commands.get_path(require("oil").get_cursor_entry().name)
                vim.fn.feedkeys(":Cmd git rm " .. get_path(file), "nt")
            end
        },
    },
})
