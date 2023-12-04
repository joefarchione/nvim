return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      icons = { group = vim.g.icons_enabled and "" or "+", separator = "" },
      triggers = { "<leader>" },
      disable = { filetypes = { "TelescopePrompt" } },
    }
  }
}
