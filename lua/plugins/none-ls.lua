-- lua/plugins/none-ls.lua
return {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "williamboman/mason.nvim",
    },
    config = function()
        local null_ls = require("null-ls")
        local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

        -- Code action sources
        local code_actions = null_ls.builtins.code_actions

        -- Diagnostic sources
        local diagnostics = null_ls.builtins.diagnostics

        -- Formatting sources
        local formatting = null_ls.builtins.formatting

        -- Hover sources
        local hover = null_ls.builtins.hover

        null_ls.setup({
            sources = {
                -- Lua
                formatting.stylua,

                -- Python
                formatting.black,
                formatting.isort,
                diagnostics.pylint.with({
                    prefer_local = ".venv/bin",
                }),

                -- JavaScript/TypeScript
                formatting.prettier.with({
                    filetypes = {
                        "javascript",
                        "javascriptreact",
                        "typescript",
                        "typescriptreact",
                        "vue",
                        "css",
                        "scss",
                        "less",
                        "html",
                        "json",
                        "jsonc",
                        "yaml",
                        "markdown",
                        "markdown.mdx",
                        "graphql",
                        "handlebars",
                    },
                }),
                diagnostics.eslint_d.with({
                    condition = function(utils)
                        return utils.root_has_file({
                            ".eslintrc",
                            ".eslintrc.js",
                            ".eslintrc.json",
                        })
                    end,
                }),

                -- Shell
                formatting.shfmt,
                diagnostics.shellcheck,

                -- Go
                formatting.gofmt,
                formatting.goimports,

                -- Rust (handled by rust-analyzer usually, but can use rustfmt)
                formatting.rustfmt,

                -- C/C++
                formatting.clang_format,

                -- Markdown
                diagnostics.markdownlint,

                -- Git
                code_actions.gitsigns,

                -- Spell
                hover.dictionary,
            },

            -- Format on save
            on_attach = function(client, bufnr)
                if client.supports_method("textDocument/formatting") then
                    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = augroup,
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format({
                                bufnr = bufnr,
                                filter = function(client)
                                    return client.name == "null-ls"
                                end,
                            })
                        end,
                    })
                end
            end,
        })

        -- Keymaps
        vim.keymap.set("n", "<leader>cf", function()
            vim.lsp.buf.format({ async = true })
        end, { desc = "Format Code" })
    end,
}
