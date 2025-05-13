Add("folke/snacks.nvim")
Now(function()
	require("snacks").setup({

		animate = {},
		bigfile = {},
		dashboard = require("dij.plugins.snacks.dashboard"),
		indent = require("dij.plugins.snacks.indent"),
		dim = {},
		gitbrowse = {},
		input = {},
		picker = {},
		zen = {},
		scratch = {},
		lazygit = {},
		-- notifier = {},
		quickfile = {},
		scope = {},
		--BUG janky scroll in jk
		scroll = {},
		-- statuscolumn = { enabled = true },
		words = {},
	})
	require("dij.plugins.snacks.keybinds")
end)

require("dij.plugins.snacks.persistence")
require("dij.plugins.snacks.rename")
