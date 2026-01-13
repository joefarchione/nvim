return {
  "linux-cultist/venv-selector.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "folke/snacks.nvim",
  },
  ft = "python", -- Load when opening Python files
  keys = {
    { "<leader>v", "<cmd>VenvSelect<cr>" }, -- Open picker on keymap
  },
  opts = {
    search = {
      my_venvs = {
        command = "fd python.exe$ C:/TARDIS/desktop/environment/python",
      },
    },
    options = {},
  },
}
