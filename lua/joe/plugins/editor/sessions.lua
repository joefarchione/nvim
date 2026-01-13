-- Lua
return {
  "folke/persistence.nvim",
  event = "BufReadPre", -- this will only start session saving when an actual file was opened
  opts = {
    -- add any custom options here
  },
  keys = {
    { "<leader>Ss", function() require("persistence").load() end, desc = "Load cwd session" },
    { "<leader>SS", function() require("persistence").select() end, desc = "Select session" },
    { "<leader>Sl", function() require("persistence").load { last = true } end, desc = "Load last session" },
    { "<leader>Sd", function() require("persistence").stop() end, desc = "Stop save on exit" },
  },
}
