return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  opts = {
    ensure_installed = { "python", "c", "lua", "vim", "vimdoc", "query" },
    highlight = { enable = true },
  },
}
