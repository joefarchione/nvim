return {
  "ThePrimeagen/git-worktree.nvim",
  config = function()
    require("git-worktree").setup()
  end,
  keys = {
    {
      "<leader>Gwl",
      "<cmd>lua require('git-worktree').get_worktree_tracker()._on_tree_change('SWITCH', {})<cr>", -- This is internal, let's use the CLI for now or standard
      desc = "List worktrees (CLI)",
    },
    {
      "<leader>Gwa",
      function()
        local name = vim.fn.input "Worktree name: "
        local branch = vim.fn.input "Branch name: "
        if name ~= "" and branch ~= "" then
          require("git-worktree").create_git_worktree(name, branch)
        end
      end,
      desc = "Create worktree",
    },
  },
}
