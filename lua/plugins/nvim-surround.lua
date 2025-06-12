return {
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup({
            -- 是否在插入模式下自动添加括号
            insert = true,

            -- 是否在视觉模式下自动添加括号
            visual = true,

            -- 是否在删除时保留内容
            delete = "current",

            -- 是否在修改时保留内容
            change = "surround",

            -- 自定义环绕
            keymaps = {
            insert = "<C-g>s",
            insert_line = "<C-g>S",
            normal = "ys",
            normal_cur = "yss",
            normal_line = "yS",
            normal_line_cur = "ySS",
            visual = "S",
            visual_line = "gS",
            delete = "ds",
            change = "cs",
            change_line = "cS",
            },
        })        
    end,
  },
}
