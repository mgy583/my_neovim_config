-- lua/plugins/treesitter.lua
return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" }, -- 更推荐的加载方式
    cmd = {
      "TSUpdate",
      "TSInstallInfo",
      "TSInstall",
      "TSToggleHighlight",
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "windwp/nvim-ts-autotag",
      "JoosepAlviste/nvim-ts-context-commentstring",
     -- "mrjones2014/nvim-ts-rainbow",
    },
    opts = {
      -- ███ 基础配置 ███
      ensure_installed = {
        "lua", "vim", "vimdoc", "python",
        "javascript", "typescript", "html",
        "css", "json", "yaml", "bash",
        "markdown", "sql", "rust", "cpp"
      },
      sync_install = false,
      auto_install = true,

      -- ███ 核心功能 ███
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
        disable = function(lang, buf)
          -- 超过 100KB 文件禁用高亮
          local max_filesize = 100 * 1024
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          return ok and stats and stats.size > max_filesize
        end,
      },
      
      -- ███ 缩进配置 ███
      indent = {
        enable = true,
        disable = { "python" },
      },


      -- ███ 文本对象 ███
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["al"] = "@loop.outer",    -- 新增循环对象
            ["il"] = "@loop.inner"     -- 新增循环对象
          },
        },
        swap = {
          enable = true,  -- 启用对象交换
          swap_next = {
            ["<leader>s"] = "@parameter.inner",
          },
        }
      },

      -- ███ 自动标签 ███
      autotag = {
        enable = true,
        filetypes = {
          "html", "javascript", "typescript",
          "jsx", "tsx", "vue", "svelte", "xml"
        },
      },

      -- ███ 上下文注释 ███
      context_commentstring = {
        enable = true,
        enable_autocmd = false,
      },

      -- ███ 折叠配置 ███
    fold = {
        enable = true,
        disable = { "markdown" },  -- 排除不适用折叠的文件类型
        foldmethod = "expr",
        foldexpr = "nvim_treesitter#foldexpr()",
        foldlevel = 99,            -- 默认展开所有折叠
        foldtext = [[
          substitute(getline(v:foldstart), '\t', repeat(' ', &tabstop), 'g')
          . '  '  -- 折叠图标
          . (v:foldend - v:foldstart) 
          . ' lines '
          . trim(getline(v:foldend))
        ]],  -- 自定义折叠显示
        max_fold_lines = 1000,    -- 超过1000行的块不自动折叠
      }
    },
    config = function(_, opts)
      -- 解决 ensure_installed 与 auto_install 的冲突
      if opts.ignore_install and #opts.ignore_install > 0 then
        opts.auto_install = false
      end

      require("nvim-treesitter.configs").setup(opts)

      -- ███ 自定义高亮规则 ███
      vim.api.nvim_set_hl(0, "@comment.todo", {
        fg = "#FFA500",  -- 橙色
        bg = "#2D2D2D",
        bold = true,
        italic = true
      })

      -- ███ Python 缩进修复 ███
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "python",
        callback = function()
          vim.opt_local.indentexpr = "nvim_treesitter#indent()"
        end
      })

      -- ███ 自定义增量选择快捷键 ███
      vim.keymap.set({"n", "v"}, "gnn", function()
        require("nvim-treesitter.incremental_selection").init_selection()
      end, { desc = "Init selection" })

      -- ███ 折叠增强配置 ███
      -- 设置全局折叠参数
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
      vim.opt.foldlevel = 99
      vim.opt.foldtext = [[v:lua.custom_fold_text()]]  -- 使用自定义折叠文本

      -- 自定义折叠文本函数
      function _G.custom_fold_text()
        local line = vim.fn.getline(vim.v.foldstart)
        local line_count = vim.v.foldend - vim.v.foldstart + 1
        local text = string.format(
          "▸ %s  [%d lines] ➤ %s",
          vim.fn.substitute(line, "\t", string.rep(" ", vim.opt.tabstop:get()), "g"),
          line_count,
          vim.fn.trim(vim.fn.getline(vim.v.foldend)))
        return text
      end

      -- 文件打开时自动恢复折叠状态
      vim.api.nvim_create_autocmd("BufReadPost", {
        pattern = "*",
        callback = function()
          vim.cmd("normal! zR")  -- 默认展开所有折叠
        end
      })

      -- ███ 折叠快捷键增强 ███
      local map = vim.keymap.set
      map("n", "zR", ":set foldlevel=99<CR>", { desc = "展开所有折叠" })
      map("n", "zM", ":set foldlevel=0<CR>", { desc = "关闭所有折叠" })
      map("n", "<Leader>fc", function()
        vim.cmd("TSBufToggle fold")  -- 快速切换折叠功能
      end, { desc = "切换代码折叠" })
    end
  }
}
