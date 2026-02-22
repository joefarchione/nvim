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
        "bufls",
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
        "bufls",
        "contextive",
      }
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- Global diagnostic configuration
      vim.diagnostic.config {
        float = { border = "rounded" },
      }
      for _, server_name in ipairs(servers) do
        local config = require("lspconfig.configs")[server_name]
        if config then
          -- Use the new vim.lsp.config interface (Neovim 0.11+)
          vim.lsp.config(server_name, {
            cmd = config.default_config.cmd,
            filetypes = config.default_config.filetypes,
            root_markers = config.default_config.root_dir,
            capabilities = capabilities,
            settings = (server_name == "lua_ls") and {
              Lua = {
                hint = { enable = true },
              },
            } or (server_name == "fsautocomplete") and {
              FSharp = {
                keywordsAutocomplete = true,
                externalAutocomplete = true,
                LSPv2 = true,
                UnusedOpens = true,
                SimplifyNames = true,
                UnusedDeclarations = true,
                UnionCaseStubGeneration = true,
                InterfaceStubGeneration = true,
                AbstractClassStubGeneration = true,
                RecordStubGeneration = true,
              },
            } or nil,

            on_attach = function(client, bufnr)
              -- Disable inlay hints by default
              if client.supports_method "textDocument/inlayHint" then
                vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
              end
              -- Attach signature help
              require("lsp_signature").on_attach({
                bind = true,
                handler_opts = { border = "rounded" },
              }, bufnr)
            end,
          })

          -- Enable the server
          vim.lsp.enable(server_name)
        end
      end
    end,
  },
}
