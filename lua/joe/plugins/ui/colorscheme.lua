return {
  {
    "shaunsingh/nord.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.nord_contrast = true
      vim.g.nord_borders = true
      vim.g.nord_disable_background = false
      vim.g.nord_italic = false

      -- Load the base theme
      require("nord").set()

      -- --- Custom "Joe-Nord" High Contrast Overrides ---
      local colors = {
        nord7 = "#8fbcbb", -- Teal (Types)
        nord8 = "#88c0d0", -- Cyan (Functions)
        nord9 = "#81a1c1", -- Blue (Variables)
        nord12 = "#d08770", -- Orange (Parameters/Arguments)
        nord13 = "#ebcb8b", -- Yellow (Constants)
        nord15 = "#b48ead", -- Purple (Keywords)
      }

      local hl = vim.api.nvim_set_hl

      -- Parameters/Arguments (Orange + Italic)
      hl(0, "@parameter", { fg = colors.nord12, italic = true })
      hl(0, "@variable.parameter", { fg = colors.nord12, italic = true })

      -- Types (Teal + Bold)
      hl(0, "@type", { fg = colors.nord7, bold = true })
      hl(0, "@type.builtin", { fg = colors.nord7, bold = true })
      hl(0, "@type.definition", { fg = colors.nord7, bold = true })
      hl(0, "@namespace", { fg = colors.nord7 })

      -- Functions & Constructors
      hl(0, "@function", { fg = colors.nord8 })
      hl(0, "@constructor", { fg = colors.nord8 })

      -- Constants & Booleans
      hl(0, "@constant", { fg = colors.nord13, bold = true })
      hl(0, "@boolean", { fg = colors.nord13, bold = true })

      -- Keywords (Purple)
      hl(0, "@keyword", { fg = colors.nord15 })
      hl(0, "@keyword.function", { fg = colors.nord15 })
    end,
  },
}
