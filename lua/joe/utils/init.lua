local M = {}

function M.is_available(plugin)
  local lazy_config_avail, lazy_config = pcall(require, "lazy.core.config")
  return lazy_config_avail and lazy_config.spec.plugins[plugin] ~= nil
end

M.icons = {
  error = "",
  warning = "",
  hint = "󰌵",
  info = "",
  filled = "",
  empty = "",
}

return M
