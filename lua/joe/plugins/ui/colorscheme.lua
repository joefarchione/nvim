return {
  {
    "AlexvZyl/nordic.nvim",
    lazy = false,
    priority = 1000,
    enabled = true,
    config = function()
      local nordic = require "nordic"
      nordic.load {
        cursorline = {
          theme = "light",
        },
      }
    end,
  },
}
