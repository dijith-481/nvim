return {
	{
		"epwalsh/obsidian.nvim",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("obsidian").setup({
				ui = { enable = false },
				workspaces = {
					{
						name = "personal",
						path = "~/syncthing/obsidian/",
					},
				},
			})
			vim.opt.conceallevel = 2
		end,
	},
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && npm install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown" },
		dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" },
		---@module 'render-markdown'
		---@type render.md.UserConfig
	},
}
