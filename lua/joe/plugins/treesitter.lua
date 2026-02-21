return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  opts = {
    ensure_installed = { "python", "c", "lua", "vim", "vimdoc", "query", "rust", "julia", "cpp", "ocaml", "markdown", "markdown_inline", "yaml", "toml", "bash" },
    highlight = { enable = true },
  },
}
