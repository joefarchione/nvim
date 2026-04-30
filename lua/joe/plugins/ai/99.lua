return {
  "ThePrimeagen/99",
  event = "VeryLazy",
  config = function()
    local _99 = require "99"
    local worker = require "99.extensions.work.worker"

    local models = {
      "claude-sonnet-4-5",
      "claude-opus-4-6",
      "claude-haiku-4-5",
    }
    local current_model = models[1]

    local function setup()
      _99.setup {
        provider = "ClaudeCodeProvider",
        model = current_model,
        tmp_dir = "./tmp",
      }
    end

    setup()

    local function select_model()
      vim.ui.select(models, {
        prompt = "99 Model:",
        format_item = function(item)
          if item == current_model then return item .. " (current)" end
          return item
        end,
      }, function(choice)
        if not choice or choice == current_model then return end
        current_model = choice
        setup()
        Snacks.notify("99 model → " .. choice)
      end)
    end

    local wk = require "which-key"
    wk.add {
      { "<leader>9", group = "99 AI" },
      { "<leader>9s", _99.search, desc = "Search codebase" },
      { "<leader>9v", _99.visual, desc = "Transform selection", mode = "v" },
      { "<leader>9b", _99.vibe, desc = "Vibe mode" },
      { "<leader>9o", _99.open, desc = "Open results" },
      { "<leader>9x", _99.stop_all_requests, desc = "Cancel requests" },
      { "<leader>9X", _99.clear_previous_requests, desc = "Clear history" },
      { "<leader>9m", select_model, desc = "Select model" },
      { "<leader>9w", group = "Worker" },
      { "<leader>9ws", function() worker.set_work() end, desc = "Set work task" },
      { "<leader>9wf", function() worker.search() end, desc = "Find next work item" },
    }
  end,
}
