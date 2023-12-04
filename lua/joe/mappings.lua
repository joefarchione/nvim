local highlight_group = vim.api.nvim_create_augroup('yankhighlight', { clear = true })
vim.api.nvim_create_autocmd('textyankpost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

local file_worktree = function(file, worktrees)
  worktrees = worktrees or vim.g.git_worktrees
  if not worktrees then return end
  file = file or vim.fn.expand "%"
  for _, worktree in ipairs(worktrees) do
    if
        require("astronvim.utils").cmd({
          "git",
          "--work-tree",
          worktree.toplevel,
          "--git-dir",
          worktree.gitdir,
          "ls-files",
          "--error-unmatch",
          file,
        }, false)
    then
      return worktree
    end
  end
end

local wk            = require("which-key")
local builtin       = require('telescope.builtin')
local Terminal      = require('toggleterm.terminal').Terminal
local lazygit       = Terminal:new({ direction = "float", cmd = "lazygit", hidden = true })
local opts          = { noremap = true, silent = true }
local map           = vim.keymap.set

function _LAZYGIT_TOGGLE()
  lazygit:toggle()
end

function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

-- standard operations
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  callback = function(ev)
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
  end,
})

map('n', '<C-x>', '<cmd>lua require("mini.bufremove").delete()<cr>', opts)
map('n', '<C-Left>', "<cmd>lua require('mini.bracketed').buffer('backward')<cr>", opts)
map('n', '<C-Right>', "<cmd>lua require('mini.bracketed').buffer('forward')<cr>", opts)
map('v', '/', '<Plug>(comment_toggle_linewise_visual)', opts)
map('n', '+', '<C-a>', opts)
map('n', '-', '<C-x>', opts)
map('n', 'ss', ':split<cr>', opts)
map('n', 'sv', ':vsplit<cr>', opts)
map('n', '<F7>', ':Inspect<cr>', opts)
map('n', '<F8>', ':InspectTree<cr>', opts)
map('n', "<C-h>", function() require("smart-splits").move_cursor_left() end, opts)
map('n', "<C-j>", function() require("smart-splits").move_cursor_down() end, opts)
map('n', "<C-k>", function() require("smart-splits").move_cursor_up() end, opts)
map('n', "<C-l>", function() require("smart-splits").move_cursor_right() end, opts)
map('n', "<C-Up>", function() require("smart-splits").resize_up() end, opts)
map('n', "<C-Down>", function() require("smart-splits").resize_down() end, opts)
map('n', "<C-Left>", function() require("smart-splits").resize_left() end, opts)
map('n', "<C-Right>", function() require("smart-splits").resize_right() end, opts)

