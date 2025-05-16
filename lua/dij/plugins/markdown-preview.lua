Add({
	source = "iamcco/markdown-preview.nvim",
	hooks = {
		post_checkout = function()
			vim.cmd("cd app && npm install")
		end,
	},
})

-- vim.api.nvim_create_autocmd({ "FileType" }, {

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
	group = vim.api.nvim_create_augroup("markdownpreview", { clear = true }),
	pattern = { "*.md" },
	callback = function()
		vim.g.mkdp_filetypes = { "markdown" }
		-- delay  to load the command
		vim.defer_fn(function()
			vim.cmd("MarkdownPreviewToggle")
		end, 100)
	end,
})
