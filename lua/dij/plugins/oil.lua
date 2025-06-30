Now(function()
	Add("stevearc/oil.nvim")
	Add({
		source = "stevearc/oil-git-status.nvim",
		deps = {
			"stevearc/oil.nvim",
		},
	})
	Add({
		source = "SirZenith/oil-vcs-status",
	})
	Add("JezerM/oil-lsp-diagnostics.nvim")

	require("oil").setup({
		view_options = {
			show_hidden = true,

			---@diagnostic disable-next-line: unused-local
			is_always_hidden = function(name, bufnr)
				local m = name:match("^%..$")
				return m ~= nil
			end,
		},
		win_options = {
			signcolumn = "yes",
		},
		watch_for_changes = true,
		keymaps = {
			["<CR>"] = "actions.select",
			["<leader>v"] = { "actions.select", opts = { vertical = true } },
			["<leader>h"] = { "actions.select", opts = { horizontal = true } },
			["<C-q>"] = { "actions.select", opts = { tab = true } },
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
	-- require("oil-vcs-status").setup()
	-- require("oil-lsp-diagnostics").setup()
end)
