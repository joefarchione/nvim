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
  { "<leader>g", group = "Git" },
  { "<leader>gh", group = "Git hunk" },
  { "<leader>gw", group = "Git worktree" },
  { "<leader>h", group = "Harpoon" },
  { "<leader>j", group = "Jupyter" },
  { "<leader>k", group = "CMake" },
  { "<leader>l", group = "Lsp" },
  { "<leader>lw", group = "Lsp Workspace" },
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
  { "<leader>x", group = "Diagnostics" },
}

-- lsp commands
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(args)
    local bufnr = args.buf
    if vim.b[bufnr].lsp_keymaps_set then return end
    vim.b[bufnr].lsp_keymaps_set = true
    vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

    wk.add {
      buffer = bufnr,
      -- Override built-in LSP keymaps to use Snacks picker
      { "grr", function() Snacks.picker.lsp_references() end, desc = "References" },
      { "grd", function() Snacks.picker.lsp_definitions() end, desc = "Definition" },
      { "gri", function() Snacks.picker.lsp_implementations() end, desc = "Implementation" },
      { "grt", function() Snacks.picker.lsp_type_definitions() end, desc = "Type definition" },
      { "gO", function() Snacks.picker.lsp_symbols() end, desc = "Document symbols" },
      -- Additional LSP actions under <leader>l
      { "<leader>lc", vim.lsp.codelens.run, desc = "Run CodeLens" },
      {
        "<leader>lC",
        function()
          local enabled = not vim.g.codelens_enabled
          vim.g.codelens_enabled = enabled
          if enabled then
            vim.lsp.codelens.refresh()
            Snacks.notify("CodeLens enabled")
          else
            vim.lsp.codelens.clear()
            Snacks.notify("CodeLens disabled")
          end
        end,
        desc = "Toggle CodeLens",
      },
      { "<leader>ls", vim.lsp.buf.signature_help, desc = "Signature help" },
      { "<leader>lwa", vim.lsp.buf.add_workspace_folder, desc = "Add workspace folder" },
      { "<leader>lwr", vim.lsp.buf.remove_workspace_folder, desc = "Remove workspace folder" },
      {
        "<leader>lwl",
        function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
        desc = "List workspace folders",
      },
      { "<leader>lf", function() vim.lsp.buf.format { async = true } end, desc = "Format buffer" },
    }

    if vim.bo[bufnr].filetype == "python" then
      wk.add {
        buffer = bufnr,
        { "<leader>lv", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv" },
      }
    end
  end,
})
