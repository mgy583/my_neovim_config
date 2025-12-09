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
        show_keys = true,
        triggers = "auto",
        triggers_blacklist = {
            i = { "j", "k" },
            v = { "j", "k" },
        },
    },
    config = function(_, opts)
        local wk = require("which-key")
        wk.setup(opts)
        
        -- Register key groups and mappings with descriptions
        wk.register({
            ["<leader>e"] = {
                name = "Explorer",
                e = { ":Neotree toggle<CR>", "Toggle Explorer" },
                f = { ":Neotree focus<CR>", "Focus Explorer" },
                r = { ":Neotree reveal<CR>", "Reveal in Explorer" },
            },
            ["<leader>f"] = {
                name = "Find/File",
                f = { ":Telescope find_files<CR>", "Find Files" },
                g = { ":Telescope live_grep<CR>", "Live Grep" },
                b = { ":Telescope buffers<CR>", "Buffers" },
                h = { ":Telescope help_tags<CR>", "Help Tags" },
                r = { ":Telescope oldfiles<CR>", "Recent Files" },
                w = { ":Telescope grep_string<CR>", "Find Word" },
            },
            ["<leader>s"] = {
                name = "Split/Search",
                v = { "<C-w>v", "Split Vertical" },
                h = { "<C-w>s", "Split Horizontal" },
            },
            ["<leader>n"] = {
                name = "No/New",
                h = { ":nohl<CR>", "No Highlight" },
            },
            ["<leader>l"] = {
                name = "LSP",
                d = { vim.lsp.buf.definition, "Go to Definition" },
                D = { vim.lsp.buf.declaration, "Go to Declaration" },
                h = { vim.lsp.buf.hover, "Hover Documentation" },
                i = { vim.lsp.buf.implementation, "Go to Implementation" },
                r = { vim.lsp.buf.references, "References" },
                R = { vim.lsp.buf.rename, "Rename" },
                a = { vim.lsp.buf.code_action, "Code Action" },
                f = { vim.lsp.buf.format, "Format" },
            },
            ["<leader>b"] = {
                name = "Buffer",
                d = { ":bdelete<CR>", "Delete Buffer" },
                n = { ":bnext<CR>", "Next Buffer" },
                p = { ":bprevious<CR>", "Previous Buffer" },
            },
            ["<leader>w"] = {
                name = "Window",
                h = { "<C-w>h", "Move to Left Window" },
                j = { "<C-w>j", "Move to Lower Window" },
                k = { "<C-w>k", "Move to Upper Window" },
                l = { "<C-w>l", "Move to Right Window" },
                c = { "<C-w>c", "Close Window" },
                o = { "<C-w>o", "Close Other Windows" },
            },
            ["<leader>g"] = {
                name = "Git",
                s = { ":Telescope git_status<CR>", "Git Status" },
                c = { ":Telescope git_commits<CR>", "Git Commits" },
                b = { ":Telescope git_branches<CR>", "Git Branches" },
            },
            ["<leader>t"] = {
                name = "Terminal/Tab",
                t = { ":terminal<CR>", "Open Terminal" },
                n = { ":tabnew<CR>", "New Tab" },
                c = { ":tabclose<CR>", "Close Tab" },
            },
        })
    end,
}
