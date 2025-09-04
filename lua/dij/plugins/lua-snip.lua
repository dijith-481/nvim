local function build_luasnip(params)
	local obj = vim.system({ "make", "install_jsregexp" }, { cwd = params.path }):wait()
	if obj.code == 0 then
		vim.notify("Building lua-snip done", vim.log.levels.INFO)
	else
		vim.notify("Building lua-snip failed", vim.log.levels.ERROR)
	end
end

Now(function()
	Add({
		source = "L3MON4D3/LuaSnip",
		checkout = "master",
		depends = { "rafamadriz/friendly-snippets" },
		hooks = {
			post_install = build_luasnip,
		},
	})
	require("luasnip").filetype_extend("typescript", { "tsdoc" })
	require("luasnip").filetype_extend("markdown", { "tex" })
	require("luasnip").filetype_extend("rust", { "rustdoc" })
	require("luasnip.loaders.from_vscode").lazy_load()
end)
