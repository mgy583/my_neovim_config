-- lua/plugins/neo-tree.lua
return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    keys = {
        { "<leader>e", ":Neotree toggle<CR>", desc = "Toggle Explorer" },
        { "<leader>ee", ":Neotree toggle<CR>", desc = "Toggle Explorer" },
        { "<leader>ef", ":Neotree focus<CR>", desc = "Focus Explorer" },
        { "<leader>er", ":Neotree reveal<CR>", desc = "Reveal in Explorer" },
    },
    opts = {
        close_if_last_window = true,
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,
        default_component_configs = {
            container = {
                enable_character_fade = true
            },
            indent = {
                indent_size = 2,
                padding = 1,
                with_markers = true,
                indent_marker = "│",
                last_indent_marker = "└",
                highlight = "NeoTreeIndentMarker",
                with_expanders = true,
                expander_collapsed = "",
                expander_expanded = "",
                expander_highlight = "NeoTreeExpander",
            },
            icon = {
                folder_closed = "",
                folder_open = "",
                folder_empty = "",
                default = "",
                highlight = "NeoTreeFileIcon"
            },
            modified = {
                symbol = "●",
                highlight = "NeoTreeModified",
            },
            name = {
                trailing_slash = false,
                use_git_status_colors = true,
                highlight = "NeoTreeFileName",
            },
            git_status = {
                symbols = {
                    added     = "✚",
                    modified  = "",
                    deleted   = "✖",
                    renamed   = "➜",
                    untracked = "★",
                    ignored   = "◌",
                    unstaged  = "✗",
                    staged    = "✓",
                    conflict  = "",
                }
            },
        },
        window = {
            position = "left",
            width = 35,
            mapping_options = {
                noremap = true,
                nowait = true,
            },
            mappings = {
                ["<space>"] = "toggle_node",
                ["<2-LeftMouse>"] = "open",
                ["<cr>"] = "open",
                ["<esc>"] = "cancel",
                ["P"] = { "toggle_preview", config = { use_float = true } },
                ["l"] = "open",
                ["S"] = "open_split",
                ["s"] = "open_vsplit",
                ["t"] = "open_tabnew",
                ["w"] = "open_with_window_picker",
                ["C"] = "close_node",
                ["z"] = "close_all_nodes",
                ["a"] = {
                    "add",
                    config = {
                        show_path = "none"
                    }
                },
                ["A"] = "add_directory",
                ["d"] = "delete",
                ["r"] = "rename",
                ["y"] = "copy_to_clipboard",
                ["x"] = "cut_to_clipboard",
                ["p"] = "paste_from_clipboard",
                ["c"] = "copy",
                ["m"] = "move",
                ["q"] = "close_window",
                ["R"] = "refresh",
                ["?"] = "show_help",
                ["<"] = "prev_source",
                [">"] = "next_source",
                ["i"] = "show_file_details",
            }
        },
        filesystem = {
            filtered_items = {
                visible = false,
                hide_dotfiles = false,
                hide_gitignored = false,
                hide_hidden = true,
                hide_by_name = {},
                hide_by_pattern = {},
                always_show = {},
                never_show = {},
                never_show_by_pattern = {},
            },
            follow_current_file = {
                enabled = true,
                leave_dirs_open = false,
            },
            group_empty_dirs = false,
            hijack_netrw_behavior = "open_default",
            use_libuv_file_watcher = false,
            window = {
                mappings = {
                    ["<bs>"] = "navigate_up",
                    ["."] = "set_root",
                    ["H"] = "toggle_hidden",
                    ["/"] = "fuzzy_finder",
                    ["D"] = "fuzzy_finder_directory",
                    ["#"] = "fuzzy_sorter",
                    ["f"] = "filter_on_submit",
                    ["<c-x>"] = "clear_filter",
                    ["[g"] = "prev_git_modified",
                    ["]g"] = "next_git_modified",
                    ["o"] = { "show_help", nowait=false, config = { title = "Order by", prefix_key = "o" }},
                    ["oc"] = { "order_by_created", nowait = false },
                    ["od"] = { "order_by_diagnostics", nowait = false },
                    ["og"] = { "order_by_git_status", nowait = false },
                    ["om"] = { "order_by_modified", nowait = false },
                    ["on"] = { "order_by_name", nowait = false },
                    ["os"] = { "order_by_size", nowait = false },
                    ["ot"] = { "order_by_type", nowait = false },
                },
                fuzzy_finder_mappings = {
                    ["<down>"] = "move_cursor_down",
                    ["<C-n>"] = "move_cursor_down",
                    ["<up>"] = "move_cursor_up",
                    ["<C-p>"] = "move_cursor_up",
                },
            },
        },
        buffers = {
            follow_current_file = {
                enabled = true,
                leave_dirs_open = false,
            },
            group_empty_dirs = true,
            show_unloaded = true,
        },
        git_status = {
            window = {
                position = "float",
                mappings = {
                    ["A"]  = "git_add_all",
                    ["gu"] = "git_unstage_file",
                    ["ga"] = "git_add_file",
                    ["gr"] = "git_revert_file",
                    ["gc"] = "git_commit",
                    ["gp"] = "git_push",
                    ["gg"] = "git_commit_and_push",
                }
            }
        },
        event_handlers = {
            {
                event = "neo_tree_buffer_enter",
                handler = function()
                    vim.cmd [[
                        setlocal relativenumber
                    ]]
                end
            }
        },
    },
    config = function(_, opts)
        -- Custom highlights for neo-tree styling
        vim.cmd([[
            highlight NeoTreeNormal guibg=#1a1b26
            highlight NeoTreeNormalNC guibg=#1a1b26
            highlight NeoTreeEndOfBuffer guibg=#1a1b26
            highlight NeoTreeWinSeparator guifg=#3d59a1 guibg=#1a1b26
            highlight NeoTreeFloatBorder guifg=#3d59a1 guibg=#1a1b26
            highlight NeoTreeTitleBar guifg=#c0caf5 guibg=#3d59a1
        ]])
        
        require("neo-tree").setup(opts)
    end,
}

