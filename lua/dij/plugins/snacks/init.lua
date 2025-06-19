Add("folke/snacks.nvim")
Now(function()
  require("snacks").setup({

    animate = {},
    bigfile = {},
    dashboard = require("dij.plugins.snacks.dashboard"),
    -- indent = require("dij.plugins.snacks.indent"),
    dim = {},
    gitbrowse = {},
    input = {},
    picker = {
      win = {
        input = {
          keys = {
            ["<c-q>"] = { "qflist", mode = { "i", "n" } },
          },
        },
        list = {
          keys = {
            ["<c-q>"] = "qflist",
          }
        }

      }
    },
    zen = {},
    scratch = {},
    lazygit = {},
    notifier = {},
    quickfile = {},
    scope = {},
    --BUG janky scroll in jk
    -- scroll = {},
    -- statuscolumn = {},
    words = {},
  })
  require("dij.plugins.snacks.keybinds")
end)

require("dij.plugins.snacks.persistence")
require("dij.plugins.snacks.rename")
