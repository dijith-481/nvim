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
    vim.api.nvim_set_hl(0, "Bars_glow__1", {}),
    vim.api.nvim_set_hl(0, "Bars_glow_0", {}),
    vim.api.nvim_set_hl(0, "Bars_glow_1", {}),
    vim.api.nvim_set_hl(0, "Bars_glow_2", {}),
    vim.api.nvim_set_hl(0, "Bars_glow_3", {}),
    vim.api.nvim_set_hl(0, "Bars_glow_4", {}),
    vim.api.nvim_set_hl(0, "Bars_glow_5", {}),
    vim.api.nvim_set_hl(0, "Bars_glow_6", {}),
    vim.api.nvim_set_hl(0, "Bars_glow_7", {}),
    -- vim.api.nvim_set_hl(0, "FoldOpen", {}),
    -- vim.api.nvim_set_hl(0, "FoldClose", {}),
    on_highlight = function(highlights, palette)
      local U = require("nordic.utils")
      highlights.CursorLine = {
        bg = U.blend(palette.blue0, palette.bg, 0.10),
      }

      highlights.Bars_glow__1 = {
        bg = palette.bg,
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
      highlights.LspReferenceText = {
        bg = U.blend(palette.blue0, palette.bg, 0.10),
      }
      highlights.LspReferenceRead = {
        bg = U.blend(palette.cyan.base, palette.bg, 0.20),
      }
      highlights.LspReferenceWrite = {
        bg = U.blend(palette.green.base, palette.bg, 0.10),
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


      -- highlights.FoldOpen = {
      --   fg = palette.green.base,
      -- }
      -- highlights.FoldClose = {
      --   fg = palette.blue1,
      -- }

      highlights.Folded = {
        bg = U.blend(palette.blue0, palette.bg, 0.06),
      }
      highlights.MiniDiffSignChange = {
        fg = palette.magenta.base,
        bold = true,
      }
      highlights.MiniDiffSignAdd = {
        fg = palette.green.base,
        bold = true,
      }
      highlights.MiniDiffSignDelete = {
        fg = palette.red.base,
        bold = true,
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

      -- highlights.FoldColumn = {
      --   bg = palette.red.base,
      -- }
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
      highlights.Bars_glow_4 = {
        bg = palette.bg,
        fg = palette.red.base,
      }
      highlights.Bars_glow_3 = {
        bg = palette.bg,
        fg = palette.orange.base,
      }
      highlights.Bars_glow_2 = {
        bg = palette.bg,
        fg = palette.yellow.base,
      }
      highlights.Bars_glow_1 = {
        bg = palette.bg,
        fg = palette.green.base,
      }
      highlights.Bars_glow_0 = {
        bg = palette.bg,
        fg = palette.blue1,
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
