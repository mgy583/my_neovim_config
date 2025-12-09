-- lua/plugins/which-key.lua
return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
    end,
    opts = {
        plugins = {
            marks = true,
            registers = true,
            spelling = {
                enabled = true,
                suggestions = 20,
            },
            presets = {
                operators = true,
                motions = true,
                text_objects = true,
                windows = true,
                nav = true,
                z = true,
                g = true,
            },
        },
        operators = { gc = "Comments" },
        key_labels = {
            ["<space>"] = "SPC",
            ["<cr>"] = "RET",
            ["<tab>"] = "TAB",
        },
        icons = {
            breadcrumb = "»",
            separator = "➜",
            group = "+",
        },
        popup_mappings = {
            scroll_down = "<c-d>",
            scroll_up = "<c-u>",
        },
        window = {
            border = "rounded",
            position = "bottom",
            margin = { 1, 0, 1, 0 },
            padding = { 2, 2, 2, 2 },
            winblend = 0,
        },
        layout = {
            height = { min = 4, max = 25 },
            width = { min = 20, max = 50 },
            spacing = 3,
            align = "left",
        },
        ignore_missing = false,
        hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " },
        show_help = true,
        triggers = "auto",
        triggers_blacklist = {
            i = { "j", "k" },
            v = { "j", "k" },
        },
    },
    config = function(_, opts)
        local wk = require("which-key")
        wk.setup(opts)
        
        -- Register key groups with descriptions
        wk.register({
            ["<leader>f"] = { name = "+Find (Telescope)" },
            ["<leader>e"] = { name = "+Explorer" },
            ["<leader>s"] = { name = "+Split/Session" },
            ["<leader>c"] = { name = "+Code" },
            ["<leader>g"] = { name = "+Git" },
            ["<leader>l"] = { name = "+LSP" },
            ["<leader>t"] = { name = "+Terminal/Trouble" },
            ["<leader>b"] = { name = "+Buffer" },
            ["<leader>w"] = { name = "+Window" },
            ["<leader>n"] = { name = "+No Highlight" },
            ["<leader>x"] = { name = "+Diagnostics/Quickfix" },
        })
    end,
}
