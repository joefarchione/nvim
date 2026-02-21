return {
  {
    "mason-org/mason.nvim",
    keys = {
      { "<leader>mo", "<cmd>Mason<cr>", desc = "Open Mason" },
      { "<leader>mu", "<cmd>MasonUpdate<cr>", desc = "Update Mason" },
      { "<leader>mt", "<cmd>MasonToolsUpdate<cr>", desc = "Update Mason Tools" },
    },
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = {
        -- LSP Servers
        "lua_ls",
        "pyright",
        "yamlls",
        "marksman",
        "powershell_es",
        "taplo",
        "rust_analyzer",
        "clangd",
        "ocamllsp",
        "julials",
        -- Formatters (conform.nvim)
        "stylua",
        "isort",
        "black",
        "prettier",
        -- Linters (nvim-lint)
        "flake8",
        "jsonlint",
        "yamllint",
        "markdownlint",
        "codespell",
        "sqlfluff",
      },
      auto_update = true,
      run_on_start = true,
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "mason-org/mason.nvim",
    },
    opts = {
      -- We use mason-tool-installer for this now
      ensure_installed = {},
      automatic_installation = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "mason-org/mason-lspconfig.nvim" },
    config = function()
      -- Enable LSP servers
      local lspconfig = require "lspconfig"
      local servers = { "lua_ls", "pyright", "yamlls", "marksman", "powershell_es", "taplo", "rust_analyzer", "clangd", "ocamllsp", "julials" }

      for _, server in ipairs(servers) do
        lspconfig[server].setup {}
      end
    end,
  },
}
