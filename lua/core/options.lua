local opt = vim.opt

-- 行号
opt.relativenumber = true
opt.number = true

-- 缩进
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

-- 自动重载
opt.autoread = true

-- 防止包裹
opt.wrap = false

-- 光标行
opt.cursorline = true

-- 启用鼠标
opt.mouse:append("a")

-- 启用系统剪切板
opt.clipboard:append("unnamedplus")

-- 默认最新窗口右和下
opt.splitright = true
opt.splitbelow = true

-- 搜索
opt.ignorecase = true
opt.smartcase = true

-- 外观
opt.termguicolors = true
opt.signcolumn = "yes"
-- 高亮设置
vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })        -- 透明背景
vim.api.nvim_set_hl(0, "LineNr", { 
    fg = "#a9b1d6", 
    bg = "NONE",          -- 行号透明背景
    bold = true 
})

vim.api.nvim_set_hl(0, "CursorLineNr", {
    fg = "#f7768e",       -- 当前行号特殊颜色
    bg = "NONE",
    bold = true
})

-- 其他需要透明背景的元素
local transparent_groups = {
    "NonText", "EndOfBuffer", "SignColumn", 
    "MsgArea", "FloatBorder", "TelescopeBorder"
}

for _, group in ipairs(transparent_groups) do
    vim.api.nvim_set_hl(0, group, { bg = "NONE" })
end

-- LSP 诊断符号设置 (更新为最新API)
vim.api.nvim_set_hl(0, "DiagnosticSignError", { 
    fg = "#f7768e", 
    bg = "NONE" 
})
vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { 
    fg = "#ff9e64", 
    bg = "NONE" 
})
vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { 
    fg = "#0db9d7", 
    bg = "NONE" 
})
vim.api.nvim_set_hl(0, "DiagnosticSignHint", { 
    fg = "#9ece6a", 
    bg = "NONE" 
})

-- 可选: 设置浮动窗口透明
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
vim.api.nvim_set_hl(0, "FloatBorder", {
    fg = "#7aa2f7",
    bg = "NONE"
})

-- 可选: 状态行透明
vim.api.nvim_set_hl(0, "StatusLine", {
    fg = "#a9b1d6",
    bg = "NONE"
})

opt.hlsearch = false

vim.api.nvim_set_hl(0, "Normal", { bg = "#1a1b26" })
vim.api.nvim_set_hl(0, "LineNr", { fg = "#a9b1d6", bold = true })
