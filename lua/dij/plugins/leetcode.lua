-- Now(function()
Add({
	source = "kawre/leetcode.nvim",
	hooks = {
		post_checkout = function()
			vim.cmd(":TSUpdate html")
		end,
	},
	depends = {
		"nvim-telescope/telescope.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
	},
})
-- filename = { "leetcode.nvim" },

-- plugins = {
-- 	non_standalone = true,
-- },
-- end)
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
	-- vim.api.nvim_create_autocmd({ "FileType" }, {
	group = vim.api.nvim_create_augroup("leetcode", { clear = true }),
	pattern = { "leetcode.nvim" },
	callback = function()
		require("leetcode").setup({
			lang = "rust",

			storage = {
				home = "~/Dev/leetcode/2025/nvim",
				cache = vim.fn.stdpath("cache") .. "/leetcode",
			},
		})
	end,
})
