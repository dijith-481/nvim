Now(function()
	Add({
		source = "AlexvZyl/nordic.nvim",
	})
	local nordic = require("nordic")
	nordic.setup({

		vim.api.nvim_set_hl(0, "YankHighlight", {}),
		on_highlight = function(highlights, palette)
			local U = require("nordic.utils")
			highlights.CursorLine = {
				bg = U.blend(palette.blue0, palette.bg, 0.10),
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
