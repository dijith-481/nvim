return {
	"kawre/leetcode.nvim",
	-- filename = { "leetcode.nvim" },
	build = ":TSUpdate html", -- if you have `nvim-treesitter` installed
	cmd = { "Leet" },
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
	},
	plugins = {
		non_standalone = true,
	},
	opts = {
		---@type lc.storage
		storage = {
			home = "~/Dev/leetcode/2025/nvim",
			cache = vim.fn.stdpath("cache") .. "/leetcode",
		},
	},
}
