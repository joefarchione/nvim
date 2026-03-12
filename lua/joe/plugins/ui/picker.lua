return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      -- Git and diagnostics display
      icons = {
        git = {
          enabled = true,
          staged = "●",
          added = "A",
          deleted = "D",
          ignored = "I",
          modified = "○",
          renamed = "R",
          unmerged = "U",
          untracked = "?",
        },
        diagnostics = {
          Error = "",
          Warn = "",
          Hint = "󰌵 ",
          Info = "󰌵",
        },
      },
      formatters = {
        file = {
          filename_first = true,
        },
        filename = {
          git_status_hl = true, -- highlight filename with git status color
        },
        severity = {
          icons = true,
          pos = "left",
        },
      },
      win = {
        input = {
          keys = {
            ["<a-c>"] = {
              "toggle_cwd",
              mode = { "n", "i" },
            },
          },
        },
      },
    },
  },
  keys = {
    { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep (Root Dir)" },
    { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader><space>", function() Snacks.picker.files() end, desc = "Find Files (Root Dir)" },
    -- find
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>fB", function() Snacks.picker.buffers { hidden = true, nofile = true } end, desc = "Buffers (all)" },
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files (Root Dir)" },
    { "<leader>fF", function() Snacks.picker.files { root = false } end, desc = "Find Files (cwd)" },
    { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Files (git-files)" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
    { "<leader>fO", function() Snacks.picker.recent { filter = { cwd = true } } end, desc = "Recent (cwd)" },
    { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
    { "<leader>fX", function() Snacks.picker.files { cwd = vim.fn.stdpath "config" } end, desc = "Find Config File" },
    -- git (unified under <leader>g)
    { "<leader>gD", function() Snacks.picker.git_diff() end, desc = "Git Diff (hunks)" },
    {
      "<leader>gO",
      function() Snacks.picker.git_diff { base = "origin", group = true } end,
      desc = "Git Diff (origin)",
    },
    { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
    { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
    { "<leader>gi", function() Snacks.picker.gh_issue() end, desc = "GitHub Issues (open)" },
    { "<leader>gI", function() Snacks.picker.gh_issue { state = "all" } end, desc = "GitHub Issues (all)" },
    { "<leader>gR", function() Snacks.picker.gh_pr() end, desc = "GitHub PRs (open)" },
    -- Grep
    { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
    { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
    { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep (Root Dir)" },
    { "<leader>sG", function() Snacks.picker.grep { root = false } end, desc = "Grep (cwd)" },
    { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
    { "<leader>sX", function() Snacks.picker.grep { cwd = vim.fn.stdpath "config" } end, desc = "Config" },
    {
      "<leader>sw",
      function() Snacks.picker.grep_word() end,
      desc = "Visual selection or word (Root Dir)",
      mode = { "n", "x" },
    },
    {
      "<leader>sW",
      function() Snacks.picker.grep_word { root = false } end,
      desc = "Visual selection or word (cwd)",
      mode = { "n", "x" },
    },
    -- search
    { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
    { "<leader>s/", function() Snacks.picker.search_history() end, desc = "Search History" },
    { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
    { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
    { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
    { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
    { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
    { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
    { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
    { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
    { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
    { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
    { "<leader>sn", function() Snacks.picker.notifications() end, desc = "Notification History" },
    { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
    { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
    { "<leader>su", function() Snacks.picker.undo() end, desc = "Undotree" },
    -- ui
    { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
  },
}
