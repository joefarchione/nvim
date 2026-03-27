return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-python",
    "Issafalcon/neotest-dotnet",
    "rouge8/neotest-rust",
  },
  keys = {
    { "<leader>t", group = "Test" },
    {
      "<leader>tt",
      function() require("neotest").run.run() end,
      desc = "Run nearest test",
    },
    {
      "<leader>tf",
      function() require("neotest").run.run(vim.fn.expand "%") end,
      desc = "Run current file",
    },
    {
      "<leader>tT",
      function() require("neotest").run.run(vim.uv.cwd()) end,
      desc = "Run all tests",
    },
    {
      "<leader>td",
      function() require("neotest").run.run { strategy = "dap" } end,
      desc = "Debug nearest test",
    },
    {
      "<leader>ts",
      function() require("neotest").run.stop() end,
      desc = "Stop test",
    },
    {
      "<leader>to",
      function() require("neotest").output.open { enter = true, auto_close = true } end,
      desc = "Show output",
    },
    {
      "<leader>tO",
      function() require("neotest").output_panel.toggle() end,
      desc = "Toggle output panel",
    },
    {
      "<leader>tS",
      function() require("neotest").summary.toggle() end,
      desc = "Toggle summary",
    },
    {
      "<leader>tw",
      function() require("neotest").watch.toggle(vim.fn.expand "%") end,
      desc = "Toggle watch",
    },
  },
  opts = function()
    local function get_python_path()
      if require("joe.utils").is_available "venv-selector" then
        local python = require("venv-selector").python()
        Snacks.notify("Using env " .. python .. " for testing")
        if python then return python end
      else
        Snacks.notify "Fallback to system python for testing"
        return "python"
      end
    end

    return {
      adapters = {
        require "neotest-python" {
          dap = { justMyCode = false },
          runner = "pytest",
          python = get_python_path,
        },
        require "neotest-dotnet" {
          dap = {
            args = { justMyCode = false },
          },
          discovery_root = "solution",
        },
        require "neotest-rust",
      },
      status = { virtual_text = true },
      output = { open_on_run = true },
      quickfix = {
        open = function() Snacks.picker.qflist() end,
      },
    }
  end,
}
