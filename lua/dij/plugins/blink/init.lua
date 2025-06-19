require("dij.plugins.blink.cmp")
require("dij.plugins.blink.pairs")
require("dij.plugins.blink.indent")
Later(function()
  Add({
    source = "saghen/blink.chartoggle",
  })
  require("blink.chartoggle").setup({

  })
end)
vim.keymap.set('n', '<C-;>', function()
  require('blink.chartoggle').toggle_char_eol(';')
end, { desc = 'Toggle ; at eol' })
vim.keymap.set('n', '<C-,>', function()
  require('blink.chartoggle').toggle_char_eol(';')
end, { desc = 'Toggle ; at eol' })
