return {
	fileypes = { "python" },

	on_attach = function(client, bufnr)
		client.server_capabilities.disableHoverProvider = false

		vim.api.nvim_create_user_command("RuffAutoFix", function()
			vim.lsp.buf.execute_command({
				command = "ruff.applyAutofix",
				arguments = {
					{ uri = vim.uri_from_bufnr(0) },
				},
			})
		end, { desc = "Ruff: Fix all auto-fixable problems" })

		vim.api.nvim_create_user_command("RuffOrganizeImports", function()
			vim.lsp.buf.execute_command({
				command = "ruff.applyOrganizeImports",
				arguments = {
					{ uri = vim.uri_from_bufnr(0) },
				},
			})
		end, { desc = "Ruff: Format imports" })
	end,
}
