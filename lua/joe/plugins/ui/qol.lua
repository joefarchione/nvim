return {
  "folke/snacks.nvim",
  opts = {
    scroll = {
      enabled = false,
      animate = {
        duration = { step = 10, total = 50 },
        easing = "linear",
      },
    },
    zen = {
      enabled = true,
      toggles = {
        dim = true,
        git_signs = false,
        mini_diff_signs = false,
        diagnostics = false,
        inlay_hints = false,
      },
      zoom = {
        width = 0.8,
        height = 0.9,
      },
    },
    rename = {
      enabled = true,
    },
    indent = {
      enabled = true,
      indent = {
        char = "│",
        blank = " ",
      },
      scope = {
        enabled = true,
        char = "│",
        underline = false,
      },
    },
    scope = { enabled = true },
    input = {
      enabled = true,
    },
    notifier = {
      enabled = true,
    },
    scratch = {
      enabled = true,
      win = {
        width = 100,
        height = 30,
        border = "rounded",
      },
      ft = "markdown",
    },
    quickfile = {
      enabled = true,
    },
    bigfile = {
      enabled = true,
      size = 1024 * 1024, -- 1MB
      setup = function(ctx)
        vim.cmd "syntax off"
        vim.cmd "IBLDisable"
        vim.opt_local.foldmethod = "manual"
        vim.opt_local.spell = false
        vim.schedule(function() vim.bo[ctx.buf].syntax = ctx.ft end)
      end,
    },
    toggle = {
      enabled = true,
    },
    words = { enabled = true },
  },
  keys = {
    --- zen
    {
      "<leader>z",
      function() Snacks.zen() end,
      desc = "Toggle Zen Mode",
    },
    {
      "<leader>Z",
      function() Snacks.zen.zoom() end,
      desc = "Toggle Zoom",
    },
    {
      "<leader>.",
      function() Snacks.scratch() end,
      desc = "Toggle Scratch Buffer",
    },
    -- scratch select (under toggle utils to avoid <leader>S sessions conflict)
    {
      "<leader>uS",
      function() Snacks.scratch.select() end,
      desc = "Select Scratch Buffer",
    },
    -- Rename (under File group)
    {
      "<leader>fR",
      function() Snacks.rename.rename_file() end,
      desc = "Rename File",
    },
    -- Toggle utilities
    {
      "<leader>un",
      function() Snacks.notifier.hide() end,
      desc = "Dismiss All Notifications",
    },
    {
      "<leader>ul",
      function() Snacks.toggle.line_number() end,
      desc = "Toggle Line Numbers",
    },
    {
      "<leader>ur",
      function() Snacks.toggle.option("relativenumber", { name = "Relative Number" }) end,
      desc = "Toggle Relative Line Numbers",
    },
    {
      "<leader>uw",
      function() Snacks.toggle.option("wrap", { name = "Wrap" }) end,
      desc = "Toggle Line Wrap",
    },
    {
      "<leader>us",
      function() Snacks.toggle.option("spell", { name = "Spelling" }) end,
      desc = "Toggle Spelling",
    },
    {
      "<leader>ud",
      function() Snacks.toggle.diagnostics() end,
      desc = "Toggle Diagnostics",
    },
    {
      "<leader>ui",
      function()
        -- Toggle inlay hints both at the Neovim level AND at FSAC's server-side
        -- config. FSAC pushes workspace/inlayHint/refresh and Neovim re-fetches,
        -- so disabling only client-side leaves the hints flickering back on.
        local current = vim.lsp.inlay_hint.is_enabled { bufnr = 0 }
        local enabled = not current
        vim.lsp.inlay_hint.enable(enabled, { bufnr = 0 })

        for _, client in ipairs(vim.lsp.get_clients { name = "fsautocomplete" }) do
          client.settings = vim.tbl_deep_extend("force", client.settings or {}, {
            FSharp = {
              InlayHints = {
                parameterNames = enabled,
                typeAnnotations = enabled,
              },
            },
          })
          client:notify("workspace/didChangeConfiguration", { settings = client.settings })
        end
        Snacks.notify("Inlay hints " .. (enabled and "enabled" or "disabled"))
      end,
      desc = "Toggle Inlay Hints",
    },
    {
      "<leader>uH",
      function()
        -- Combined toggle: flip inlay hints and FSAC CodeLenses together.
        -- "All hints off" is the common ask while typing — one key, one state.
        local current = vim.g.hints_enabled ~= false
        local enabled = not current
        vim.g.hints_enabled = enabled
        vim.g.codelens_enabled = enabled

        vim.lsp.inlay_hint.enable(enabled, { bufnr = 0 })

        for _, client in ipairs(vim.lsp.get_clients { name = "fsautocomplete" }) do
          client.settings = vim.tbl_deep_extend("force", client.settings or {}, {
            FSharp = {
              InlayHints = {
                parameterNames = enabled,
                typeAnnotations = enabled,
              },
              CodeLenses = {
                Signature = { Enabled = enabled },
                References = { Enabled = enabled },
              },
            },
          })
          client:notify("workspace/didChangeConfiguration", { settings = client.settings })
        end

        if enabled then
          vim.lsp.codelens.refresh()
        else
          vim.lsp.codelens.clear()
        end
        Snacks.notify((enabled and "Hints enabled" or "Hints disabled") .. " (inlay + codelens)")
      end,
      desc = "Toggle Hints (inlay + codelens)",
    },
  },
}
