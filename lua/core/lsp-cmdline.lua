local M = {}

function M.setup()
  vim.api.nvim_create_autocmd("CmdlineEnter", {
    pattern = ":",
    callback = function()
      -- 激活命令行 LSP 上下文
      require("lspconfig.util").activate_lsp_clients({ bufnr = 0 })
    end
  })

  -- 为命令行注册特殊 LSP 处理器
  vim.lsp.handlers["textDocument/signatureHelp"] = function(_, result, ctx, config)
    if vim.fn.mode() == "c" then  -- 仅在命令行模式触发
      require("noice").util.open_floating({
        relative = "editor",
        focusable = false,
        border = "rounded",
        position = {
          row = 0,  -- 顶部显示
          col = "50%"
        },
        size = {
          width = 60,
          height = "auto"
        },
        buf_options = {
          filetype = "markdown"
        }
      }, function(content)
        if result and result.signatures then
          local active = result.activeSignature or 0
          content[#content + 1] = "```"..ctx.params.textDocument.languageId
          content[#content + 1] = result.signatures[active + 1].label
          content[#content + 1] = "```"
        end
      end)
    else
      -- 普通模式使用默认处理
      vim.lsp.handlers.signature_help(_, result, ctx, config)
    end
  end
end

return M
