return {
  {
    "shaunsingh/nord.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- 1. Pre-load settings
      vim.g.nord_contrast = false
      vim.g.nord_borders = false
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
          -- Base (flat: everything on nord0)
          ["Normal"] = { fg = colors.nord4, bg = colors.nord0 },
          ["NormalFloat"] = { fg = colors.nord4, bg = colors.nord0 },
          ["NonText"] = { fg = "#4c566a" },
          ["FloatBorder"] = { fg = "#4c566a", bg = colors.nord0 },
          ["WinSeparator"] = { fg = colors.nord1, bg = colors.nord0 },

          -- Parameters & Arguments (Orange, no italic)
          ["@parameter"] = { fg = colors.nord12 },
          ["@variable.parameter"] = { fg = colors.nord12 },
          ["@lsp.type.parameter"] = { fg = colors.nord12 },
          ["LspSignatureActiveParameter"] = { fg = colors.nord12, underline = true },

          -- Properties & Data Members
          ["@property"] = { fg = colors.nord4 },
          ["@field"] = { fg = colors.nord4 },
          ["@variable.member"] = { fg = colors.nord4 },
          ["@lsp.type.property"] = { fg = colors.nord4 },
          ["@lsp.type.variable.member"] = { fg = colors.nord4 },

          -- Identifiers & Variables
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

          -- Constants (same as variables for reduced color noise)
          ["@constant"] = { fg = colors.nord4 },
          ["@constant.builtin"] = { fg = colors.nord4 },

          -- --- UI & Explorer (Snacks) Visibility Fixes ---
          ["DiagnosticUnnecessary"] = { fg = "#8892a8" },
          ["Comment"] = { fg = "#8892a8" },
          ["SnacksExplorerFile"] = { fg = colors.nord4 },
          ["SnacksExplorerDirectory"] = { fg = colors.nord8 },
          -- CodeLens (no italic)
          ["LspCodeLens"] = { fg = colors.nord9 },
          ["LspCodeLensSeparator"] = { fg = colors.nord9 },

          ["SnacksPickerPathIgnored"] = { fg = colors.nord4 },
          ["SnacksPickerPathHidden"] = { fg = colors.nord4 },
          ["SnacksExplorerUntracked"] = { fg = colors.nord12 },
          ["SnacksPickerGitStatusUntracked"] = { fg = colors.nord12 },
          ["SnacksPickerGitStatusIgnored"] = { fg = "#8892a8" },

          -- Winbar (flat, no dead space)
          ["WinBar"] = { fg = colors.nord4, bg = colors.nord0 },
          ["WinBarNC"] = { fg = "#4c566a", bg = colors.nord0 },
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
