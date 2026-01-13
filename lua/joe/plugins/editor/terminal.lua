return {
  "folke/snacks.nvim",
  opts = {
    terminal = {
      enable = true,
    },
  },
  keys = {
    { "<Esc><Esc>", "<cmd><C-\\><C-n><cr>", mode = "t", desc = "normal mode" },
    { "<leader><Esc>", "<cmd><C-\\><C-n><cr><cmd><C-w>c<cr>", mode = "t", desc = "close terminal" },
  },
}
