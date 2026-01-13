-- Convert quarto file to python
vim.api.nvim_create_user_command("QmdToPy", function()
  local qmd_file = vim.api.nvim_buf_get_name(0)
  if not qmd_file:match "%.qmd$" then
    Snacks.notify("Not a .qmd file", vim.log.levels.WARN)
    return
  end
  local py_file = qmd_file:gsub("%.qmd$", ".py")
  vim.fn.jobstart({ "quarto", "convert", qmd_file, "--output", py_file }, {
    on_exit = function(_, code)
      if code == 0 then
        Snacks.notify("Converted to " .. vim.fn.fnamemodify(py_file, ":t"), vim.log.levels.INFO)
      else
        Snacks.notify("Quarto convert failed", vim.log.levels.ERROR)
      end
    end,
  })
end, { desc = "Convert current .qmd file to .py" })
