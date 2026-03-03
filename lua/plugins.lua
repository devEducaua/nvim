
vim.pack.add({
    "https://github.com/williamboman/mason.nvim",
    "https://github.com/L3MON4D3/LuaSnip",
    "https://github.com/rafamadriz/friendly-snippets",
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/stevearc/oil.nvim",
    "https://github.com/nvim-mini/mini.completion",
})

require("snippets")
require("mason").setup()
require("mini.completion").setup()

require("nvim-treesitter.configs").setup({
    ensure_installed = { "c", "lua", "bash", "typescript", "html", "css", "javascript", "markdown", "go", "python" },
    sync_install = false,
    auto_install = false,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    indent = {
        enable = true,
        disable = { "html" }
    },
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
    }, keymaps = {
        ["g."] = { "actions.toggle_hidden", mode = "n" },
        ["g,"] = { "actions.cd", mode = "n" },
    },
})
