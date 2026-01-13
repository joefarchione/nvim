return {
  "saghen/blink.cmp",
  dependencies = {
    "rafamadriz/friendly-snippets",
    "onsails/lspkind.nvim",
    "fang2hou/blink-copilot",
    {
      "nvim-mini/mini.icons",
      config = function()
        require("mini.icons").setup {}
        -- Mock nvim-web-devicons for compatibility with other plugins
        require("mini.icons").mock_nvim_web_devicons()
      end,
    },
  },
  version = "*",

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    appearance = {
      use_nvim_cmp_as_default = false,
      nerd_font_variant = "mono",
    },
    completion = {
      keyword = { range = "prefix" },
      accept = { auto_brackets = { enabled = true } },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 250,
        treesitter_highlighting = true,
        window = { border = "rounded" },
      },

      list = {
        selection = { preselect = true, auto_insert = true },
      },
      ghost_text = {
        enabled = true,
      },

      menu = {
        border = "rounded",
        cmdline_position = function()
          if vim.g.ui_cmdline_pos ~= nil then
            local pos = vim.g.ui_cmdline_pos -- (1, 0)-indexed
            return { pos[1] - 1, pos[2] }
          end
          local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
          return { vim.o.lines - height, 0 }
        end,
        draw = {
          columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind", gap = 1 } },
          components = {
            kind_icon = {
              text = function(ctx)
                if vim.tbl_contains({ "Path" }, ctx.source_name) then
                  local mini_icon, _ = require("mini.icons").get_icon(ctx.item.data.type, ctx.label)
                  if mini_icon then return mini_icon .. ctx.icon_gap end
                end

                local icon = require("lspkind").symbolic(ctx.kind, { mode = "symbol" })
                return icon .. ctx.icon_gap
              end,

              -- Optionally, use the highlight groups from mini.icons
              -- You can also add the same function for `kind.highlight` if you want to
              -- keep the highlight groups in sync with the icons.
              highlight = function(ctx)
                if vim.tbl_contains({ "Path" }, ctx.source_name) then
                  local mini_icon, mini_hl = require("mini.icons").get_icon(ctx.item.data.type, ctx.label)
                  if mini_icon then return mini_hl end
                end
                return ctx.kind_hl
              end,
            },
            kind = {
              -- Optional, use highlights from mini.icons
              highlight = function(ctx)
                if vim.tbl_contains({ "Path" }, ctx.source_name) then
                  local mini_icon, mini_hl = require("mini.icons").get_icon(ctx.item.data.type, ctx.label)
                  if mini_icon then return mini_hl end
                end
                return ctx.kind_hl
              end,
            },
          },
        },
      },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
    signature = { enabled = false },
    cmdline = {
      enabled = true,
      keymap = {
        preset = "cmdline",
        ["<Right>"] = false,
        ["<Left>"] = false,
      },
      completion = {
        list = { selection = { preselect = true } },
        menu = {
          auto_show = function(ctx) return vim.fn.getcmdtype() == ":" end,
        },
        ghost_text = { enabled = true },
      },
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer", "copilot" },
      per_filetype = {
        lua = { inherit_defaults = true, "lazydev" },
        norg = { "lsp", "path", "buffer" },
      },
      providers = {
        copilot = {
          name = "copilot",
          module = "blink-copilot",
          score_offset = 100,
          async = true,
        },
        lsp = {
          min_keyword_length = 2, -- Number of characters to trigger porvider
          score_offset = 0, -- Boost/penalize the score of the items
        },
        path = {
          min_keyword_length = 0,
        },
        snippets = {
          min_keyword_length = 2,
        },
        buffer = {
          min_keyword_length = 5,
          max_items = 5,
        },
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100,
        },
      },
    },
    keymap = {
      preset = "enter",
      ["<C-y>"] = { "select_and_accept" },
      ["<C-Space>"] = {
        function(cmp)
          cmp.show() -- Explicitly shows the completion menu
        end,
        "fallback", -- Fallback to default Neovim behavior if blink can't handle it
      },
    },
  },
}
