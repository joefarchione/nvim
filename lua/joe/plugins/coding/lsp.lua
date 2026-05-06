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
      auto_update = false,
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
      -- Some servers (e.g. FSAC) don't advertise signatureHelp trigger chars,
      -- which causes a "couldn't find a trigger char" warning. Force the
      -- standard ones so signature help works regardless of what the server says.
      extra_trigger_chars = { "(", "," },
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

      -- Quiet noisy LSP notifications: only surface WARN/ERROR from
      -- window/showMessage; drop logMessage and $/progress entirely.
      local show_message = function(_, result, ctx)
        if not result or result.type > vim.lsp.protocol.MessageType.Warning then
          return
        end
        local client = vim.lsp.get_client_by_id(ctx.client_id)
        local lvl = result.type == vim.lsp.protocol.MessageType.Error and vim.log.levels.ERROR
          or vim.log.levels.WARN
        vim.notify(result.message, lvl, { title = "LSP | " .. (client and client.name or "?") })
      end
      vim.lsp.handlers["window/showMessage"] = show_message
      vim.lsp.handlers["window/logMessage"] = function() end
      vim.lsp.handlers["$/progress"] = function() end

      -- Apply shared capabilities and on_attach to all servers
      -- Server-specific settings come from after/lsp/<server>.lua (Neovim 0.11+)
      vim.lsp.config("*", {
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          if client:supports_method("textDocument/inlayHint", bufnr) then
            -- Only enable once per buffer so a user toggle (e.g. <leader>ui) survives
            -- LSP reattaches — F#/FSAC restarts often, which would otherwise force them back on.
            if not vim.b[bufnr].inlay_hints_initialized then
              vim.b[bufnr].inlay_hints_initialized = true
              vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
            end
          end
          if client:supports_method("textDocument/signatureHelp", bufnr) then
            require("lsp_signature").on_attach({
              bind = true,
              handler_opts = { border = "rounded" },
              extra_trigger_chars = { "(", "," },
            }, bufnr)
          end
        end,
      })

      vim.lsp.enable(servers)
    end,
  },
}
