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
        { "<leader>ee", "<cmd>Neotree toggle<cr>", desc = "Toggle Explorer" },
        { "<leader>ef", "<cmd>Neotree focus<cr>", desc = "Focus Explorer" },
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
            },
            icon = {
                folder_closed = "",
                folder_open = "",
                folder_empty = "󰜌",
                default = "",
            },
            modified = {
                symbol = "[+]",
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
                    renamed   = "󰁕",
                    untracked = "",
                    ignored   = "",
                    unstaged  = "󰄱",
                    staged    = "",
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
                ["<space>"] = { 
                    "toggle_node", 
                    nowait = false,
                },
                ["<2-LeftMouse>"] = "open",
                ["<cr>"] = "open",
                ["<esc>"] = "cancel",
                ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
                ["l"] = "focus_preview",
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
                hide_hidden = false,
                hide_by_name = {
                    "node_modules"
                },
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
    },
}

