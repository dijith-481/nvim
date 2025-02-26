return {
	"echasnovski/mini.nvim",
	version = false,
	config = function()
		require("mini.pairs").setup()
		-- require("mini.align").setup()
		require("mini.ai").setup({ n_lines = 500 })
		-- require("mini.comment").setup()
		require("mini.surround").setup()
		require("mini.operators").setup()
		require("mini.cursorword").setup()
		require("mini.icons").setup()
		require("mini.tabline").setup()
		require("mini.indentscope").setup()
		local statusline = require("mini.statusline")
		statusline.setup({ use_icons = vim.g.have_nerd_font })
		require("mini.bracketed").setup()
		---@diagnostic disable-next-line: duplicate-set-field
		statusline.section_location = function()
			return "%2l:%-2v"
		end
	end,
}
