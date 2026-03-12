return {
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gwrite", "Gread", "Gdiffsplit", "Gvdiffsplit" },
    keys = {
      { "<leader>go", "<cmd>Git<cr>", desc = "Open Fugitive" },
      { "<leader>gc", "<cmd>Git commit<cr>", desc = "Git commit" },
      { "<leader>gp", "<cmd>Git push<cr>", desc = "Git push" },
      { "<leader>gf", "<cmd>Git pull<cr>", desc = "Git pull" },
      { "<leader>gl", "<cmd>Git log --oneline<cr>", desc = "Git log" },
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diff view (diffview)" },
      { "<leader>gF", "<cmd>DiffviewFileHistory %<cr>", desc = "File history (diffview)" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Branch history (diffview)" },
      { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
    },
  },
  {
    "folke/snacks.nvim",
    opts = {
      lazygit = {
        enabled = true,
      },
      git = {
        enabled = true,
      },
      gitbrowse = {
        enabled = true,
      },
    },
    keys = {
      {
        "<leader>gb",
        function() Snacks.git.blame_line() end,
        desc = "Git blame line",
      },
      {
        "<leader>gB",
        function() Snacks.gitbrowse() end,
        desc = "Git browse",
      },
    },
  },
}
