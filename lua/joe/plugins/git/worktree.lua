return {
  "folke/snacks.nvim",
  keys = {
    {
      "<leader>gwl",
      function()
        local lines = vim.fn.systemlist "git worktree list --porcelain"
        local worktrees = {}
        local current = {}
        for _, line in ipairs(lines) do
          if line:match "^worktree " then
            current = { path = line:match "^worktree (.+)" }
          elseif line:match "^branch " then
            current.branch = line:match "^branch refs/heads/(.+)"
            table.insert(worktrees, current)
          end
        end
        vim.ui.select(worktrees, {
          prompt = "Switch worktree",
          format_item = function(wt)
            return (wt.branch or "detached") .. "  " .. wt.path
          end,
        }, function(choice)
          if choice then
            require("persistence").save()
            vim.cmd("cd " .. choice.path)
            require("persistence").load()
          end
        end)
      end,
      desc = "List & switch worktrees",
    },
    {
      "<leader>gwa",
      function()
        local branch = vim.fn.input "Branch: "
        if branch == "" then return end
        local path = vim.fn.input("Path: ", "../" .. branch .. "/", "dir")
        if path == "" then return end
        vim.fn.system { "git", "worktree", "add", path, "-b", branch }
        Snacks.notify("Created worktree: " .. path)
      end,
      desc = "Create worktree",
    },
    {
      "<leader>gwd",
      function()
        local path = vim.fn.input("Remove worktree path: ", "", "dir")
        if path == "" then return end
        vim.fn.system { "git", "worktree", "remove", path }
        Snacks.notify("Removed worktree: " .. path)
      end,
      desc = "Remove worktree",
    },
  },
}
