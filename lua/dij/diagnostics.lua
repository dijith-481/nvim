local config = {
	-- signs = vim.g.have_nerd_font and {
	-- 	text = {
	-- 		[vim.diagnostic.severity.ERROR] = "󰅚 ",
	-- 		[vim.diagnostic.severity.WARN] = "󰀪 ",
	-- 		[vim.diagnostic.severity.INFO] = "󰋽 ",
	-- 		[vim.diagnostic.severity.HINT] = "󰌶 ",
	-- 	},
	-- } or {},
	signs = false,
	update_in_insert = true,
	underline = { severity = vim.diagnostic.severity.ERROR },
	severity_sort = true,
	float = {

		focusable = true,
		style = "minimal",
		border = "rounded",
		source = "always",
		header = "",
		prefix = "#",
		suffix = "",
	},
	virtual_text = {
		source = "always",
		spacing = 2,

		format = function(diagnostic)
			local diagnostic_message = {
				[vim.diagnostic.severity.ERROR] = diagnostic.message,
				[vim.diagnostic.severity.WARN] = diagnostic.message,
				[vim.diagnostic.severity.INFO] = diagnostic.message,
				[vim.diagnostic.severity.HINT] = diagnostic.message,
			}
			return diagnostic_message[diagnostic.severity]
		end,
	},
}
vim.diagnostic.config(config)

local signs = {
	{ name = "DiagnosticLineNrError", severity = vim.diagnostic.severity.ERROR },
	{ name = "DiagnosticLineNrWarn", severity = vim.diagnostic.severity.WARN },
	{ name = "DiagnosticLineNrInfo", severity = vim.diagnostic.severity.INFO },
	{ name = "DiagnosticLineNrHint", severity = vim.diagnostic.severity.HINT },
}
for _, sign in ipairs(signs) do
	vim.fn.sign_define(sign.name, { text = "", numhl = sign.name })
end

vim.api.nvim_create_autocmd("DiagnosticChanged", {
	callback = function()
		vim.fn.sign_unplace("DiagnosticLineNr", { buffer = vim.api.nvim_get_current_buf() })
		local diagnostics = vim.diagnostic.get(0)
		table.sort(diagnostics, function(a, b)
			return a.severity < b.severity
		end)
		for _, diag in ipairs(diagnostics) do
			local lnum = diag.lnum
			local sign_name = diag.severity == vim.diagnostic.severity.ERROR and "DiagnosticLineNrError"
				or diag.severity == vim.diagnostic.severity.WARN and "DiagnosticLineNrWarn"
				or diag.severity == vim.diagnostic.severity.INFO and "DiagnosticLineNrInfo"
				or "DiagnosticLineNrHint"
			print("Placing sign " .. sign_name .. " on line " .. (lnum + 1)) -- Debug
			vim.fn.sign_place(0, "DiagnosticLineNr", sign_name, vim.api.nvim_get_current_buf(), {
				lnum = lnum + 1,
				priority = 200,
			})
		end
	end,
})
