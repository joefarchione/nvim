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
        -- "ocamllsp", -- install with opam
        "julials",
        "fsautocomplete",
        -- "buf-language-server",
        "contextive",
        -- Formatters (conform.nvim)
        "stylua",
        "black",
        "prettier",
        -- Linters (nvim-lint)
        "flake8",
        "jsonlint",
        "yamllint",
        "markdownlint",
        "codespell",
        "sqlfluff",
        "contextive",
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
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    opts = {
      bind = true,
      handler_opts = {
        border = "rounded",
      },
      hint_enable = true,
      hint_prefix = "󱄑 ",
      toggle_key = "<C-k>", -- toggle signature on and off in insert mode
    },
    config = function(_, opts) require("lsp_signature").setup(opts) end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "mason-org/mason-lspconfig.nvim", "ray-x/lsp_signature.nvim" },
    config = function()
      local servers = {
        "lua_ls",
        "pyright",
        "yamlls",
        "marksman",
        "powershell_es",
        "taplo",
        "rust_analyzer",
        "clangd",
        -- "ocamllsp", -- install with opam
        "julials",
        "fsautocomplete",
        -- "buf-language-server",
        "contextive",
      }
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- Global diagnostic configuration
      vim.diagnostic.config {
        float = { border = "rounded" },
      }

      -- Apply shared capabilities and on_attach to all servers
      -- Server-specific settings come from after/lsp/<server>.lua (Neovim 0.11+)
      vim.lsp.config("*", {
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          if client.supports_method "textDocument/inlayHint" then
            vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
          end
          if client.supports_method "textDocument/signatureHelp" then
            require("lsp_signature").on_attach({
              bind = true,
              handler_opts = { border = "rounded" },
            }, bufnr)
          end
        end,
      })

      vim.lsp.enable(servers)
    end,
  },
}
