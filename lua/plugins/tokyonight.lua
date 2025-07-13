-- 在 plugins 目录新建 tokyonight.lua
return {
  "folke/tokyonight.nvim",
  lazy = false,    -- 作为主主题需要立即加载
  priority = 1000, -- 确保优先加载
  config = function()
    require("tokyonight").setup({
      style = "storm", -- 可选: storm | night | day
      transparent = true, -- 启用透明背景
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      }
    })
    vim.cmd.colorscheme("tokyonight") -- 应用主题
  end
}
