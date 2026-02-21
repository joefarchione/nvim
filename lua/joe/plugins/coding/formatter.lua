return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "isort", "black" }, -- isort runs first, then black
      markdown = { "prettier" },
      json = { "prettier" },
      yaml = { "prettier" },
      rust = { "rustfmt" },
      cpp = { "clang-format" },
      julia = { "JuliaFormatter" },
    },

    default_format_opts = {
      lsp_format = "fallback",
      timeout_ms = 1000,
    },

    format_on_save = {
      -- Use format_after_save for less interruption
      lsp_fallback = false,
    },
    format_after_save = {
      lsp_fallback = true,
    },
  },
  config = function(_, opts) require("conform").setup(opts) end,
}
