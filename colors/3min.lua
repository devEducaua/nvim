
local colors = {
    bg =  "#000000",
    fg =  "#aaaaaa",
    comment =  "#777777",
    string =  "#268038"
}

-- Some comment
local groups = {
    Normal = { bg = colors.bg, fg = colors.fg },
    Comment = { fg = colors.comment },
    String = { fg = colors.string },
    Changed = { fg = colors.fg },
    LineNr = { fg = colors.fg },
    Visual = { bg = colors.fg, fg = colors.bg },
    Directory = { fg = colors.fg },
    Cursor = { bg = colors.fg, fg = colors.fg },
    CurSearch = { bg = colors.fg, fg = colors.fg },
    Pmenu = { bg = colors.bg, fg = colors.fg },
    PmenuSel = { bg = colors.fg, fg = colors.bg },
    CursorLine = { bg = colors.non_text },
    StatusLine = { fg = colors.fg, bg = colors.bg },
    StatusLineNC = { fg = colors.fg, bg = colors.bg },
    QuickFixLine = { fg = colors.fg },

    -- Syntax
    Number = { fg = colors.fg },
    Keyword = { fg = colors.fg},
    Function = { fg = colors.fg },
    Property = { fg = colors.fg },
    Method = { fg = colors.fg },
    Attribute = { fg = colors.fg },
    Constructor = { fg = colors.fg },
    Delimiter = { fg = colors.fg },
    Special = { fg = colors.fg },
    Identifier = { fg = colors.fg },
    Type = { fg = colors.fg },
    Constant = { fg = colors.fg },
    Statement = { fg = colors.fg},
    MatchParen = { bg = colors.fg, fg = colors.bg },
    Title = { fg = colors.fg },
    Boolean = { fg = colors.fg },
    Operator = { fg = colors.fg },
    Conditional = { fg = colors.fg},
    Repeat = { fg = colors.fg},
    Label = { fg = colors.fg},
    SpecialChar = { fg = colors.fg },
    Todo = { fg = colors.comment, bg = "NONE", italic = false },

    -- Lsp
    DiagnosticError = { sp = colors.fg },
    DiagnosticWarn = { sp = colors.fg },
    DiagnosticInfo = { sp = colors.fg },
    DiagnosticHint = { sp = colors.fg },
    DiagnosticSignError = { sp = colors.fg },
    DiagnosticSignWarn = { sp = colors.fg },
    DiagnosticUnderlineError = { sp = colors.fg, undercurl = true },
    DiagnosticUnderlineWarn = { sp = colors.fg, undercurl = true },

    -- Msg
    ModeMsg = { fg = colors.fg },
    MoreMsg = { fg = colors.fg },
    WarningMsg = { fg = colors.fg },
    ErrorMsg = { fg = colors.fg },
    Question = { fg = colors.fg },

    -- Diff
    DiffAdd = { fg = "NONE", bg = colors.fg },
    DiffChange = { fg = "NONE", bg = colors.fg },
    DiffText = { fg = "NONE", bg = colors.fg },
    DiffDelete = { fg = "NONE", bg = colors.fg },

    -- Oil
    Oilfile = { fg = colors.fg },
    OilfileHidden = { fg = colors.fg },
    OilDir = { fg = colors.fg },
    OilDirHidden = { fg = colors.fg },
    OilDirIcon = { fg = colors.fg },
    OilSocket = { fg = colors.fg },
    OilSocketHidden = { fg = colors.fg },
    OilLink = { fg = colors.fg },
    OilLinkHidden = { fg = colors.fg },
    OilOrphanLink = { fg = colors.fg },
    OilOrphanLinkHidden = { fg = colors.fg },
    OilLinkTarget = { fg = colors.fg },
    OilLinkTargetHidden = { fg = colors.fg },
    OilOrphanLinkTarget = { fg = colors.fg },
    OilOrphanLinkTargetHidden = { fg = colors.fg },
    OilCreate = { fg = colors.fg },
    OilChange = { fg = colors.fg },
    OilCopy = { fg = colors.fg },
    OilMove = { fg = colors.fg },
    OilRestore = { fg = colors.fg },
    OilDelete = { fg = colors.fg },
    OilPurge = { fg = colors.fg },
    OilTrash = { fg = colors.fg },
    OilTrashSourcePath = { fg = colors.fg },

    ["@variable"] = { fg = colors.fg }
}

vim.opt.listchars = {
    space = " ",
    tab = "  ",
    extends = ' ',
    precedes = ' ',
    nbsp = ' ',
}

for group, opts in pairs(groups) do
    vim.api.nvim_set_hl(0, group, opts)
end
