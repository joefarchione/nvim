return {
  "L3MON4D3/LuaSnip",
  version = "v2.*",
  build = "make install_jsregexp",
  event = "InsertEnter",
  dependencies = {
    "rafamadriz/friendly-snippets",
  },
  keys = {
    {
      "<Tab>",
      function()
        if require("luasnip").expand_or_jumpable() then
          return "<Plug>luasnip-expand-or-jump"
        else
          return "<Tab>"
        end
      end,
      expr = true,
      silent = true,
      mode = "i",
    },
    {
      "<Tab>",
      function() require("luasnip").jump(1) end,
      mode = "s",
    },
    {
      "<S-Tab>",
      function() require("luasnip").jump(-1) end,
      mode = { "i", "s" },
    },
  },
  config = function()
    local ls = require "luasnip"
    local s = ls.snippet
    local t = ls.text_node
    local i = ls.insert_node

    ls.setup {
      history = true,
      updateevents = "TextChanged,TextChangedI",
    }

    -- Load friendly-snippets
    require("luasnip.loaders.from_vscode").lazy_load()

    -- Quarto snippets
    ls.add_snippets("quarto", {
      s("py", {
        t { "```{python}", "" },
        i(1),
        t { "", "```" },
      }),
      s("pycell", {
        t { "```{python}", "#| label: " },
        i(1, "cell-name"),
        t { "", "#| echo: true", "", "" },
        i(2),
        t { "", "```" },
      }),
      s("r", {
        t { "```{r}", "" },
        i(1),
        t { "", "```" },
      }),
    })

    -- Also apply to markdown (quarto uses .qmd but is often detected as markdown)
    ls.filetype_extend("markdown", { "quarto" })
  end,
}
