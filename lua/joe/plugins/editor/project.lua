return {
  {
    'ahmedkhalf/project.nvim',
    config = function()
      require('project_nvim').setup {
        patterns = { '.git', '.gitignore', '.toml', '.conf', 'LICENSE' },
        manual_mode = true, -- don't auto-change cwd when opening files
      }
    end,
  },
}