wk.register({
  ["<leader>"] = {
    b = {
      "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>",
      "Buffers",
    },
    d = {
      name = "diagnostics",
      p = { vim.diagnostic.goto_prev, 'go to previous diagnostic message' },
      n = { vim.diagnostic.goto_next, 'go to next diagnostic message' },
      e = { vim.diagnostic.open_float, 'open floating diagnostic message' },
      q = { vim.diagnostic.setloclist, 'open diagnostics list' },
    },
    D = {
      name = "dbui",
      t = { "<cmd>DBUIToggle<cr>", "Toggle UI" },
      f = { "<cmd>DBUIFindBuffer<cr>", "Find Buffer" },
      r = { "<cmd>DBUIRenameBuffer<cr>", "Rename Buffer" },
      q = { "<cmd>DBUILastQueryInfo<cr>", "Last Query Info" },
    },
    e = {
      f = { "<cmd>Neotree toggle position=float reveal=true<cr>", "Float" },
      name = "Explorer"
    },
    f = {
      name = "telescope",
      g = { function() builtin.git_files() end, 'find git files' },
      ["<CR>"] = { function() builtin.resume() end, "Resume previous search" },
      ["'"] = { function() builtin.marks() end, "Find marks" },
      ["/"] = { function() builtin.current_buffer_fuzzy_find() end, "Find words in current buffer" },
      b = { function() builtin.buffers() end, "Find buffers" },
      c = { function() builtin.grep_string() end, "Find word under cursor" },
      C = { function() builtin.commands() end, "Find commands" },
      f = { function() builtin.find_files() end, "Find files" },
      F = {
        function() builtin.find_files { hidden = true, no_ignore = true } end,
        "Find all files",
      },
      h = { function() builtin.help_tags() end, "Find help" },
      k = { function() builtin.keymaps() end, "Find keymaps" },
      m = { function() builtin.man_pages() end, "Find man" },
      o = { function() builtin.oldfiles() end, "Find history" },
      p = { '<cmd>Telescope projects<cr>', 'Search Projects' },
      r = { function() builtin.registers() end, "Find registers" },
      t = { function() builtin.colorscheme { enable_preview = true } end, "Find themes" },
      w = { function() builtin.live_grep() end, "Find words" },
      W = {
        function()
          builtin.live_grep {
            additional_args = function(args) return vim.list_extend(args, { "--hidden", "--no-ignore" }) end,
          }
        end,
        "Find words in all files"
      },
      X = {
        function()
          local cwd = vim.fn.stdpath "config" .. "/.."
          require("telescope.builtin").find_files {
            prompt_title = "Config Files",
            search_dirs = { "~/.config/nvim" },
            cwd = cwd,
            follow = true,
          } -- call telescope
        end,
        "Search config"
      },
    },
    g = {
      name = "git",
      g = { "<cmd> lua _LAZYGIT_TOGGLE()<cr>", "Toggle lazygit" },
      j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
      k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
      l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
      p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
      r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
      R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
      s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
      u = {
        "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
        "Undo Stage Hunk",
      },
      o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
      b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
      c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
      d = {
        "<cmd>Gitsigns diffthis HEAD<cr>",
        "Diff",
      },
    },
    l = {
      name = "LSP",
      a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
      d = {
        "<cmd>Telescope diagnostics bufnr=0<cr>",
        "Document Diagnostics",
      },
      w = {
        "<cmd>Telescope diagnostics<cr>",
        "Workspace Diagnostics",
      },
      f = { "<cmd>lua vim.lsp.buf.format{async=true}<cr>", "Format" },
      i = { "<cmd>LspInfo<cr>", "Info" },
      I = { "<cmd>LspInstallInfo<cr>", "Installer Info" },
      j = {
        "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>",
        "Next Diagnostic",
      },
      k = {
        "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>",
        "Prev Diagnostic",
      },
      l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
      q = { "<cmd>lua vim.diagnostic.setloclist()<cr>", "Quickfix" },
      r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
      s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
      S = {
        "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
        "Workspace Symbols",
      }
    },
    M = {
      name = "Mason",
      m = { '<cmd>Mason<cr>', 'Open Mason' },
      u = { '<cmd>MasonUpdate<cr>', 'Update Mason' },
      t = { '<cmd>MasonToolsUpdate<cr>', 'Update Mason Tools' },
      a = { '<cmd>MasonUninstallAll<cr>', 'Uninstall all packages' },
    },
    p = {
      name = "Plugins",
      i = { function() require("lazy").install() end, "Plugins Install" },
      s = { function() require("lazy").home() end, "Plugins Status" },
      S = { function() require("lazy").sync() end, "Plugins Sync" },
      u = { function() require("lazy").check() end, "Plugins Check Updates" },
      U = { function() require("lazy").update() end, "Plugins Update" },
    },
    ['/'] = {
      function() require("Comment.api").toggle.linewise.count(vim.v.count > 0 and vim.v.count or 1) end,
      'Comment toggle current line' },
    r = {
      name = "REPL",
      s = { function() require('nvim-python-repl').send_statement_definition() end, "Send semantic unit to REPL" },
      v = { function() require('nvim-python-repl').send_visual_to_repl() end, "Send visual selection to REPL" },
      b = { function() require('nvim-python-repl').send_buffer_to_repl() end, "Send entire buffer to REPL" },
      e = { function() require('nvim-python-repl').toggle_execute() end,
        "Automatically execute command in REPL after sent" },
      w = { function() require('nvim-python-repl').toggle_vertical() end, "Create REPL in vertical or horizontal split" },
    },
    t = {
      name = "Terminal",
      f = { "<cmd>ToggleTerm direction=float<cr>", "ToggleTerm float" },
      t = { "<cmd>ToggleTerm size=15 direction=horizontal<cr>", "ToggleTerm horizontal split" },
      v = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", "ToggleTerm vertical split" },
      ["<F7>"] = { "<cmd>ToggleTerm<cr>", "Toggle terminal" },
      g = { "<cmd> lua _LAZYGIT_TOGGLE()<cr>", "Toggle lazygit" },
      p = { "<cmd>ToggleTerm  cmd='ipython --no-autoindent' direction=horizontal<cr>", "ipython" },
      s = {
        function()
          local mode = vim.api.nvim_get_mode()
          if mode["mode"] == "n" then
            vim.cmd [[ToggleTermSendCurrentLine]]
          elseif mode["mode"] == "v" or mode["mode"] == "V" then
            vim.cmd [[ToggleTermSendVisualSelection]]
          end
        end, "Send"
      }
    },
    w = { '<cmd>update<cr>', 'Save' },
  },
  S = {
    name = "Sessions",
    s = { function() require('resession').save() end, "save" },
    l = { function() require('resession').load() end, "load" },
    d = { function() require('resession').delete() end, "delete" }
  },
})


-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }


    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>la', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>lf', function()
      vim.lsp.buf.format { async = true }
    end, opts)
    vim.keymap.set('n', 'lo', function() require("aerial").toggle() end, opts)
  end,
})
