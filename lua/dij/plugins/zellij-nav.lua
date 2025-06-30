Later(function()
  Add("swaits/zellij-nav.nvim")
  require("zellij-nav").setup()
  -- vim.keymap.set("n", "<c-h>", "<cmd>ZellijNavigateLeftTab<cr>", { silent = true })
  -- vim.keymap.set("n", "<c-j>", "<cmd>ZellijNavigateDown<cr>", { silent = true })
  -- vim.keymap.set("n", "<c-k>", "<cmd>ZellijNavigateUp<cr>", { silent = true })
  -- vim.keymap.set("n", "<c-l>", "<cmd>ZellijNavigateRightTab<cr>", { silent = true })
  vim.api.nvim_create_autocmd("VimLeave", {
    pattern = "*",
    command = "silent !zellij action switch-mode normal"
  })
end)
