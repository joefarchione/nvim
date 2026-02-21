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

      -- --- Custom "Joe-Nord" High Contrast Overrides ---
      local function apply_overrides()
        local colors = {
          nord7 = "#8fbcbb", -- Teal (Types)
          nord8 = "#88c0d0", -- Cyan (Functions)
          nord12 = "#d08770", -- Orange (Parameters/Arguments)
          nord13 = "#ebcb8b", -- Yellow (Constants)
          nord15 = "#b48ead", -- Purple (Keywords)
        }

        local hl = vim.api.nvim_set_hl

        -- Parameters/Arguments (Orange + Italic)
        hl(0, "@parameter", { fg = colors.nord12, italic = true, force = true })
        hl(0, "@variable.parameter", { fg = colors.nord12, italic = true, force = true })

        -- Types (Teal + Bold)
        hl(0, "@type", { fg = colors.nord7, bold = true, force = true })
        hl(0, "@type.builtin", { fg = colors.nord7, bold = true, force = true })
        hl(0, "@type.definition", { fg = colors.nord7, bold = true, force = true })
        hl(0, "@namespace", { fg = colors.nord7, force = true })

        -- Functions & Constructors
        hl(0, "@function", { fg = colors.nord8, force = true })
        hl(0, "@constructor", { fg = colors.nord8, force = true })

        -- Constants & Booleans
        hl(0, "@constant", { fg = colors.nord13, bold = true, force = true })
        hl(0, "@boolean", { fg = colors.nord13, bold = true, force = true })

        -- Keywords (Purple)
        hl(0, "@keyword", { fg = colors.nord15, force = true })
        hl(0, "@keyword.function", { fg = colors.nord15, force = true })
      end

      -- Apply whenever the colorscheme changes
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "nord",
        callback = apply_overrides,
      })

      -- Load the base theme
      require("nord").set()
    end,
  },
}
