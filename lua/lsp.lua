local servers = { "luals", "ts_ls", "clangd", "bashls", "astro-language-server", "gopls", "cssls", "html", "denols" }

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        if client:supports_method('textDocument/implementation') then
            vim.keymap.set("n", "gli", vim.lsp.buf.implementation, { buffer = args.buf })
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = args.buf })
        end

        vim.keymap.set({ "n", "v", "x" }, "<leader>lf", vim.lsp.buf.format, {})
    end
})

vim.lsp.config["luals"] = {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = { "stylua.json", ".luarc.json", ".git" },
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim', 'love', 'core' }
            },
            workspace = {
                library = {
                    "/usr/share/luanti/builtin",
                    "/usr/share/luanti",
                    vim.env.VIMRUNTIME
                },
                checkThirdParty = true
            }
        }
    }
}

vim.lsp.config["astro-language-server"] = {
    cmd = { "astro-language-server" },
    filetypes = { "astro" },
    root_markers = { "astro.config.mjs" }
}

vim.lsp.config["ts_ls"] = {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = { "typescript", "javascript" },
    root_markers = { "node_modules/", "package.json", ".git" }
}

vim.lsp.config("denols", {
    cmd = { "deno", "lsp" },
    filetypes = { "javascript", "typescript" },
    root_markers = { "deno.json", "deno.jsonc", "deno.lock" },
})

vim.lsp.config["clangd"] = {
    cmd = { "clangd" },
    filetypes = { "c", "cpp" },
    root_markers = { "Makefile", ".git" }
}

vim.lsp.config["bashls"] = {
    cmd = { "bash-language-server" },
    filetypes = { "sh" }
}

vim.lsp.config["gopls"] = {
    cmd = { "gopls" },
    filetypes = { "go", "gomod" },
    root_markers = { "go.mod" }
}

vim.lsp.config["cssls"] = {
    cmd = { "vscode-css-language-server", "--stdio" },
    filetypes = { "css", "scss", "less" },
    root_markers = { "package.json", ".git" }
}

vim.lsp.config["html"] = {
    cmd = { "vscode-html-language-server", "--stdio" },
    filetypes = { "html", "astro" },
    root_markers = { ".git" }
}

vim.lsp.enable(servers)
for _, s in ipairs(servers) do
    vim.lsp.config[s].capabilities = capabilities
end
