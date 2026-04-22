
(set vim.o.syntax "on")
(set vim.o.termguicolors true)
(set vim.opt.list false)

(local colors {
   :bg "#000000"
   :comment "#777777"
   :fg "#aaaaaa"
   :string "#268038" })

(local groups {
    ;; normal
    :Normal {:bg colors.bg :fg colors.fg}
    :LineNr {:fg colors.fg}
    :CurSearch {:bg colors.fg :fg colors.fg}
    :Cursor {:bg colors.fg :fg colors.fg}
    :CursorLine {:bg colors.non_text}
    :Changed {:fg colors.fg}
    :QuickFixLine {:fg colors.fg}
    :Pmenu {:bg colors.bg :fg colors.fg}
    :PmenuSel {:bg colors.fg :fg colors.bg}
    :StatusLine {:bg colors.bg :fg colors.fg}
    :StatusLineNC {:bg colors.bg :fg colors.fg}

    ;; syntax
    :Boolean {:fg colors.fg}
    :Attribute {:fg colors.fg}
    :Comment {:fg colors.comment}
    :Conditional {:fg colors.fg}
    :Constant {:fg colors.fg}
    :Constructor {:fg colors.fg}
    :Delimiter {:fg colors.fg}
    :Directory {:fg colors.fg}
    :Function {:fg colors.fg}
    :Identifier {:fg colors.fg}
    :Keyword {:fg colors.fg}
    :Label {:fg colors.fg}
    :MatchParen {:bg colors.fg :fg colors.bg}
    :Method {:fg colors.fg}
    :Number {:fg colors.fg}
    :String {:fg colors.string}
    :Title {:fg colors.fg}
    :Todo {:bg :NONE :fg colors.comment :italic false}
    :Visual {:bg colors.fg :fg colors.bg}
    :Type {:fg colors.fg}
    :Property {:fg colors.fg}
    :Question {:fg colors.fg}
    :Repeat {:fg colors.fg}
    :Special {:fg colors.fg}
    :SpecialChar {:fg colors.fg}
    :Statement {:fg colors.fg}
    :Operator {:fg colors.fg}
    :PreProc {:fg colors.fg}

    ;; diagnostics
    :DiagnosticError {:sp colors.fg}
    :DiagnosticHint {:sp colors.fg}
    :DiagnosticInfo {:sp colors.fg}
    :DiagnosticSignError {:sp colors.fg}
    :DiagnosticSignWarn {:sp colors.fg}
    :DiagnosticUnderlineError {:sp colors.fg :undercurl true}
    :DiagnosticUnderlineWarn {:sp colors.fg :undercurl true}
    :DiagnosticWarn {:sp colors.fg}

    ;; diff
    :DiffAdd {:bg colors.fg :fg :NONE}
    :DiffChange {:bg colors.fg :fg :NONE}
    :DiffDelete {:bg colors.fg :fg :NONE}
    :DiffText {:bg colors.fg :fg :NONE}

    ;; treesitter
    "@variable" {:fg colors.fg}

    ;; oil
    :OilChange {:fg colors.fg}
    :OilCopy {:fg colors.fg}
    :OilCreate {:fg colors.fg}
    :OilDelete {:fg colors.fg}
    :OilDir {:fg colors.fg}
    :OilDirHidden {:fg colors.fg}
    :OilDirIcon {:fg colors.fg}
    :OilLink {:fg colors.fg}
    :OilLinkHidden {:fg colors.fg}
    :OilLinkTarget {:fg colors.fg}
    :OilLinkTargetHidden {:fg colors.fg}
    :OilMove {:fg colors.fg}
    :OilOrphanLink {:fg colors.fg}
    :OilOrphanLinkHidden {:fg colors.fg}
    :OilOrphanLinkTarget {:fg colors.fg}
    :OilOrphanLinkTargetHidden {:fg colors.fg}
    :OilPurge {:fg colors.fg}
    :OilRestore {:fg colors.fg}
    :OilSocket {:fg colors.fg}
    :OilSocketHidden {:fg colors.fg}
    :OilTrash {:fg colors.fg}
    :OilTrashSourcePath {:fg colors.fg}
    :Oilfile {:fg colors.fg}
    :OilfileHidden {:fg colors.fg}
    :ErrorMsg {:fg colors.fg}
    :ModeMsg {:fg colors.fg}
    :MoreMsg {:fg colors.fg}
    :WarningMsg {:fg colors.fg}})


(each [group colors (pairs groups)] (vim.api.nvim_set_hl 0 group colors))

