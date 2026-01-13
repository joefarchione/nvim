return {
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gwrite", "Gread", "Gdiffsplit", "Gvdiffsplit" },
    keys = {
      { "<leader>Go", "<cmd>Git<cr>", desc = "Open Fugitive" },
      { "<leader>Gc", "<cmd>Git commit<cr>", desc = "Git commit" },
      { "<leader>Gp", "<cmd>Git push<cr>", desc = "Git push" },
      { "<leader>Gf", "<cmd>Git pull<cr>", desc = "Git pull" },
      { "<leader>Gl", "<cmd>Git log --oneline<cr>", desc = "Git log" },
      { "<leader>Gd", "<cmd>DiffviewOpen<cr>", desc = "Diff view (diffview)" },
      { "<leader>Gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File history (diffview)" },
      { "<leader>GH", "<cmd>DiffviewFileHistory<cr>", desc = "Branch history (diffview)" },
    },
  },
  {
    "folke/snacks.nvim",
    opts = {
      lazygit = {
        enabled = false,
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
        "<leader>Gb",
        function() Snacks.git.blame_line() end,
        desc = "Git blame line",
      },
      {
        "<leader>GB",
        function() Snacks.gitbrowse() end,
        desc = "Git browse",
      },
    },
  },
}
