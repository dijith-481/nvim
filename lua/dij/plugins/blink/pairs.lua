Later(function()
  Add({
    checkout = "v0.3.0",
    source = "saghen/blink.pairs",
    depends = { 'saghen/blink.download',
    }
  })

  require("blink.pairs").setup({
    mappings = {
      enabled = true, pairs = {},
    },
    highlights = {
      enabled = true,
      groups = {
        'Bars_glow_0',
        'Bars_glow_1',
        'Bars_glow_2',
        'Bars_glow_3',
        'Bars_glow_4',
      },
      matchparen = {
        enabled = true,
        group = 'MatchParen',
      },
    },
  })
end)
