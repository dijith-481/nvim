local ok, mason_registry = pcall(require, "mason-registry")
if not ok then
	vim.notify("mason-registry could not be loaded")
	return
end
local angularls_path = vim.fn.expand("$MASON/packages/angular-language-server/")

local cmd = {
	"ngserver",
	"--stdio",
	"--tsProbeLocations",
	table.concat({
		angularls_path,
		vim.uv.cwd(),
	}, ","),
	"--ngProbeLocations",
	table.concat({
		angularls_path .. "/node_modules/@angular/language-server",
		vim.uv.cwd(),
	}, ","),
}

local config = {
	cmd = cmd,
	filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx", "htmlangular" },
	root_markers = { "angular.json" },
	on_new_config = function(new_config, new_root_dir)
		new_config.cmd = cmd
	end,
}

return config
