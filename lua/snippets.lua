local ls = require("luasnip")

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

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
