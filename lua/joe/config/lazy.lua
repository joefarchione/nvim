local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { import = "joe/plugins" },
  { import = "joe/plugins/ai" },
  { import = "joe/plugins/coding" },
  { import = "joe/plugins/editor" },
  { import = "joe/plugins/git" },
  { import = "joe/plugins/ui" },
}, {})
