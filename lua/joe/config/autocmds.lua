local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Quarto filetype detection
vim.filetype.add {
  extension = {
    qmd = "quarto",
  },
}

local highlight_group = augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
  pattern = "*",
  callback = function() vim.highlight.on_yank { timeout = 170 } end,
  group = highlight_group,
})

autocmd("BufReadPre", {
  desc = "Disable certain functionality on very large files",
  group = augroup("large_buf", { clear = true }),
  callback = function(args)
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(args.buf))
    vim.b[args.buf].large_buf = (ok and stats and stats.size > vim.g.max_file.size)
      or vim.api.nvim_buf_line_count(args.buf) > vim.g.max_file.lines
  end,
})

-- Configure diagnostics with icons
local icons = require("joe.utils").icons
vim.diagnostic.config {
  virtual_text = {
    prefix = "●",
    spacing = 4,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = icons.error,
      [vim.diagnostic.severity.WARN] = icons.warning,
      [vim.diagnostic.severity.HINT] = icons.hint,
      [vim.diagnostic.severity.INFO] = icons.info,
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = true,
    header = "",
    prefix = "",
  },
}
