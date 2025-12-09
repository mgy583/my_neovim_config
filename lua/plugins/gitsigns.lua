-- lua/plugins/gitsigns.lua
return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        signs = {
            add          = { text = '│' },
            change       = { text = '│' },
            delete       = { text = '_' },
            topdelete    = { text = '‾' },
            changedelete = { text = '~' },
            untracked    = { text = '┆' },
        },
        signcolumn = true,
        numhl      = false,
        linehl     = false,
        word_diff  = false,
        watch_gitdir = {
            interval = 1000,
            follow_files = true
        },
        attach_to_untracked = true,
        current_line_blame = false,
        current_line_blame_opts = {
            virt_text = true,
            virt_text_pos = 'eol',
            delay = 1000,
            ignore_whitespace = false,
        },
        current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil,
        max_file_length = 40000,
        preview_config = {
            border = 'rounded',
            style = 'minimal',
            relative = 'cursor',
            row = 0,
            col = 1
        },
        on_attach = function(bufnr)
            local gs = package.loaded.gitsigns

            local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
            end

            -- Navigation
            map('n', ']c', function()
                if vim.wo.diff then return ']c' end
                vim.schedule(function() gs.next_hunk() end)
                return '<Ignore>'
            end, {expr=true, desc = "Next Hunk"})

            map('n', '[c', function()
                if vim.wo.diff then return '[c' end
                vim.schedule(function() gs.prev_hunk() end)
                return '<Ignore>'
            end, {expr=true, desc = "Previous Hunk"})

            -- Actions
            map('n', '<leader>gs', gs.stage_hunk, { desc = "Stage Hunk" })
            map('n', '<leader>gr', gs.reset_hunk, { desc = "Reset Hunk" })
            map('v', '<leader>gs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = "Stage Hunk" })
            map('v', '<leader>gr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = "Reset Hunk" })
            map('n', '<leader>gS', gs.stage_buffer, { desc = "Stage Buffer" })
            map('n', '<leader>gu', gs.undo_stage_hunk, { desc = "Undo Stage Hunk" })
            map('n', '<leader>gR', gs.reset_buffer, { desc = "Reset Buffer" })
            map('n', '<leader>gp', gs.preview_hunk, { desc = "Preview Hunk" })
            map('n', '<leader>gb', function() gs.blame_line{full=true} end, { desc = "Blame Line" })
            map('n', '<leader>gtb', gs.toggle_current_line_blame, { desc = "Toggle Line Blame" })
            map('n', '<leader>gd', gs.diffthis, { desc = "Diff This" })
            map('n', '<leader>gD', function() gs.diffthis('~') end, { desc = "Diff This ~" })
            map('n', '<leader>gtd', gs.toggle_deleted, { desc = "Toggle Deleted" })

            -- Text object
            map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = "Select Hunk" })
        end
    },
}
