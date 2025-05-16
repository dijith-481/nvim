Add({
	source = "epwalsh/obsidian.nvim",
	depends = {
		"nvim-lua/plenary.nvim",
	},
})

Later(function()
	require("obsidian").setup({
		ui = { enable = false },
		workspaces = {
			{
				name = "personal",
				path = "~/syncthing/notes",
			},
		},
		daily_notes = {
			folder = "daily",
			date_format = "%Y-%m-%d",
		},
	})
	vim.opt.conceallevel = 2
end)

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
	group = vim.api.nvim_create_augroup("obsidian", { clear = true }),

	pattern = { "mdToday" },
	callback = function()
		require("obsidian").setup({
			ui = { enable = false },
			workspaces = {
				{
					name = "personal",
					path = "~/syncthing/notes",
				},
			},
			daily_notes = {
				folder = "daily",
				date_format = "%Y-%m-%d",
			},
		})
		vim.opt.conceallevel = 2
		-- vim.defer_fn(function()
		vim.cmd("ObsidianToday")
		-- end, 100)
	end,
})
