return {
	cmd = { "typescript-language-server", "--stdio" },
	-- capabilities = { capabilities },

	filetypes = { "typescript" },
	settings = {
		format = { enable = true },
		-- disable unused vars hint
		-- diagnostics = { ignoredCodes = { 6133, 2304 } },
	},
}
