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

opt.hlsearch = false

vim.api.nvim_set_hl(0, "Normal", { bg = "#1a1b26" })
vim.api.nvim_set_hl(0, "LineNr", { fg = "#a9b1d6", bold = true })

-- 修改 LSP 诊断符号颜色
vim.api.nvim_set_hl(0, "DiagnosticSignError", { link = "LspDiagnosticsDefaultError" })
