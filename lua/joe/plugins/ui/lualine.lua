-- Nord color palette
local colors = {
  nord0 = "#2e3440",
  nord1 = "#3b4252",
  nord2 = "#434c5e",
  nord3 = "#4c566a",
  nord4 = "#d8dee9",
  nord5 = "#e5e9f0",
  nord6 = "#eceff4",
  nord7 = "#8fbcbb",
  nord8 = "#88c0d0",
  nord9 = "#81a1c1",
  nord10 = "#5e81ac",
  nord11 = "#bf616a",
  nord12 = "#d08770",
  nord13 = "#ebcb8b",
  nord14 = "#a3be8c",
  nord15 = "#b48ead",
}

-- Use standard Nord lualine theme
local custom_theme = require "lualine.themes.nord"
-- Ensure the middle section background matches nord0
for _, mode in ipairs { "normal", "insert", "visual", "replace", "command", "inactive" } do
  if custom_theme[mode] then custom_theme[mode].c = { bg = colors.nord0, fg = colors.nord4 } end
end

return {
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      local navic = require "nvim-navic"

      local icon_hl = { fg = colors.nord8 }
      local text_hl = { fg = colors.nord4 }

      require("lualine").setup {
        options = {
          icons_enabled = true,
          theme = custom_theme,
          section_separators = { left = " ", right = " " },
          component_separators = { left = "", right = "" },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = true,
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
              color = { fg = colors.nord9, bg = colors.nord0 },
            },
          },
          lualine_x = { "lsp_status", "fileformat", "filetype" },
          lualine_y = { "progress", "location" },
          lualine_z = { { function() return os.date "%m/%d/%Y %H:%M" end, icon = "" } },
        },
        inactive_sections = {},
        sections = {},
        winbar = {
          lualine_a = { { "filename", path = 1, color = { bg = colors.nord0, fg = colors.nord15 } } },
        },
        inactive_winbar = {
          lualine_a = { { "filename", path = 1, color = { bg = colors.nord0, fg = colors.nord3 } } },
        },
        extensions = {},
      }
    end,
  },
}
