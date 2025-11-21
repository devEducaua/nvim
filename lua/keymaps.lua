local map = vim.keymap.set
vim.g.mapleader = " "

map({"i", "v", "t"}, "jk", "<esc>")

map("t", "<esc>", "<c-\\><c-n>")
map("n", "<space>;", "q:", {})
map("t", "<A-q>", "<esc><esc>bd<CR>")

map("n", "<A-d>", ":cd %:p:h<CR>")

map("n", "<leader>b", ":b#<CR>")
map("n", "<leader>n", ":bn<CR>")
map("n", "<leader>B", ":bd<CR>")
map("n", "<leader>ls", ":ls<CR>")

map({"n", "v", "x", "c", "t"}, "<C-y>", '"+y', {})
map({"n", "v", "x", "c", "t"}, "<C-p>", '"+p', {})
map("i", "<C-p>", '<esc>"+pa')

map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "<C-f>", "<C-f>zz")
map("n", "<C-b>", "<C-b>zz")

map("n", "<leader>gd", ":Git diff<CR>", {})
map("n", "<leader>gD", ":Git diff>", {})
map("n", "<leader>gs", ":Git status<CR>", {})
map("n", "<leader>ga", ":Git add", {})
map("n", "<leader>gA", ":Git add %<CR>", {})
map("n", "<leader>gc", ":Git commit", {})
map("n", "<leader>gm", ":Git push -u origin", {})
map("n", "<leader>gm", ":Git push -u origin main<CR>", {})

map("n", "<leader>w", ":up<CR>", {})
map("n", "<leader>x", ":up<CR> :Oil<CR>", {})
map("n", "<leader>!", ":q!<CR>", {})
map("n", "<leader>q", ":bd!<CR>", {})
map("n", "<leader>s", ":w<CR>:so<CR>", {})

map("n", "<leader>f", ":Pick files<CR>")
map("n", "<leader>tt", ":Pick<CR>")
map("n", "<leader>th", ":Pick help<CR>")
map("n", "<leader>tb", ":Pick buffers<CR>")
map("n", "-", "<cmd>Oil<CR>", {})

vim.api.nvim_create_autocmd("CmdwinEnter", {
  callback = function()
    map("n", "<Esc>", "<C-c>", { buffer = true, noremap = true })
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = { "c", "sh", "man" },
    callback = function ()
        map({"v", "x", "n"}, "K", function ()
            vim.cmd("Man " .. vim.fn.expand("<cword>"))
        end, { buffer = true })
    end
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "man",
    callback = function ()
        map("n", "<A-l>", function() vim.opt_local.relativenumber = not vim.opt_local.relativenumber:get() end, { buffer = true })
    end
})
