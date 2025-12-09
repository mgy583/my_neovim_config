-- lua/plugins/toggleterm.lua
return {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = { "ToggleTerm", "TermExec" },
    keys = {
        { "<leader>tt", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" },
        { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Toggle Float Terminal" },
        { "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Toggle Horizontal Terminal" },
        { "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>", desc = "Toggle Vertical Terminal" },
    },
    opts = {
        size = function(term)
            if term.direction == "horizontal" then
                return 15
            elseif term.direction == "vertical" then
                return vim.o.columns * 0.4
            end
        end,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        terminal_mappings = true,
        persist_size = true,
        persist_mode = true,
        direction = "float",
        close_on_exit = true,
        shell = vim.o.shell,
        auto_scroll = true,
        float_opts = {
            border = "curved",
            winblend = 0,
            highlights = {
                border = "Normal",
                background = "Normal",
            },
        },
        winbar = {
            enabled = false,
            name_formatter = function(term)
                return term.name
            end
        },
    },
    config = function(_, opts)
        require("toggleterm").setup(opts)
        
        -- Terminal keymaps
        function _G.set_terminal_keymaps()
            local opts = {buffer = 0}
            vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
            vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
            vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
            vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
            vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
            vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
            vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
        end

        vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

        -- Create some terminal commands
        local Terminal = require('toggleterm.terminal').Terminal
        
        local lazygit = Terminal:new({
            cmd = "lazygit",
            dir = "git_dir",
            direction = "float",
            float_opts = {
                border = "double",
            },
            on_open = function(term)
                vim.cmd("startinsert!")
                vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
            end,
        })

        function _LAZYGIT_TOGGLE()
            lazygit:toggle()
        end

        vim.keymap.set("n", "<leader>tg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", { desc = "LazyGit", noremap = true, silent = true })
    end,
}
