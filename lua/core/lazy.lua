local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    rocks = {
        hererocks = false,  -- 禁用 hererocks
        enabled = false     -- 完全禁用 luarocks 支持
    },
    spec = {
        { import = "plugins" }
    },
    cmdline = {
        view = "cmdline_popup",  -- 浮动式命令行
    }
})
