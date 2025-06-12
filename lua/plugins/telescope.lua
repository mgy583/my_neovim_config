-- lua/plugins/telescope.lua
return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- 可选但推荐
      "nvim-tree/nvim-web-devicons", -- 可选图标支持
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      -- 基础配置
      telescope.setup({
        defaults = {
          mappings = {
            i = {
              -- ["<Esc>"] = actions.close,  -- 按 ESC 退出
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            },
          },
          file_ignore_patterns = {
            "node_modules", "%.git", "target", "build", "%.lock", "%.o", "%.a"
          },
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = { preview_width = 0.6 },
          },
          path_display = { "truncate" },
          dynamic_preview_title = true,
          winblend = 10, -- 窗口透明效果
        },
        pickers = {
          find_files = {
            hidden = true,  -- 包含隐藏文件
            no_ignore = false,
          },
          live_grep = {
            additional_args = function(opts)
              return { "--hidden" }  -- 包含隐藏文件内容
            end
          }
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          }
        }
      })

      -- 加载扩展
      pcall(telescope.load_extension, "fzf")
      -- 设置快捷键
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live Grep" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find Buffers" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help Tags" })
      vim.keymap.set("n", "<leader>fr", builtin.lsp_references, { desc = "Find References" })
      vim.keymap.set("n", "gr", builtin.lsp_definitions, { desc = "Goto Definition" })
    end
  },

  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("file_browser")
      vim.keymap.set("n", "<leader>fe", function()
        require("telescope").extensions.file_browser.file_browser()
      end, { desc = "File Explorer" })
    end
  }
}
