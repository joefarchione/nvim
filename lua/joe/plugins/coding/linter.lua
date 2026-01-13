return {
  {
    "mfussenegger/nvim-lint",
    event = "VeryLazy",
    dependencies = {
      "rshkarin/mason-nvim-lint",
    },
    config = function()
      require("lint").linters_by_ft = {
        ["json"] = { "jsonlint" },
        ["jsonc"] = { "jsonlint" },
        ["yaml"] = { "yamllint" },
        ["markdown"] = { "markdownlint", "codespell" },
        ["python"] = { "flake8" },
        ["sql"] = { "sqlfluff" },
      }

      vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
        callback = function() require("lint").try_lint() end,
      })

      vim.api.nvim_create_user_command("DisableLinterByFt", function()
        local ft = vim.filetype.match { buf = 0 }

        if not ft then return end
        local lint = require "lint"
        local linter = lint.linters_by_ft[ft]
        lint.linters_by_ft[ft] = {}
        vim.diagnostic.reset(nil, 0)
        Snacks.notify("Linter " .. linter .. " disabled")
      end, {})
    end,
  },
  {
    "rshkarin/mason-nvim-lint",
    dependencies = {
      "mason-org/mason.nvim",
      "mfussenegger/nvim-lint",
    },
    opts = {
      ensure_installed = {
        "flake8",
        "jsonlint",
        "yamllint",
        "markdownlint",
        "codespell",
        "sqlfluff",
      },
    },
  },
}
