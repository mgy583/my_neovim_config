-- 在 alpha.lua 配置文件中修改以下部分
return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- -- 头部配置（确保是字符串数组）
    -- dashboard.section.header.val = {
    --   [[                         .........                          ]],
    --   [[                 ...................                        ]],
    --   [[                ......................                      ]],
    --   [[                ....  ..    ..........                      ]],
    --   [[               ...        ..........                        ]],
    --   [[              ...  ..:-=+*########**++=-:..                 ]],
    --   [[              .:-+*###*+==-:::::---==++***#*+=:..           ]],
    --   [[           :=*###+=-::.::::::::::::::::...:-+*++:           ]],
    --   [[         .+%#+-..::::::::...................:::-**.         ]],
    --   [[         .#%--=-::.................:::..::::--::%@=         ]],
    --   [[         .#%--++++=--::::..::--:::-===......:::.#%+         ]],
    --   [[          +%=:+++++++++++--++=-:::-===..:-:.....*#+         ]],
    --   [[          =#+:+++++++++++=:=-:... :===.+%#%#=.. +#+         ]],
    --   [[          -#*.=+++++++++++.::.-**-:===.::.:*%+..*#=         ]],
    --   [[          :##:-+++++++++++.::+%*-:.===::....:...*#:         ]],
    --   [[          .#%=.+++++++++++::+%#. :=:-=::...... :**.         ]],
    --   [[          -%%--+++++++++++::*#-.....:=.......  -+-          ]],
    --   [[         .#@+.-===+++====+:::........--::::::=**+.          ]],
    --   [[          :+***+=---:-----::::::......:-----=*#*-.          ]],
    --   [[            ..-=+*=======-+**+====-:-==:.:::=+-.            ]],
    --   [[                  ..::--=-=*+-----:.::::::.....             ]],
    --   [[                       .::..:::::..::::::.                  ]],
    --   [[                       .::::::::::::.  .                    ]],
    --   [[                          ......::.                         ]],
    -- }    
        -- 按钮配置
      dashboard.section.buttons.val = {
      dashboard.button("e", "󰈔  New File", "<cmd>ene<CR>"),
      dashboard.button("f", "󰈞  Find File", "<cmd>Telescope find_files<CR>"),
      dashboard.button("r", "󰄉  Recent Files", "<cmd>Telescope oldfiles<CR>"),
      dashboard.button("g", "󰈬  Find Word", "<cmd>Telescope live_grep<CR>"),
      dashboard.button("c", "  Config", "<cmd>e ~/.config/nvim/init.lua<CR>"),
      dashboard.button("l", "󰒲  Lazy", "<cmd>Lazy<CR>"),
      dashboard.button("q", "  Quit", "<cmd>qa<CR>"),
    }
    local function build_footer()
        local stats = require("lazy").stats()
        local version = vim.version()
        local hour = tonumber(os.date("%H"))
    local time_greeting = (
      (hour >= 5 and hour < 8) and "🌅 清晨好" or
      (hour >= 8 and hour < 12) and "☀️ 上午好" or
      (hour >= 12 and hour < 14) and "🌤️ 中午好" or
      (hour >= 14 and hour < 18) and "🌞 下午好" or
      (hour >= 18 and hour < 20) and "🌇 傍晚好" or
      (hour >= 20 and hour <= 23) and "🌃 晚上好" or
      "🌌 夜深了" -- 0:00 - 4:59
    )      return {
        time_greeting,
        "──────────────────────────────────────────",
        string.format(
          "󰂖 %d plugins  󰥔 v%d.%d.%d",
          stats.count,
          version.major,
          version.minor,
          version.patch
        )
      }
    end

    -- 正确配置 footer 部分
    dashboard.section.footer = {
      type = "text",
      val = build_footer(),
      opts = {
        hl = "Comment",
        position = "center"
      }
    }

    -- 调整布局配置
    dashboard.config.layout = {
      { type = "padding", val = 3 },
      dashboard.section.header,
      { type = "padding", val = 2 },
      dashboard.section.buttons,
      { type = "padding", val = 1 },
      dashboard.section.footer  -- 确保这里引用的是对象而非直接列表
    }

    alpha.setup(dashboard.config)
  end
}
