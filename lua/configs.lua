require("snippets")
require("mason").setup()

require('mini.pairs').setup({})
require("mini.comment").setup({})
require("mini.git").setup({})
require("mini.pick").setup({
    options = {
        content_from_bottom = false
    },

    window = {
        config = function()
            return {
                col = 0,
                row = vim.o.lines,
                height = math.floor(vim.o.lines * 0.1),
                width = vim.o.columns,
                style = 'minimal',
                border = "none",
            }
        end,

        prompt_prefix = ' '
    },
})

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
            callback = function ()
                local name = require("oil").get_cursor_entry().name
                commands.exec_by_name(name)
            end
        },
    },
})
