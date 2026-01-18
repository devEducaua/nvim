local ls = require("luasnip")

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("typescript", {
    s("exp", {
        t("export default class "), i(1, "name"), t(" {"),
        t({ "", "\t"}), i(2),
        t({ "", "}" }),
    }),

    s("method", {
        t({"", "\t"}), i(1), t("() {"),
        t({ "", "\t"}), i(2),
        t({ "", "}" }),
    }),

    s("amethod", {
        t({"", "async "}), i(1), t("() {"),
        t({ "", "\t"}), i(2),
        t({ "", "}" }),
    }),
})

ls.add_snippets("c", {
    s("main", {
        t("#include <stdio.h>"),
        t({ "", "", "" }),
        t("int main() {"),
        t({ "", "\t"}), i(0),
        t({ "", '\treturn 0;'}), t({ "", "}" }), 
    })
})

ls.add_snippets("html", {
    s("html", {
        t("<DOCTYPE html>"),
        t({"", "<html>"}),
        t({"", "<head>"}),
        t({"", "\t<meta charset='UTF-8'"}),
        t({"", "\t<meta name='viewport' content='width=device-width, initial-scale=1.0'>"}),
        t({"", "\t<title>Title</title>"}),
        t({"", "\t<link href='style.css' rel='stylesheet'>"}),
        t({"", "</head>"}),
        t({"", "<body>"}),
        t({"", "\t"}), i(1),
        t({"", '\t<script src="script.js"></script>'}),
        t({"", "</body>"}),
        t({"", "</html>"}),
    })
})

ls.add_snippets("jsonc", {
    s("tsconfig", {
        t("{"),
        t({" ", '\t"compilerOptions": {'}),
        t{" ", '\t\t"target": "ES2020",'},
        t{" ", '\t\t"module": "esnext",'},
        t{" ", '\t\t"moduleResolution": "node",'},
        t{" ", '\t\t"outDir": "dist",'},
        t{" ", '\t\t"rootDir": "src",'},
        t{" ", '\t\t"strict": true,'},
        t{" ", '\t\t"esModuleInterop": true,'},
        t{" ", '\t\t"skipLibCheck": true'},
        t{" ", "\t},"},
        t{"", '\t"exclude": ['},
        t{"", '\t\t"node_modules",'},
        t{"", '\t\t"test"'},
        t{"", '\t],'},
        t{"", '\t"include": ["src"]'},
        t({" ", "}"})
    })
})

ls.add_snippets("tex", {
    s("basic", {
        t({"\\documentclass{article}"}),
        t({"", ""}),
        t({"", "\\author{Indu}"}),
        t({"", "\\title{"}), i(1), t("}"),
        t({"", ""}),
        t({"", "\\begin{document}"}),
        t({"", ""}),
        t({"", "\\end{document}"}),
    })
})

ls.add_snippets("markdown", {
    s("a", {
        t("["), i(1), t("]"), t("("), i(2), t(")")
    })
})
