Later(function()
	Add({
		source = "MeanderingProgrammer/render-markdown.nvim",
		depends = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" },
	})

	vim.api.nvim_create_autocmd({ "FileType" }, {
		group = vim.api.nvim_create_augroup("markdown", { clear = true }),
		pattern = { "*.md" },
		callback = function()
			require("render-markdown").setup({
				completions = { blink = { enabled = true } },
			})
		end,
	})
end)
