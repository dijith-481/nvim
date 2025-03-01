return {
	{
		"stevearc/oil.nvim",
		event = "VimEnter",
		dependencies = { "echasnovski/mini.nvim" },
		config = function()
			require("oil").setup({
				win_options = {
					signcolumn = "yes:2",
				},
			})
			vim.keymap.set("n", "-", require("oil").toggle_float, {})
			vim.api.nvim_create_autocmd("User", {
				pattern = "OilActionsPost",
				callback = function(event)
					if event.data.actions.type == "move" then
						Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
					end
				end,
			})
		end,
	},
	{
		"refractalize/oil-git-status.nvim",
		dependencies = {
			"stevearc/oil.nvim",
		},
		config = true,
		event = { "VeryLazy" },
	},
	{
		"HiPhish/rainbow-delimiters.nvim",
		event = { "BufReadPre", "BufNewFile" },
		lazy = true,
		config = function() end,
	},
}
