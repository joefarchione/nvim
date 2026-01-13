local wk = require "which-key"
local yank = require "joe.utils.yank"

--- terminal
vim.keymap.set("t", "<Esc><Esc>", "<cmd><C-\\><C-n><cr>", { noremap = true, silent = true })
vim.keymap.set("t", "<leader><Esc>", "<cmd><C-\\><C-n><cr><cmd><C-w>c<cr>", { noremap = true, silent = true })

-- QOL yank methods for pasting things into AI agents
-- yank absolute path and line number & text
vim.keymap.set(
  "v",
  "<leader>ya",
  function() yank.yank_visual_with_path(yank.get_buffer_absolute(), "absolute") end,
  { noremap = true, silent = true }
)

-- yank relative path to file
vim.keymap.set(
  "v",
  "<leader>yr",
  function() yank.yank_visual_with_path(yank.get_buffer_cwd_relative(), "relative") end,
  { noremap = true, silent = true }
)

local lazy = require "lazy"

wk.add {
  { "<leader>d", group = "Debugger" },
  { "<leader>Dc", group = "Devcontainer" },
  { "<leader>e", group = "Explorer" },
  { "<leader>f", group = "File" },
  { "<leader>h", group = "Harpoon" },
  { "<leader>l", group = "Lsp" },
  { "<leader>lw", group = "Lsp Workspace" },
  { "<leader>G", group = "Git" },
  { "<leader>Gh", group = "Git hunk" },
  { "<leader>j", group = "Jupyter" },
  { "<leader>m", group = "Mason" },
  { "<leader>P", group = "Plugins" },
  { "<leader>Pc", function() lazy.check() end, desc = "Check updates" },
  { "<leader>Pi", function() lazy.install() end, desc = "Install" },
  { "<leader>Ps", function() lazy.home() end, desc = "Status" },
  { "<leader>PS", function() lazy.sync() end, desc = "Sync" },
  { "<leader>Pu", function() lazy.update() end, desc = "Update" },
  { "<leader>r", group = "REPL" },
  { "<leader>s", group = "Grep" },
  { "<leader>S", group = "Sessions" },
  { "<leader>t", group = "Testing" },
  { "<leader>u", group = "Toggle Utils" },
  { "<leader>v", group = "VirtualEnv" },
  { "<leader>x", group = "Diagnostics" },
}

-- lsp commands
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(args)
    local bufnr = args.buf
    vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

    wk.add {
      buffer = bufnr,
      { "gD", vim.lsp.buf.declaration, desc = "Go to declaration" },
      { "gd", vim.lsp.buf.definition, desc = "Go to definition" },
      { "K", vim.lsp.buf.hover, desc = "Hover documentation" },
      { "gi", vim.lsp.buf.implementation, desc = "Go to implementation" },
      { "gr", vim.lsp.buf.references, desc = "Go to references" },
      { "<leader>ls", vim.lsp.buf.signature_help, desc = "Signature help" },
      { "<leader>lwa", vim.lsp.buf.add_workspace_folder, desc = "Add workspace folder" },
      { "<leader>lwr", vim.lsp.buf.remove_workspace_folder, desc = "Remove workspace folder" },
      {
        "<leader>lwl",
        function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
        desc = "List workspace folders",
      },
      { "<leader>lD", vim.lsp.buf.type_definition, desc = "Type definition" },
      { "<leader>ln", vim.lsp.buf.rename, desc = "Rename symbol" },
      { "<leader>la", vim.lsp.buf.code_action, desc = "Code action", mode = { "n", "v" } },
      { "<leader>lf", function() vim.lsp.buf.format { async = true } end, desc = "Format buffer" },
    }
  end,
})
