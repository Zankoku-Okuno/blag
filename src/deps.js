window.rp = require('request-promise-native')

window.md = require('markdown-it')({
                    html: true,
                    typographer: true,
                })
                .use(require("markdown-it-checkbox"))
                .use(require("markdown-it-container"), "aside", {
                    validate: function (params) {
                        return params.trim().match(/^aside(\s+[a-zA-Z_-]+)?$/)
                    },
                    render: function (tokens, idx) {
                        if (tokens[idx].nesting === 1) {
                            var m = tokens[idx].info.trim().match(/^aside(\s+[a-zA-Z_-]+)?$/)
                            var attrs = m === null ? "" : (" class='"+m[1]+"'")
                            return "<aside"+attrs+">\n"
                        }
                        else {
                            return "</aside>\n"
                        }
                    },
                })
                .use(require("markdown-it-footnote"))
                .use(require("markdown-it-katex"))
                .use(require("markdown-it-sub"))
                .use(require("markdown-it-sup"))
                .use(require("markdown-it-toc"))
