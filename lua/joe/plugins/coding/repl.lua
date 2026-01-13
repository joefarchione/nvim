return {
  "Vigemus/iron.nvim",
  keys = {
    { "<leader>rs", "<cmd>IronRepl<cr>", desc = "Start REPL" },
    { "<leader>rr", "<cmd>IronRestart<cr>", desc = "Restart REPL" },
    { "<leader>rf", "<cmd>IronFocus<cr>", desc = "Focus REPL" },
    { "<leader>rh", "<cmd>IronHide<cr>", desc = "Hide REPL" },
  },
  config = function()
    local iron = require "iron.core"
    local view = require "iron.view"

    iron.setup {
      config = {
        scratch_repl = true,
        repl_definition = {
          python = {
            command = { "python" },
          },
          ocaml = {
            command = { "utop" },
          },
          fsharp = {
            command = { "dotnet", "fsi" },
          },
        },
        repl_open_cmd = view.split.vertical.botright(80),
      },
      keymaps = {
        send_motion = "<leader>rc",
        visual_send = "<leader>rc",
        send_file = "<leader>rF",
        send_line = "<leader>rl",
        send_paragraph = "<leader>rp",
        send_until_cursor = "<leader>ru",
        send_mark = "<leader>rm",
        mark_motion = "<leader>rM",
        mark_visual = "<leader>rM",
        remove_mark = "<leader>rd",
        cr = "<leader>r<cr>",
        interrupt = "<leader>r<space>",
        exit = "<leader>rq",
        clear = "<leader>rx",
      },
      highlight = {
        italic = true,
      },
      ignore_blank_lines = true,
    }
  end,
}
