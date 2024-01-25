return {
  'akinsho/bufferline.nvim',
  version = "*",
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    local nord = require("nord")
    local colors = require("nord.colors")
    local highlights = nord.bufferline.highlights({
      fill = colors.nord0_gui,
      indicator = colors.nord9_gui,
      bg = colors.nord0_gui,
      buffer_bg = colors.nord0_gui,
      buffer_bg_selected = colors.nord1_gui,
      buffer_bg_visible = "#2A2F3A",
      bold = true,
      italic = true,
    })

    require("bufferline").setup({
      options = {
        separator_style = "thin",
      },
      highlights = highlights,
    })
  end,
}
