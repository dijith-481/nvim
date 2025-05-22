-- Later(function()
Add({
  source = "nvim-treesitter/nvim-treesitter",
  hooks = {
    post_checkout = function()
      vim.cmd("TSUpdate")
    end,
  },
  checkout = "master",
  monitor = "main",
})
Add({
  source = "windwp/nvim-ts-autotag",
})

local treesitter = require("nvim-treesitter.configs")

treesitter.setup({
  highlight = {
    enable = true,
  },
  indent = { enable = true },
  ensure_installed = {
    "ninja",
    -- "rst",
    "angular",
    "python",
    "json",
    "javascript",
    "typescript",
    "tsx",
    "latex",
    "yaml",
    "html",
    "css",
    -- "prisma",
    "markdown",
    "markdown_inline",
    -- "svelte",
    -- "graphql",
    "bash",
    "lua",
    "vim",
    "dockerfile",
    "gitignore",
    "query",
    "fish",
    "rust",
    "vimdoc",
    "c",
    "cpp",
    "hyprlang",
    "jsonc",
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-space>",
      node_incremental = "<C-space>",
      scope_incremental = false,
      node_decremental = "<bs>",
    },
  },
})
vim.filetype.add({
  extension = { rasi = "rasi" },
  pattern = {
    [".*/waybar/config.*"] = "jsonc",
    -- ['.*/mako/config'] = 'dosini',
    -- [".*/kitty/*.conf"] = "bash",
    [".*/hypr/.*%.conf"] = "hyprlang",
  },
})
require("nvim-ts-autotag").setup({
  opts = {
    enable_close = true,
    enable_rename = true,
    enable_close_on_slash = false,
  },
  per_filetype = {
    ["html"] = {
      -- enable_close = false,
    },
  },
})

Add("nvim-treesitter/nvim-treesitter-context")
require("treesitter-context").setup({
  enable = true,
  multiwindow = false,
  max_lines = 4,
  min_window_height = 8,
  line_numbers = true,
  multiline_threshold = 20,
  trim_scope = "outer",
  mode = "cursor",
  separator = nil,
})
-- end)
