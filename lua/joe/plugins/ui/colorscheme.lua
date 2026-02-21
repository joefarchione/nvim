return {
  {
    "shaunsingh/nord.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- 1. Pre-load settings
      vim.g.nord_contrast = true
      vim.g.nord_borders = true
      vim.g.nord_disable_background = false
      vim.g.nord_italic = false

      -- 2. Define the "Joe-Nord" High Contrast Logic
      local function apply_joe_nord()
        local colors = {
          nord0 = "#2e3440",
          nord1 = "#3b4252",
          nord4 = "#d8dee9", -- Snow Storm (White)
          nord7 = "#8fbcbb", -- Teal (Types)
          nord8 = "#88c0d0", -- Cyan (Functions)
          nord9 = "#81a1c1", -- Blue
          nord11 = "#bf616a", -- Red (Returns)
          nord12 = "#d08770", -- Orange (Parameters)
          nord13 = "#ebcb8b", -- Yellow (Strings)
          nord15 = "#b48ead", -- Purple (Keywords)
          white = "#eceff4",  -- Bright White (Constants)
        }

        local hl = vim.api.nvim_set_hl
        local groups = {
          -- Base
          ["Normal"] = { fg = colors.nord4, bg = colors.nord0 },
          ["NormalFloat"] = { fg = colors.nord4, bg = colors.nord1 },
          ["NonText"] = { fg = colors.nord1 },

          -- Parameters & Arguments (Orange + Italic)
          ["@parameter"] = { fg = colors.nord12, italic = true },
          ["@variable.parameter"] = { fg = colors.nord12, italic = true },
          ["@lsp.type.parameter"] = { fg = colors.nord12, italic = true },
          ["LspSignatureActiveParameter"] = { fg = colors.nord12, underline = true },

          -- Properties & Data Members (White)
          ["@property"] = { fg = colors.nord4 },
          ["@field"] = { fg = colors.nord4 },
          ["@variable.member"] = { fg = colors.nord4 },
          ["@lsp.type.property"] = { fg = colors.nord4 },
          ["@lsp.type.variable.member"] = { fg = colors.nord4 },

          -- Identifiers & Variables (Remap dark blues to white)
          ["@variable"] = { fg = colors.nord4 },
          ["@variable.builtin"] = { fg = colors.nord4 },
          ["@lsp.type.variable"] = { fg = colors.nord4 },
          ["Identifier"] = { fg = colors.nord4 },

          -- Types & Namespaces (Teal)
          ["@type"] = { fg = colors.nord7 },
          ["@type.builtin"] = { fg = colors.nord7 },
          ["@lsp.type.type"] = { fg = colors.nord7 },
          ["@lsp.type.enum"] = { fg = colors.nord7 },
          ["@lsp.type.struct"] = { fg = colors.nord7 },
          ["@namespace"] = { fg = colors.nord7 },

          -- Strings & Returns
          ["@string"] = { fg = colors.nord13 },
          ["@keyword.return"] = { fg = colors.nord11 },

          -- Constants (Bright White)
          ["@constant"] = { fg = colors.white },
          ["@constant.builtin"] = { fg = colors.white },

          -- --- UI & Explorer (Snacks) Visibility Fixes ---
          -- Ignored/Untracked files (make them a visible gray, not matching background)
          ["DiagnosticUnnecessary"] = { fg = "#616e88" }, -- Brighter than Nord3 for visibility
          ["Comment"] = { fg = "#616e88" },
          ["SnacksExplorerFile"] = { fg = colors.nord4 },
          ["SnacksExplorerDirectory"] = { fg = colors.nord8 },
          ["SnacksExplorerIgnored"] = { fg = "#616e88" },
          ["SnacksExplorerUntracked"] = { fg = colors.nord12 }, -- Orange for untracked!
        }

        for group, opts in pairs(groups) do
          opts.force = true
          hl(0, group, opts)
        end
      end

      -- 3. Hook it up to the ColorScheme event
      local group = vim.api.nvim_create_augroup("JoeNordTheme", { clear = true })
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = group,
        pattern = "*",
        callback = function()
          if vim.g.colors_name == "nord" then
            apply_joe_nord()
          end
        end,
      })

      -- 4. Load the theme and apply immediately
      require("nord").set()
      apply_joe_nord()
    end,
  },
}
