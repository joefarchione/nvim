return {
  "jpalardy/vim-slime",
  init = function()
    vim.g.slime_target = "tmux"
    vim.g.slime_default_config = { socket_name = "default", target_pane = "{last}" }
    vim.g.slime_dont_ask_default = 1
    vim.g.slime_bracketed_paste = 1
    vim.g.slime_no_mappings = 1
  end,
  keys = {
    { "<leader>rs", "<Plug>SlimeMotionSend", desc = "Send motion" },
    { "<leader>rs", "<Plug>SlimeRegionSend", mode = "x", desc = "Send selection" },
    { "<leader>rl", "<Plug>SlimeLineSend", desc = "Send line" },
    { "<leader>rp", "<Plug>SlimeParagraphSend", desc = "Send paragraph" },
    { "<leader>rC", "<Plug>SlimeConfig", desc = "Slime config" },
  },
}
