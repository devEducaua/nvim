local function bootstrap_pckr()
    local pckr_path = vim.fn.stdpath("data") .. "/pckr/pckr.nvim"
  
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
    "nvim-mini/mini.pairs",
    "nvim-mini/mini.pick",
    "nvim-mini/mini.comment",
    "nvim-mini/mini-git",
    "williamboman/mason.nvim",
    "L3MON4D3/LuaSnip",
    { "saghen/blink.cmp", requires = { "rafamadriz/friendly-snippets" }},
    { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" },
    {
        "stevearc/oil.nvim",
        ---@module 'oil'
        ---@type oil.SetupOpts
        requires = { "nvim-tree/nvim-web-devicons" },
    }
}

require("configs")
