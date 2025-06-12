-- lua/plugins/lsp.lua
return {
    -- Mason 基础插件 - 只用于手动安装语言服务器
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        cmd = "Mason",
        config = function()
            require("mason").setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗"
                    }
                }
            })
        end,
    },
    
    -- LSP 核心配置 - 手动配置所有语言服务器
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            "hrsh7th/cmp-nvim-lsp",
            {
                "glepnir/lspsaga.nvim",
                branch = "main",
                config = function()
                    require("lspsaga").setup({
                        -- 修复可能的 gitsigns 冲突
                        diagnostic = {
                            on_insert = false,
                            on_insert_follow = false,
                        },
                        lightbulb = {
                            enable = false,
                        },
                        symbol_in_winbar = {
                            enable = false,
                        }
                    })
                end,
                keys = {
                    { "gh", "<cmd>Lspsaga lsp_finder<CR>", desc = "LSP Finder" },
                    { "<leader>ca", "<cmd>Lspsaga code_action<CR>", desc = "Code Action" },
                    { "gd", "<cmd>Lspsaga peek_definition<CR>", desc = "Peek Definition" },
                    { "gr", "<cmd>Lspsaga rename<CR>", desc = "Rename" },
                    { "<leader>cd", "<cmd>Lspsaga show_line_diagnostics<CR>", desc = "Line Diagnostics" },
                }
            }
        },
        config = function()
            -- 修复 gitsigns 异步冲突
            vim.g.gitsigns_async = 0
            
            local lspconfig = require("lspconfig")
            local cmp_nvim_lsp = require("cmp_nvim_lsp")
            
            -- 设置 LSP 能力
            local capabilities = cmp_nvim_lsp.default_capabilities()
            capabilities.textDocument.completion.completionItem.snippetSupport = true
            capabilities.textDocument.completion.completionItem.resolveSupport = {
                properties = { "documentation", "detail", "additionalTextEdits" },
            }

            -- 通用按键映射
            local on_attach = function(client, bufnr)
                local opts = { buffer = bufnr, silent = true }
                
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
                vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
            end

            -- 手动配置各个语言服务器
            -- Lua
            lspconfig.lua_ls.setup({
                on_attach = on_attach,
                capabilities = capabilities,
                settings = {
                    Lua = {
                        runtime = { version = "LuaJIT" },
                        diagnostics = { globals = { "vim" } },
                        workspace = { 
                            checkThirdParty = false,
                            library = vim.api.nvim_get_runtime_file("", true)
                        },
                        telemetry = { enable = false },
                    }
                }
            })

            -- Python
            lspconfig.pyright.setup({
                on_attach = on_attach,
                capabilities = capabilities,
                settings = {
                    pyright = {
                        disableOrganizeImports = false,
                        analysis = {
                            useLibraryCodeForTypes = true,
                            autoSearchPaths = true,
                            diagnosticMode = "workspace",
                            typeCheckingMode = "basic"
                        }
                    }
                }
            })

            -- C/C++
            lspconfig.clangd.setup({
                on_attach = on_attach,
                capabilities = capabilities,
                cmd = {
                    "clangd",
                    "--background-index",
                    "--clang-tidy",
                    "--header-insertion=iwyu",
                    "--completion-style=detailed",
                    "--function-arg-placeholders",
                    "--fallback-style=llvm"
                },
                capabilities = {
                    offsetEncoding = "utf-8",
                }
            })

            -- Go
            lspconfig.gopls.setup({
                on_attach = on_attach,
                capabilities = capabilities,
                cmd = {"gopls"},
                settings = {
                    gopls = {
                        analyses = {
                            unusedparams = true,
                            shadow = true,
                            nilness = true,
                            unusedwrite = true,
                            useany = true,
                        },
                        staticcheck = true,
                        hints = {
                            assignVariableTypes = true,
                            compositeLiteralFields = true,
                            compositeLiteralTypes = true,
                            constantValues = true,
                            functionTypeParameters = true,
                        },
                        codelenses = {
                            generate = true,
                            gc_details = true,
                            test = true,
                            tidy = true,
                        }
                    }
                }
            })

            -- Rust
            lspconfig.rust_analyzer.setup({
                on_attach = on_attach,
                capabilities = capabilities,
                settings = {
                    ["rust-analyzer"] = {
                        checkOnSave = {
                            command = "clippy",
                            extraArgs = { "--all-targets", "--", "-D", "warnings" }
                        },
                        inlayHints = {
                            typeHints = true,
                            parameterHints = true,
                            chainingHints = true,
                        },
                        cargo = {
                            features = "all",
                        }
                    }
                }
            })

            -- 可以继续添加其他语言服务器...
        end
    },
    
    -- 自动补全系统
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lua",
            "saadparwaiz1/cmp_luasnip",
            "L3MON4D3/LuaSnip",
            "rafamadriz/friendly-snippets",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            -- 加载代码片段
            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "path" },
                    { name = "nvim_lua" },
                }),
                formatting = {
                    format = function(entry, vim_item)
                        vim_item.menu = ({
                            nvim_lsp = "[LSP]",
                            luasnip = "[Snippet]",
                            buffer = "[Buffer]",
                            path = "[Path]",
                        })[entry.source.name]
                        return vim_item
                    end
                },
                experimental = {
                    ghost_text = true,
                }
            })
        end
    }
}
