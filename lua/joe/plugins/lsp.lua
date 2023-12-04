return {
  {
    'williamboman/mason.nvim',
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
      'neovim/nvim-lspconfig',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
    },
    config = function()
      local lsp = require 'lspconfig'
      local mason = require 'mason'
      local masonlspconfig = require 'mason-lspconfig'
      local masontool = require 'mason-tool-installer'
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      local navic = require 'nvim-navic'

      local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }

      for type, icon in pairs(signs) do
        local hl = 'DiagnosticSign' .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      vim.diagnostic.config {
        virtual_text = {
          prefix = '●',
        },
      }

      mason.setup()
      masonlspconfig.setup {
        automatic_installation = true,
      }
      masontool.setup {
        ensure_installed = { "pylsp", "lua_ls", "powershell_es", "csharp_ls", "rust-analyzer" },
        auto_update = true,
        run_on_start = true,
      }

      local on_attach = function(client, bufnr)
        navic.attach(client, bufnr)
      end

      lsp.lua_ls.setup {
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim' },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file('', true),
              checkThirdParty = false,
            },
          },
          capabilities = capabilities,
        },
        on_attach = on_attach
      }

      lsp.pylsp.setup {
        settings = {
          pylsp = {
            plugins = {
              pycodestyle = {
                ignore = { 'W391' },
                maxLineLength = 100
              },
              timeout = 1000,
            }
          },
          capabilities = capabilities
        },
        on_attach = on_attach
      }
      lsp.powershell_es.setup {
        on_attach = on_attach,
        settings = {
          capabilities = capabilities
        }
      }
      lsp.csharp_ls.setup {
        on_attach = on_attach,
        settings = {
          capabilities = capabilities
        }
      }
      lsp.rust_analyzer.setup {
        on_attach = on_attach,
        settings = {
          capabilities = capabilities
        }
      }
    end,
  },
  {
    "stevearc/aerial.nvim",
    event = { "BufReadPost", "BufNewFile", "BufWritePost" },
    opts = {
      attach_mode = "global",
      backends = { "lsp", "treesitter", "markdown", "man" },
      disable_max_lines = vim.g.max_file.lines,
      disable_max_size = vim.g.max_file.size,
      show_guides = true,
      filter_kind = false,
      guides = {
        mid_item = "├ ",
        last_item = "└ ",
        nested_top = "│ ",
        whitespace = "  ",
      },
      layout = {
        min_width = 28,
        placement = "edge",
        default_diretion = "prefer_right",
        resize_to_content = false,
      },
      keymaps = {
        ["[y"] = "actions.prev",
        ["]y"] = "actions.next",
        ["[Y"] = "actions.prev_up",
        ["]Y"] = "actions.next_up",
        ["{"] = false,
        ["}"] = false,
        ["[["] = false,
        ["]]"] = false,
      },
      on_attach = function(bufnr)
        -- Jump forwards/backwards with '{' and '}'
        vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
        vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
      end
    },
  }
}
