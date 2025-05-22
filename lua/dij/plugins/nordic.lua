Now(function()
	Add({
		source = "AlexvZyl/nordic.nvim",
	})
	local nordic = require("nordic")
	nordic.setup({

		vim.api.nvim_set_hl(0, "YankHighlight", {}),
		vim.api.nvim_set_hl(0, "DiagnosticLineNrError", {}),
		vim.api.nvim_set_hl(0, "DiagnosticLineNrWarn", {}),
		vim.api.nvim_set_hl(0, "DiagnosticLineNrInfo", {}),
		vim.api.nvim_set_hl(0, "DiagnosticLineNrHint", {}),
		vim.api.nvim_set_hl(0, "FoldOpen", {}),
		vim.api.nvim_set_hl(0, "FoldClose", {}),
		on_highlight = function(highlights, palette)
			local U = require("nordic.utils")
			highlights.CursorLine = {
				-- bg = U.blend(palette.blue0, palette.bg, 0.10),
			}
			highlights.CursorColumn = {
				bg = U.blend(palette.blue0, palette.bg, 0.04),
			}
			highlights.MiniStatusLineModeNormal = {
				bg = palette.blue1,
				fg = palette.black0,
			}
			highlights.CursorLineNr = {
				bg = U.blend(palette.blue0, palette.bg, 0.10),
				fg = palette.blue1,
				bold = true,
			}
			highlights.DiagnosticLineNrError = {
				bg = palette.red.base,
				fg = palette.black0,
			}

			highlights.DiagnosticLineNrWarn = {
				bg = palette.yellow.base,
				fg = palette.black0,
			}

			highlights.DiagnosticLineNrInfo = {
				bg = palette.cyan.base,
				fg = palette.black0,
			}

			highlights.DiagnosticLineNrHint = {
				bg = palette.green.base,
				fg = palette.black0,
			}

			highlights.FoldOpen = {
				fg = palette.green.base,
			}
			highlights.FoldClose = {
				fg = palette.blue1,
			}

			highlights.Folded = {
				bg = U.blend(palette.blue0, palette.bg, 0.06),
			}
			highlights.MiniDiffSignChange = {
				fg = palette.cyan.base,
			}
			highlights.MiniDiffSignAdd = {
				fg = palette.green.base,
			}

			highlights.MiniStatuslineTreesitter = {
				fg = palette.fg,
			}
			highlights.MiniStatuslineFilename = {
				bg = palette.gray1,
				fg = palette.fg,
			}
			highlights.MiniStatuslineDevinfo = {
				bg = palette.gray2,
				fg = palette.fg,
			}

			highlights.FoldColumn = {
				bg = palette.blue0,
			}
			highlights.GitSignsCurrentLineBlame = {
				fg = U.blend(palette.white0, palette.bg, 0.27),
			}
			highlights.YankHighlight = {
				bg = palette.bg_selected,
				-- italic = true,
				-- underline = true,
				-- sp = palette.yellow.dim,
				-- undercurl = false,
			}
		end,
		after_palette = function(palette)
			local U = require("nordic.utils")
			palette.bg_visual = U.blend(palette.blue0, palette.bg, 0.18)
			palette.bg_selected = U.blend(palette.blue0, palette.bg, 0.50)
		end,
	})
	nordic.load()
end)
