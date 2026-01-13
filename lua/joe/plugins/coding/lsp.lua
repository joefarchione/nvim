return {
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "copilot" } },
    keys = {
      { "<leader>mo", "<cmd>Mason<cr>", desc = "Open Mason" },
      { "<leader>mu", "<cmd>MasonUpdate<cr>", desc = "Update Mason" },
      { "<leader>mt", "<cmd>MasonToolsUpdate<cr>", desc = "Update Mason Tools" },
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "mason-org/mason.nvim",
    },
    opts = {
      ensure_installed = { "lua_ls", "pyright", "yamlls", "marksman", "powershell_es", "taplo", "copilot" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "mason-org/mason-lspconfig.nvim" },
    config = function()
      -- Enable LSP servers (diagnostics configured in config/autocmds.lua)
      vim.lsp.enable { "lua_ls", "pyright", "yamlls", "marksman", "powershell_es", "taplo", "copilot" }
    end,
  },
}
