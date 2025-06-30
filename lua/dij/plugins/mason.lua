-- local setup_lsp = function()
--   local lsp_configs = {}
--   -- hack to avoid files under nvimlspconfg
--   for _, f in pairs(vim.api.nvim_get_runtime_file("../nvim/lsp/*.lua", true)) do
--     local server_name = vim.fn.fnamemodify(f, ":t:r")
--     table.insert(lsp_configs, server_name)
--   end
--   vim.lsp.enable(lsp_configs)
--   vim.lsp.enable("marksman")
-- end

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
	"deno",
}

Now(function()
	Add("mason-org/mason.nvim")
	Add("WhoIsSethDaniel/mason-tool-installer.nvim")
	require("mason").setup({})

	require("mason-tool-installer").setup({
		ensure_installed = ensure_installed,
	})
end)
-- setup_lsp()

--   vim.lsp.commands["editor.action.showReferences"] = function(command, ctx)
--     local locations = command.arguments[3]
--     local client = vim.lsp.get_client_by_id(ctx.client_id)
--     if locations and #locations > 0 then
--       local items = vim.lsp.util.locations_to_items(locations, client.offset_encoding)
--       vim.fn.setloclist(0, {}, " ", { title = "References", items = items, context = ctx })
--       vim.api.nvim_command("lopen")
--     end
--   end
--
--   vim.diagnostic.config({
--     on_init_callback = function(_)
--       setup_codelens_refresh(_)
--     end,
--   })
-- end)
-- function setup_codelens_refresh(client, bufnr)
--   local status_ok, codelens_supported = pcall(function()
--     return client.supports_method("textDocument/codeLens")
--   end)
--   if not status_ok or not codelens_supported then
--     return
--   end
--   local group = "lsp_code_lens_refresh"
--   local cl_events = { "BufEnter", "InsertLeave" }
--   local ok, cl_autocmds = pcall(vim.api.nvim_get_autocmds, {
--     group = group,
--     buffer = bufnr,
--     event = cl_events,
--   })
--   if ok and #cl_autocmds > 0 then
--     return
--   end
--   vim.api.nvim_create_augroup(group, { clear = false })
--   vim.api.nvim_create_autocmd(cl_events, {
--     group = group,
--     buffer = bufnr,
--     callback = vim.lsp.codelens.refresh,
--   })
