return {
  {
    "nvim-neorg/neorg",
    lazy = false,
    ft = "norg",
    enabled = false,
    version = "*",
    build = ":Neorg sync-parsers",
    dependencies = {
      "nvim-neorg/tree-sitter-norg",
      "nvim-treesitter/nvim-treesitter",
      "benlubas/neorg-interim-ls",
    },
    opts = {
      load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {
          config = {
            folds = true,
            icon_preset = "diamond",
          },
        },
        ["core.completion"] = {
          config = { engine = { module_name = "external.lsp-completion" } },
        },
        ["core.dirman"] = {
          config = {
            workspaces = {
              journal = "~/.org/journal",
              meetings = "~/.org/meetings",
              projects = "~/.org/projects",
              reading = "~/.org/reading",
              todo = "~/.org/todo",
              work = "~/.org/work",
            },
            default_workspace = "journal",
          },
        },
        ["core.journal"] = {
          config = {
            workspace = "journal",
            journal_folder = "",
            strategy = "flat",
          },
        },
        ["core.summary"] = {},
        ["core.export"] = {},
        ["core.export.markdown"] = {},
        ["core.qol.toc"] = {},
        ["core.qol.todo_items"] = {},
        ["core.presenter"] = {
          config = {
            zen_mode = "zen-mode",
          },
        },
      },
    },
    config = function(_, opts)
      require("neorg").setup(opts)
      -- Start neorg-interim-ls for blink.cmp completion
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "norg",
        callback = function() require("neorg-interim-ls").buf_attach() end,
      })
    end,
    keys = {

      { "<leader>n", group = "Neorg" },
      { "<leader>ne", group = "Neorg Export" },
      { "<leader>nf", group = "Neorg Find" },
      { "<leader>nn", group = "Neorg New" },
      { "<leader>nt", group = "Neorg Todo" },
      { "<leader>nw", group = "Neorg Workspace" },
      -- Journal keymaps
      { "<leader>nj", "<cmd>Neorg journal today<cr>", desc = "Journal today" },
      {
        "<leader>nd",
        function() require("joe.utils.neorg_snacks_picker").create_daily_with_prev_link() end,
        desc = "Daily note (with prev link)",
      },
      { "<leader>ny", "<cmd>Neorg journal yesterday<cr>", desc = "Journal yesterday" },
      { "<leader>nt", "<cmd>Neorg journal tomorrow<cr>", desc = "Journal tomorrow" },
      { "<leader>nc", "<cmd>Neorg journal toc open<cr>", desc = "Journal table of contents" },

      -- Workspace navigation
      { "<leader>nwj", "<cmd>Neorg workspace journal<cr>", desc = "Journal workspace" },
      { "<leader>nww", "<cmd>Neorg workspace work<cr>", desc = "Work workspace" },
      { "<leader>nwr", "<cmd>Neorg workspace reading<cr>", desc = "Reading workspace" },
      { "<leader>nwt", "<cmd>Neorg workspace todo<cr>", desc = "Todo workspace" },

      -- Create notes
      {
        "<leader>nnw",
        function() require("joe.utils.neorg_snacks_picker").create_work_note() end,
        desc = "New work note",
      },
      {
        "<leader>nnr",
        function() require("joe.utils.neorg_snacks_picker").create_reading_note() end,
        desc = "New reading note",
      },

      -- Neorg commands
      { "<leader>ni", "<cmd>Neorg index<cr>", desc = "Index" },
      { "<leader>nr", "<cmd>Neorg return<cr>", desc = "Return (close neorg)" },
      { "<leader>nm", "<cmd>Neorg inject-metadata<cr>", desc = "Inject metadata" },

      -- Export
      { "<leader>nef", "<cmd>Neorg export to-file<cr>", desc = "Export to file" },
      { "<leader>nem", "<cmd>Neorg export to-file markdown<cr>", desc = "Export to markdown" },

      -- Snacks.picker integration
      {
        "<leader>nff",
        function() require("joe.utils.neorg_snacks_picker").find_files() end,
        desc = "Find neorg files",
      },
      { "<leader>nfg", function() require("joe.utils.neorg_snacks_picker").grep_notes() end, desc = "Grep notes" },
      {
        "<leader>nfh",
        function() require("joe.utils.neorg_snacks_picker").find_headings() end,
        desc = "Search headings",
      },
      {
        "<leader>nfl",
        function() require("joe.utils.neorg_snacks_picker").find_linkables() end,
        desc = "Find linkable",
      },

      -- Todo management
      { "<leader>ntu", "<cmd>Neorg keybind all core.qol.todo_items.todo.task_undone<cr>", desc = "Mark undone" },
      { "<leader>ntp", "<cmd>Neorg keybind all core.qol.todo_items.todo.task_pending<cr>", desc = "Mark pending" },
      { "<leader>ntd", "<cmd>Neorg keybind all core.qol.todo_items.todo.task_done<cr>", desc = "Mark done" },
      { "<leader>nth", "<cmd>Neorg keybind all core.qol.todo_items.todo.task_on_hold<cr>", desc = "Mark on hold" },
      { "<leader>ntc", "<cmd>Neorg keybind all core.qol.todo_items.todo.task_cancelled<cr>", desc = "Mark cancelled" },
      { "<leader>ntr", "<cmd>Neorg keybind all core.qol.todo_items.todo.task_recurring<cr>", desc = "Mark recurring" },
      { "<leader>nti", "<cmd>Neorg keybind all core.qol.todo_items.todo.task_important<cr>", desc = "Mark important" },

      -- Table of contents
      { "<leader>no", "<cmd>Neorg toc<cr>", desc = "Table of contents" },
    },
  },
}
