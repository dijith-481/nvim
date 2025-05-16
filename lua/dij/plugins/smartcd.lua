Later(function()
	Add("https://gitlab.com/Biggybi/nvim-smartcd.git")
	-- keys = { { "<leader>cd", description = "Smart CD" } },
	require("smartcd").setup({
		notify = true, -- notify when changing dir
		auto_cd = true, -- auto change dir (BufRead, BufEnter)
		auto_cd_terminal = true, -- auto change dir when `cd` in terminal buffer
		create_commands = true, -- create `SmartCd` user-command
		create_keymaps = false, -- do not create `<leader>cd` keymap
		-- take precedence over `ft_markers`
		markers = {
			".git",
			".gitignore",
			".editorconfig",
			"_darcs",
			"node_modules",
			".hg",
			".svn",
			".bzr",
			".fslckout",
			".venv",
		},
		ft_markers = {
			javascript = {
				"package.json",
				"yarn.lock",
				".eslintrc.json",
				".prettierrc",
				".prettierrc.json",
				".prettierrc.yaml",
				".prettierrc.toml",
				"node_modules",
			},
			typescript = {
				"package.json",
				"yarn.lock",
				".eslintrc.json",
				".prettierrc",
				".prettierrc.json",
				".prettierrc.yaml",
				".prettierrc.toml",
				"node_modules",
			},
			lua = { ".luacheckrc", ".luastyle", ".stylua.toml", "stylua.toml" },
			rust = { "Cargo.toml", "Cargo.lock" },
			python = { "Pipfile" },
			c = { "Makefile" },
			cpp = { "Makefile" },
			zig = { "build.zig" },
		},
	})
	vim.keymap.set("n", "<leader>cd", require("smartcd.smartcd").smartcd, { desc = "SmartCd" })
end)
