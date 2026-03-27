return {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--query-driver=/usr/lib/llvm-23/bin/clang,/usr/lib/llvm-23/bin/clang++",
  },
}
