return {
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
        loadOutDirsFromCheck = true,
      },
      checkOnSave = {
        command = "clippy",
      },
      procMacro = {
        enable = true,
      },
      imports = {
        granularity = { group = "module" },
        prefix = "self",
      },
      inlayHints = {
        lifetimeElisionHints = { enable = "skip_trivial" },
      },
    },
  },
}
