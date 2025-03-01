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
	{ "nvim-tree/nvim-web-devicons", opts = {} },
	{
		"numToStr/Comment.nvim",
		event = { "BufReadPre", "BufNewFile" },
		"refractalize/oil-git-status.nvim",
		dependencies = {
			"stevearc/oil.nvim",
		},
		config = function()
			-- import comment plugin safely
			local comment = require("Comment")

			local ts_context_commentstring = require("ts_context_commentstring.integrations.comment_nvim")

			-- enable comment
			comment.setup({
				-- for commenting tsx, jsx, svelte, html files
				pre_hook = ts_context_commentstring.create_pre_hook(),
			})
		end,
	},
	{
		"HiPhish/rainbow-delimiters.nvim",
		config = function() end,
	},

	"nvim-lua/plenary.nvim", -- lua functions that many plugins use

	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
}
