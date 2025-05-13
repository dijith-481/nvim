return {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".luarc.json", ".luarc.jsonc", ".stylua.toml", "stylua.toml", ".luacheckrc", ".git" },
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
				path = {
					"lua/?.lua",
					"lua/?/init.lua",
				},
			},
			completion = {
				callSnippet = "Replace",
			},
			diagnostics = {},
			workspace = {
				ignoreDir = { ".git" },
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
					"${3rd}/luv/library",
					vim.api.nvim_get_runtime_file("lua", true),
				},
			},
		},
	},
}
