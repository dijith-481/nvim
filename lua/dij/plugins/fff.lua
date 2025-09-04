local function build_fff(params)
	vim.notify("Building fff.nvim", vim.log.levels.INFO)
	local obj = vim.system({ "cargo", "build", "--release" }, { cwd = params.path }):wait()
	if obj.code == 0 then
		vim.notify("Building fff.nvim done", vim.log.levels.INFO)
	else
		vim.notify("Building fff.nvim failed", vim.log.levels.ERROR)
	end
end

Now(function()
	Add({
		source = "dmtrKovalenko/fff.nvim",
		hooks = {
			post_install = build_fff,
			post_checkout = build_fff,
		},
	})
	require("fff").setup({})

	vim.keymap.set("n", "ff", function()
		require("fff").find_files()
	end, { desc = "Find files" })
end)
