Later(function()
	Add("supermaven-inc/supermaven-nvim")
	require("supermaven-nvim").setup({
		keymaps = {
			accept_suggestion = "<C-Tab>",
			clear_suggestion = "<C-]>",
			accept_word = "<Tab>",
		},
		color = {
			suggestion_color = "#A0face",
		},
	})
end)
