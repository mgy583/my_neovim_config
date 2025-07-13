vim.g.mapleader = " "

local keymap = vim.keymap

-- 插入模式 --
keymap.set("i", "jk", "<ESC>")

-- 正常模式 --
-- 窗口
keymap.set("n", "<leader>sv", "<C-w>v") -- 水平新增窗口
keymap.set("n", "<leader>sh", "<C-w>s") -- 垂直新增窗口

-- 取消高亮
keymap.set("n", "<leader>nh", ":nohl<CR>")

-- 设置剪贴板
vim.g.clipboard = {
  name = "wl-clipboard",
  copy = {
    ["+"] = "wl-copy --foreground --type text/plain",
    ["*"] = "wl-copy --foreground --primary --type text/plain",
  },
  paste = {
    ["+"] = function() return vim.fn.systemlist("wl-paste --no-newline", "") end,
    ["*"] = function() return vim.fn.systemlist("wl-paste --no-newline --primary", "") end,
  },
  cache_enabled = true,
}

-- 关键映射
vim.api.nvim_set_keymap("v", "y", '"+y', { noremap = true, silent = true, desc = "copy" })
vim.api.nvim_set_keymap("n", "yy", '"+yy', { noremap = true, silent = true, desc = "copy" })

vim.api.nvim_set_keymap("n", "p", '"+p', { noremap = true, silent = true, desc = "paste" })
vim.api.nvim_set_keymap("v", "p", '"+p', { noremap = true, silent = true, desc = "paste" })

