local colors = {
    bg = "#000000",
    fg = "#ffffff",
    non_text = "#1e1e1e",
    light = "#e5e5e5",
    light_g = "#777777",
    dark_g  = "#7a7a7a",
    grey = "#444444",
    dark = "#333333",
    orange = "#d17e25",
    red = "#d14d4d",
    yellow = "#e6c65c",
    green = "#65a765"
}

local groups = {
    -- Ui
    Normal = { fg = colors.light_g, bg = colors.bg },
    Changed = { fg = colors.orange },
    LineNr = { fg = colors.dark },
    Visual = { bg = colors.light_g, fg = colors.bg },
    Directory = { fg = colors.grey },
    Cursor = { bg = colors.fg, fg = colors.light_g },
    CurSearch = { bg = colors.dark, fg = colors.light_g },
    Pmenu = { bg = colors.bg, fg = colors.light_g },
    PmenuSel = { bg = colors.dark, fg = colors.bg },
    Whitespace = { fg = colors.non_text },
    NonText = { fg = colors.non_text },
    CursorLine = { bg = colors.non_text },
    StatusLine = { fg = colors.light_g, bg = colors.bg },
    StatusLineNC = { fg = colors.light_g, bg = colors.bg },
    QuickFixLine = { fg = colors.orange },

    -- Syntax
    Comment = { fg = colors.dark, italic = true },
    String = { fg = colors.orange },
    Number = { fg = colors.light_g },
    Keyword = { fg = colors.grey, bold = true },
    Function = { fg = colors.orange },
    Property = { fg = colors.dark },
    Method = { fg = colors.light_g },
    Attribute = { fg = colors.light_g },
    Constructor = { fg = colors.light_g },
    Delimiter = { fg = colors.light_g },
    Special = { fg = colors.dark_g },
    Identifier = { fg = colors.grey },
    Type = { fg = colors.orange },
    Constant = { fg = colors.light },
    Statement = { fg = colors.light },
    MatchParen = { bg = colors.grey },
    Title = { fg = colors.orange },

    -- Lsp
    DiagnosticError = { sp = colors.red },
    DiagnosticWarn = { sp = colors.yellow },
    DiagnosticInfo = { sp = colors.light_g },
    DiagnosticHint = { sp = colors.light_g },
    DiagnosticSignError = { sp = colors.red },
    DiagnosticSignWarn = { sp = colors.yellow },
    DiagnosticUnderlineError = { sp = colors.red, undercurl = true },
    DiagnosticUnderlineWarn = { sp = colors.yellow, undercurl = true },

    -- Msg
    ModeMsg = { fg = colors.orange },
    MoreMsg = { fg = colors.orange },
    WarningMsg = { fg = colors.yellow },
    ErrorMsg = { fg = colors.red },
    Question = { fg = colors.orange },

    -- Diff
    DiffAdd = { fg = "NONE", bg = colors.green },
    DiffChange = { fg = "NONE", bg = colors.yellow },
    DiffText = { fg = "NONE", bg = colors.dark },
    DiffDelete = { fg = "NONE", bg = colors.red },

    -- Telescope
    TelescopeSelection = { fg =  colors.bg, bg = colors.grey },

    -- Oil
    Oilfile = { fg = colors.light },
    OilfileHidden = { fg = colors.light },
    OilDir = { fg = colors.grey },
    OilDirHidden = { fg = colors.grey },
    OilDirIcon = { fg = colors.grey },
    OilSocket = { fg = colors.light },
    OilSocketHidden = { fg = colors.light },
    OilLink = { fg = colors.grey },
    OilLinkHidden = { fg = colors.grey },
    OilOrphanLink = { fg = colors.grey },
    OilOrphanLinkHidden = { fg = colors.grey },
    OilLinkTarget = { fg = colors.grey },
    OilLinkTargetHidden = { fg = colors.grey },
    OilOrphanLinkTarget = { fg = colors.grey },
    OilOrphanLinkTargetHidden = { fg = colors.grey },
    OilCreate = { fg = colors.orange },
    OilChange = { fg = colors.yellow },
    OilCopy = { fg = colors.orange },
    OilMove = { fg = colors.yellow },
    OilRestore = { fg = colors.green },
    OilDelete = { fg = colors.red },
    OilPurge = { fg = colors.red },
    OilTrash = { fg = colors.red },
    OilTrashSourcePath = { fg = colors.red },

    -- General
    ["@variable"] = { fg = colors.light_g },

    -- Fish
    ["@variable.fish"] = { fg = colors.light_g },
    ["@function.builtin.fish"] = { fg = colors.dark },

    -- C
    ["@variable.c"] = { fg = colors.grey },
    ["@lsp.type.variable.c"] = { fg = colors.grey },

    -- Makefile
    ["@string.special.symbol.make"] = { fg = colors.orange },

    -- Typescript
    ["@type.builtin.typescript"] = { fg = colors.light },

    ["@tag.html"] = { fg = colors.grey },
    ["@tag.delimiter.html"] = { fg = colors.grey },
    ["@constant.html"] = { fg = colors.grey },

    -- Markdown
    ["@markup.heading"] = { fg = colors.orange },
    ["@markup.list.checked.markdown"] = { fg = colors.orange },
}

for group, opts in pairs(groups) do
    vim.api.nvim_set_hl(0, group, opts)
end
