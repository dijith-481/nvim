return {
	{
		"github/copilot.vim",
		cmd = "Copilot",
		event = "BufWinEnter",
		init = function()
			vim.g.copilot_no_maps = true
		end,
		config = function()
			-- Block the normal Copilot suggestions
			vim.api.nvim_create_augroup("github_copilot", { clear = true })
			for _, event in pairs({ "FileType", "BufUnload", "BufEnter" }) do
				vim.api.nvim_create_autocmd({ event }, {
					group = "github_copilot",
					callback = function()
						vim.fn["copilot#On" .. event]()
					end,
				})
			end
		end,
	},
	{
		"milanglacier/minuet-ai.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "Saghen/blink.cmp" },
		config = function()
			require("minuet").setup({
				provider = "gemini",
				provider_options = {
					gemini = {
						optional = {
							generationConfig = {
								maxOutputTokens = 256,
							},
							safetySettings = {
								{
									-- HARM_CATEGORY_HATE_SPEECH,
									-- HARM_CATEGORY_HARASSMENT,
									-- HARM_CATEGORY_SEXUALLY_EXPLICIT,
									category = "HARM_CATEGORY_DANGEROUS_CONTENT",
									threshold = "BLOCK_ONLY_HIGH",
								},
							},
						},
					},
				},
				-- -- Your configuration options here
			})
		end,
	},
}
