return {
  "akinsho/bufferline.nvim",
  lazy = false,
  keys = {
    { "<leader>bh", "<cmd>BufferLineCyclePrev<CR>", desc = "Previous Buffer" },
    { "<leader>bl", "<cmd>BufferLineCycleNext<CR>", desc = "Next Buffer" },
    { "<leader>bd", "<cmd>bdelete<CR>", desc = "Delete Buffer" },
    { "<leader>bo", "<cmd>BufferLineCloseOthers<CR>", desc = "Close Other Buffers" },
    { "<leader>bp", "<cmd>BufferLinePick<CR>", desc = "Pick Buffer" },
    { "<leader>bc", "<cmd>BufferLinePickClose<CR>", desc = "Pick & Close Buffer" },
  },
  opts = {
    options = {
      diagnostics = "nvim_lsp",
      diagnostics_indicator = function(_, _, diagnostics_dict, _)
        local symbols = {
          error = " ",
          warning = " ",
          info = " ",
          hint = "󰌶 "  -- 补充默认未定义的提示级别图标
        }
        local indicator = ""
        for level, count in pairs(diagnostics_dict) do
          if symbols[level] then
            indicator = indicator .. count .. symbols[level]
          end
        end
        return indicator ~= "" and indicator or nil
      end,
      -- 推荐补充其他必要配置
      offsets = {
        {
          filetype = "NvimTree",
          text = "File Explorer",
          highlight = "Directory",
          text_align = "left"
        }
      },
      show_buffer_close_icons = false,
      separator_style = "slant"
    }
  },
  config = function(_, opts)
    -- 添加延迟加载保证 LSP 诊断就绪
    vim.schedule(function()
      require("bufferline").setup(opts)
    end)
  end
}
