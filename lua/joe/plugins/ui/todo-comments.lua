return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = "VeryLazy",
  opts = {},
  keys = {
    { "]t", function() require("todo-comments").jump_next() end, desc = "Next TODO" },
    { "[t", function() require("todo-comments").jump_prev() end, desc = "Prev TODO" },
    { "<leader>st", "<cmd>TodoTrouble<cr>", desc = "TODOs (Trouble)" },
    { "<leader>sT", function() Snacks.picker.todo_comments() end, desc = "TODOs (Picker)" },
  },
}
