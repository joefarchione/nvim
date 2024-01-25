return {
  {
    'nvim-lualine/lualine.nvim',
    config = function()
      local navic = require 'nvim-navic'
      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = "nord",
          component_separators = { left = '|', right = '|' },
          section_separators = { left = '', right = '' },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = true,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          }
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = { 'filename' },
          lualine_x = { 'encoding', 'fileformat', 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' }
        },
        inactive_sections = {},
        tabline = {},
        -- tabline = {
        -- lualine_a = { "filename" },
        -- lualine_b = {},
        -- lualine_c = {},
        -- lualine_x = {},
        -- lualine_y = {},
        -- lualine_z = { "tabs" }
        -- },
        winbar = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {
            {
              function()
                return navic.get_location()
              end,
              cond = function()
                return navic.is_available()
              end
            },
          },
          lualine_x = {},
          lualine_y = {},
          lualine_z = {}
        },
        inactive_winbar = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {
            {
              function()
                return navic.get_location()
              end,
              cond = function()
                return navic.is_available()
              end
            },
          },
          lualine_x = {},
          lualine_y = {},
          lualine_z = {}
        },
        extensions = {}
      }
    end
  },
}
