return {
  {
    "folke/snacks.nvim",
    opts = {
      explorer = {
        auto_close = true,
        enable = true,
      },
      picker = {
        sources = {
          explorer = {
            enable = true,
            -- Git integration
            git_status = true,
            git_status_open = true, -- show recursive git status for open dirs
            git_untracked = true,
            -- Diagnostics integration
            diagnostics = true,
            diagnostics_open = true, -- show recursive diagnostics for open dirs
            -- Default floating layout for explorer
            layout = {
              preview = true,
              layout = {
                box = "horizontal",
                width = 0.8,
                height = 0.8,
                {
                  box = "vertical",
                  border = "rounded",
                  title = "{source} {live} {flags}",
                  title_pos = "center",
                  { win = "input", height = 1, border = "rounded" },
                  { win = "list", border = "rounded" },
                },
                { win = "preview", border = "rounded", width = 0.7, title = "{preview}" },
              },
            },
          },
        },
      },
    },
    keys = {
      {
        "<leader>ee",
        function() Snacks.explorer.open() end,
        desc = "Open (Float)",
      },
      {
        "<leader>el",
        function() Snacks.picker.explorer { layout = "sidebar" } end,
        desc = "Open (Left)",
      },
      { "<leader>eh", function() Snacks.explorer.health() end, desc = "Health" },
      { "<leader>er", function() Snacks.explorer.reveal() end, desc = "Reveal" },
    },
  },
  {
    "stevearc/oil.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      {
        "refractalize/oil-git-status.nvim",
        opts = {},
      },
    },
    keys = {
      { "<leader>eb", "<cmd>Oil<cr>", desc = "Oil - open parent directory" },
    },
    opts = {
      default_file_explorer = false,
      view_options = {
        show_hidden = true,
      },
      win_options = {
        signcolumn = "yes:2",
      },
    },
  },
}
