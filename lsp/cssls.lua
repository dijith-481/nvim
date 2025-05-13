return {
	cmd = { "vscode-css-language-server", "--stdio" },
	filetypes = { "css", "scss", "less" },
	init_options = { provideFormatter = false }, -- needed to enable formatting capabilities
	-- root_dir = util.root_pattern("package.json", ".git"),
	single_file_support = true,
	settings = {
		css = { validate = true, lint = {
			unknownAtRules = "ignore",
		} },
		scss = { validate = true },
		less = { validate = true },
	},
}
