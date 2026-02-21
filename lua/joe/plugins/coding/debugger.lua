return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = "mason.nvim",
        opts = {
          ensure_installed = { "debugpy", "netcoredbg" },
          automatic_installation = true,
        },
      },
    },
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
      {
        "<leader>dB",
        function() require("dap").set_breakpoint(vim.fn.input "Condition: ") end,
        desc = "Conditional breakpoint",
      },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to cursor" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step into" },
      { "<leader>do", function() require("dap").step_over() end, desc = "Step over" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "Step out" },
      { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
      { "<leader>ds", function() require("dap").session() end, desc = "Session" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle UI" },
      { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = { "n", "v" } },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run last" },
    },
    config = function()
      local dap = require "dap"
      local dapui = require "dapui"

      -- .NET Debugger (netcoredbg)
      dap.adapters.coreclr = {
        type = "executable",
        command = vim.fn.has "win32" == 1 and "netcoredbg.exe" or "netcoredbg",
        args = { "--interpreter=vscode" },
      }

      for _, lang in ipairs { "cs", "fsharp", "vb" } do
        dap.configurations[lang] = {
          {
            type = "coreclr",
            name = "launch - netcoredbg",
            request = "launch",
            program = function()
              return vim.fn.input("Path to dll", vim.fn.getcwd() .. "/bin/Debug/", "file")
            end,
          },
        }
      end

      -- DAP UI setup
      ---@diagnostic disable-next-line: missing-fields
      dapui.setup {
        icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            position = "left",
            size = 40,
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            position = "bottom",
            size = 10,
          },
        },
      }

      -- Virtual text setup
      require("nvim-dap-virtual-text").setup {
        commented = true,
      }

      -- Auto open/close dapui
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

      -- Signs
      local icons = require("joe.utils").icons
      vim.fn.sign_define("DapBreakpoint", { text = icons.filled, texthl = "DiagnosticError" })
      vim.fn.sign_define("DapBreakpointCondition", { text = icons.filled, texthl = "DiagnosticWarn" })
      vim.fn.sign_define("DapLogPoint", { text = icons.filled, texthl = "DiagnosticInfo" })
      vim.fn.sign_define("DapStopped", { text = icons.stop, texthl = "DiagnosticOk", linehl = "DapStoppedLine" })
      vim.fn.sign_define("DapBreakpointRejected", { text = icons.empty, texthl = "DiagnosticError" })
    end,
  },
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = { "mfussenegger/nvim-dap" },
    keys = {
      { "<leader>dPt", function() require("dap-python").test_method() end, desc = "Debug test method", ft = "python" },
      { "<leader>dPc", function() require("dap-python").test_class() end, desc = "Debug test class", ft = "python" },
      {
        "<leader>dPs",
        function() require("dap-python").debug_selection() end,
        desc = "Debug selection",
        mode = "v",
        ft = "python",
      },
    },
    config = function()
      -- Get debugpy path from mason
      local debugpy_path = vim.fn.stdpath "data" .. "/mason/packages/debugpy/venv/Scripts/python"
      -- Use forward slashes and .exe for Windows
      if vim.fn.has "win32" == 1 then debugpy_path = debugpy_path:gsub("/", "\\") .. ".exe" end
      require("dap-python").setup(debugpy_path)
      require("dap-python").test_runner = "pytest"
    end,
  },
}
