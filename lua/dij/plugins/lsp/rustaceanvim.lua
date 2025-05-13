Add("mrcjkb/rustaceanvim")
Later(function()
	vim.g.rustaceanvim = {
		tools = {},
		server = {
			---@diagnostic disable-next-line: unused-local
			on_attach = function(client, bufnr) end,
			default_settings = {
				["rust-analyzer"] = {
					cargo = { features = "all" },
				},
			},
		},
		dap = {},
	}
end)
