return {
  "benlubas/molten-nvim",
  version = "^1.0.0",
  enabled = false,
  build = ":UpdateRemotePlugins",
  dependencies = {
    "3rd/image.nvim",
  },
  ft = { "python", "quarto", "markdown" },
  keys = {
    { "<leader>ji", "<cmd>MoltenInit<cr>", desc = "Initialize kernel" },
    { "<leader>jI", "<cmd>MoltenInfo<cr>", desc = "Molten info" },
    { "<leader>jl", "<cmd>MoltenEvaluateLine<cr>", desc = "Evaluate line" },
    { "<leader>jv", "<cmd>MoltenEvaluateVisual<cr>", mode = "v", desc = "Evaluate visual" },
    { "<leader>jo", "<cmd>MoltenEvaluateOperator<cr>", desc = "Evaluate operator" },
    { "<leader>jr", "<cmd>MoltenReevaluateCell<cr>", desc = "Re-evaluate cell" },
    { "<leader>jd", "<cmd>MoltenDelete<cr>", desc = "Delete cell" },
    { "<leader>jh", "<cmd>MoltenHideOutput<cr>", desc = "Hide output" },
    { "<leader>js", "<cmd>MoltenShowOutput<cr>", desc = "Show output" },
    { "<leader>jx", "<cmd>MoltenInterrupt<cr>", desc = "Interrupt kernel" },
    { "<leader>jq", "<cmd>MoltenDeinit<cr>", desc = "Stop kernel" },
  },
  init = function()
    vim.g.molten_output_win_max_height = 20
    vim.g.molten_auto_open_output = false
    vim.g.molten_wrap_output = true
    vim.g.molten_virt_text_output = true
    vim.g.molten_virt_lines_off_by_1 = true
  end,
  config = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "MoltenInitPost",
      callback = function() Snacks.notify("Molten kernel initialized", vim.log.levels.INFO) end,
    })
  end,
}
