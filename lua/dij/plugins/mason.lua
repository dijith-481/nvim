local setup_lsp = function()
	local lsp_configs = {}
	-- hack to avoid files under nvimlspconfg
	for _, f in pairs(vim.api.nvim_get_runtime_file("../nvim/lsp/*.lua", true)) do
		local server_name = vim.fn.fnamemodify(f, ":t:r")
		table.insert(lsp_configs, server_name)
	end
	vim.lsp.enable(lsp_configs)
end

local ensure_installed = {
	"angular-language-server",
	"bash-language-server",
	"css-lsp",
	"clangd",
	"efm",
	"hyprls",
	"lua-language-server",
	-- "stylua",
	"ruff",
	-- "html-lsp",
	"basedpyright",
	-- "prettier",
	"stylelint",
	"stylelint-lsp",
	"emmet-language-server",
	"typescript-language-server",
	"marksman",
	"tailwindcss-language-server",
	"shellcheck",
}

Now(function()
	Add("mason-org/mason.nvim")
	-- require("mason").setup({})
	require("mason-core.path")
	--
	-- Add("neovim/nvim-lspconfig")
	-- Add("mason-org/mason-lspconfig.nvim")
	-- require("mason-lspconfig").setup({
	-- 	-- automatic_enable = false,
	-- })
	-- setup_lsp()
end)

Later(function()
	Add("neovim/nvim-lspconfig")
	Add("mason-org/mason-lspconfig.nvim")
	Add("WhoIsSethDaniel/mason-tool-installer.nvim")

	require("mason").setup({})
	require("mason-tool-installer").setup({
		ensure_installed = ensure_installed,
	})
	require("mason-lspconfig").setup({
		ensure_installed = {},
		automatic_enable = false,
	})
	setup_lsp()
end)
