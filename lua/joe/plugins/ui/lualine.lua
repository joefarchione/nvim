local colors = require "nordic.colors"
-- Custom theme to control tabline background
-- Override the 'c' section (middle/fill area) for all modes
local custom_theme = require "lualine.themes.nordic"
local tabline_bg = { bg = colors.bg }
for _, mode in ipairs { "normal", "insert", "visual", "replace", "command", "inactive" } do
  if custom_theme[mode] then custom_theme[mode].c = tabline_bg end
end

return {
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      local navic = require "nvim-navic"

      local icon_hl = { fg = colors.fg }
      local text_hl = { fg = colors.fg }

      require("lualine").setup {
        options = {
          icons_enabled = true,
          theme = custom_theme,
          section_separators = { left = " ", right = " " },
          component_separators = { left = "", right = "" },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = true,
          draw_empty = true,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          },
          disabled_filetypes = { "snacks_dashboard" },
        },
        tabline = {
          lualine_a = { "mode" },
          lualine_b = {
            {
              "branch",
              color = text_hl,
              icon = { "", color = icon_hl },
              padding = 2,
            },
            {
              "diff",
              color = text_hl,
              symbols = {
                added = " ",
                modified = " ",
                removed = " ",
              },
              diff_color = {
                added = icon_hl,
                modified = icon_hl,
                removed = icon_hl,
              },
              padding = 1,
            },
          },
          lualine_c = {
            {
              function() return navic.get_location() end,
              cond = function() return navic.is_available() end,
              color = { fg = colors.blue0, bg = colors.bg },
            },
          },
          lualine_x = { "lsp_status", "fileformat", "filetype" },
          lualine_y = { "progress", "location" },
          lualine_z = { { function() return os.date "%m/%d/%Y %H:%M" end, icon = "" } },
        },
        inactive_sections = {},
        sections = {},
        winbar = {
          lualine_a = { { "filename", path = 1, color = { bg = colors.bg, fg = colors.magenta.base } } },
        },
        inactive_winbar = {
          lualine_a = { { "filename", path = 1, color = { bg = colors.bg, fg = colors.gray3 } } },
        },
        extensions = {},
      }
    end,
  },
}
