-- 在 plugins 目录下新建 lsp-cmdline.lua
return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
    "hrsh7th/nvim-cmp"  -- 确保已安装自动补全插件
  },
  opts = {
    lsp = {
      -- 在命令行中显示 LSP 进度
      progress = {
        enabled = true,
        format = "lsp_progress",
        format_done = "lsp_progress_done",
        throttle = 1000,
        view = "mini"
      },
      -- 将 LSP 签名帮助绑定到命令行
      signature = {
        enabled = true,
        auto_open = {
          enabled = true,
          trigger = true,
          luasnip = true,
          throttle = 50
        },
        view = "cmdline"  -- 在命令行区域显示
      }
    },
    presets = {
      command_palette = {
        lsp_doc_border = true  -- 为 LSP 文档添加边框
      }
    }
  }
}
