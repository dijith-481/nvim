Now(function()
	Add("stevearc/oil.nvim")
	Add("refractalize/oil-git-status.nvim")

	require("oil").setup({
		view_options = {
			show_hidden = true,
		},
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
	require("oil-git-status").setup()
end)
