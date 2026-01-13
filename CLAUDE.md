# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Neovim configuration using lazy.nvim as the plugin manager. The configuration is organized under the `lua/joe/` namespace with a modular structure separating core config, plugins by category, and utilities.

## Architecture

### Directory Structure

```
init.lua                    # Entry point, requires joe.config
lua/joe/
├── after/                 # After configuration (loaded after plugins)
│   └── lsp/              # LSP server configurations using vim.lsp.config
│       ├── lua_ls.lua    # Lua language server settings
│       ├── pyright.lua   # Python language server settings
│       └── yamlls.lua    # YAML language server settings
├── config/                 # Core configuration
│   ├── init.lua           # Loads options, lazy, keymaps, autocmds in order
│   ├── options.lua        # Neovim options (leader key = space, local leader = comma)
│   ├── lazy.lua           # Plugin manager setup, imports from plugins/*
│   ├── keymaps.lua        # Keybindings using which-key
│   ├── commands.lua       # Custom user commands
│   └── autocmds.lua       # Autocommands and diagnostic config
├── plugins/               # Plugin specifications
│   ├── ai/               # AI tools (claude, copilot, copilotchat)
│   ├── coding/           # Development tools (lsp, formatter, linter, debugger, devcontainer)
│   ├── editor/           # Editor enhancements (explorer, terminal, sessions)
│   └── ui/               # UI plugins (colorscheme, lualine, picker, dashboard, noice)
└── utils/                # Utility functions
```

### Configuration Loading

The config loads in this sequence (lua/joe/config/init.lua):
1. options.lua - Sets vim options and globals
2. lazy.lua - Bootstraps lazy.nvim and imports plugin specs
3. keymaps.lua - Configures which-key keybindings
4. autocmds.lua - Sets up autocommands and diagnostics

### Plugin Organization

Plugins are organized by category using lazy.nvim's import feature:
- Each plugin is a Lua table returned from its file
- Lazy.nvim imports from: `joe/plugins`, `joe/plugins/coding`, `joe/plugins/editor`, `joe/plugins/ui`, `joe/plugins/ai`
- Plugin specs follow lazy.nvim conventions (dependencies, opts, config functions)

## Snacks.nvim - Preferred UI/Utility Framework

**IMPORTANT**: This config uses `folke/snacks.nvim` as the primary utility framework. When adding new functionality, prefer Snacks over raw vim API calls.

### Available Snacks Modules

Use these instead of vim API equivalents:

| Feature | Use This | Instead Of |
|---------|----------|------------|
| Terminal | `Snacks.terminal(cmd, opts)` | `vim.fn.termopen()`, `vim.cmd "terminal"` |
| Notifications | `Snacks.notify()` | `vim.notify()` |
| Input prompts | `Snacks.input` | `vim.ui.input()` |
| File picker | `Snacks.picker` | telescope or custom |
| File explorer | `Snacks.explorer` | neotree or custom |
| Git UI | `Snacks.lazygit` | fugitive or custom |
| Toggles | `Snacks.toggle` | manual toggle functions |
| Rename file | `Snacks.rename.rename_file()` | manual rename |
| Scratch buffer | `Snacks.scratch()` | manual scratch creation |
| Zen mode | `Snacks.zen()` | zen-mode.nvim |

### Snacks Configuration

Snacks modules are configured across multiple files in `lua/joe/plugins/`:
- `ui/qol.lua` - scroll, zen, rename, indent, input, scratch, quickfile, bigfile, toggle
- `ui/picker.lua` - file picker configuration
- `editor/explorer.lua` - file explorer
- `editor/terminal.lua` - terminal settings
- `git/lazygit.lua` - lazygit integration

### Example: Using Snacks.terminal

```lua
-- Good: Use Snacks.terminal
terminal_handler = function(command)
  Snacks.terminal(command, {
    win = { style = "terminal" },
  })
end

-- Avoid: Raw vim API
terminal_handler = function(command)
  vim.cmd "tabnew"
  vim.fn.termopen(command)
  vim.api.nvim_buf_set_option(buf, "filetype", "myterm")  -- deprecated
end
```

## Development Commands

### Formatting

- **Auto-format on save**: Enabled by default via conform.nvim
- **Manual format**: `<leader>lf` (uses conform.nvim)
- **Formatters by filetype**:
  - Lua: `stylua` (config in stylua.toml)
  - Python: `isort` → `black` (runs in sequence)
  - Markdown/JSON/YAML: `prettier`
- **Check formatter status**: `:ConformInfo`

### Linting

- **Auto-lint**: Triggers on `BufWritePost` and `BufEnter`
- **Linters by filetype**:
  - Python: `flake8`
  - Markdown: `markdownlint`, `codespell`
  - JSON: `jsonlint`
  - YAML: `yamllint`
- **Disable linter**: `:DisableLinterByFt` (custom command for current buffer's filetype)

### LSP

- **LSP servers** (managed by Mason):
  - Lua: `lua_ls`
  - Python: `pyright`
  - YAML: `yamlls`
  - Markdown: `marksman`
- **LSP configuration**:
  - Uses Neovim 0.12+ `vim.lsp.enable()` API
  - Individual server settings in `lua/joe/after/lsp/<server>.lua`
  - Mason ensures servers are installed via mason-lspconfig
  - Diagnostics configured in `autocmds.lua` using `vim.diagnostic.config`
- **Mason commands**:
  - `<leader>mo` - Open Mason UI
  - `<leader>mu` - Update Mason
  - `<leader>mt` - Update Mason tools
- **LSP keymaps** (buffer-local, registered with which-key):
  - `gd` - Go to definition
  - `gD` - Go to declaration
  - `gr` - Go to references
  - `gi` - Go to implementation
  - `K` - Hover documentation
  - `<leader>ln` - Rename symbol
  - `<leader>la` - Code action
  - `<leader>lf` - Format buffer
  - `<leader>lD` - Type definition
  - `<leader>ls` - Signature help

### Plugin Management

Use lazy.nvim commands via `<leader>P`:
- `:Lazy` - Open lazy.nvim UI
- `:Lazy sync` - Sync all plugins
- `:Lazy update` - Update plugins

### File Navigation

Snacks picker mappings (`<leader>f`):
- `<leader>ff` - Find files
- `<leader>fg` - Live grep
- `<leader>fb` - List buffers
- `<leader>fh` - Help tags

### Docker/Devcontainer

Devcontainer commands (`<leader>Dc`):
- `<leader>Dca` - Attach to container
- `<leader>Dcb` - Build container
- `<leader>Dcr` - Build, run & attach
- `<leader>Dcs` - Start & attach
- `<leader>Dcx` - Stop container
- `<leader>Dcl` - View logs
- `<leader>Dce` - Edit devcontainer.json
- `<leader>Dcu` - Docker compose up
- `<leader>Dcd` - Docker compose down

## Key Configuration Details

### Leader Keys
- **Leader**: `space` (mapleader)
- **Local leader**: `,` (maplocalleader)

### Code Style
- **Indentation**: 2 spaces (not tabs)
- **Line length**: 120 characters (per stylua.toml)
- **Lua style**:
  - Quote style: auto-prefer double quotes
  - Call parentheses: none (e.g., `require "module"` not `require("module")`)
  - Simple statements: always collapsed to one line

### Python Setup
- LSP: pyright for type checking and language support
- Formatting: isort for imports, black for code
- Linting: flake8
- Debugging: DAP support configured (lua/joe/plugins/coding/debugger.lua)

### Markdown Setup
- LSP: marksman for navigation and completion
- Formatting: prettier
- Linting: markdownlint, codespell

## Adding New Plugins

1. Create a new file in the appropriate category under `lua/joe/plugins/`
2. Return a table (or array of tables) with lazy.nvim plugin spec
3. Lazy.nvim will automatically load it (imports are configured in lua/joe/config/lazy.lua)
4. Run `:Lazy sync` or use `<leader>pS`

Example structure:
```lua
return {
  "author/plugin-name",
  dependencies = { "other/plugin" },
  event = "VeryLazy",
  opts = {
    -- options
  },
  config = function(_, opts)
    require("plugin-name").setup(opts)
  end,
}
```

## Configuring LSP Servers

LSP configuration uses Neovim 0.12's native `vim.lsp.enable()` API with per-server settings:

1. Add the server to ensure_installed in `lua/joe/plugins/coding/lsp.lua`
2. Add the server to `vim.lsp.enable {}` in the same file
3. Create a config file at `lua/joe/after/lsp/<server_name>.lua`
4. Return a table with server settings

Example structure for `lua/joe/after/lsp/myserver.lua`:
```lua
return {
  settings = {
    myserver = {
      -- Server-specific settings
    },
  },
}
```

The `after/lsp/` directory is automatically loaded after plugins, and settings are applied when the LSP server starts.

## Modifying Keybindings

All keybindings are defined in `lua/joe/config/keymaps.lua` using which-key. To add new mappings:
1. Edit lua/joe/config/keymaps.lua
2. Add entries to the `wk.add` table
3. Follow the pattern: `{ "key", action, desc = "description" }`
4. Group related commands: `{ "key", group = "Group Name" }`

For buffer-local LSP keymaps, add them inside the `LspAttach` autocmd callback using:
```lua
wk.add {
  buffer = bufnr,
  { "key", action, desc = "description" },
}
```

## Deprecated APIs to Avoid

Use modern alternatives:
- `vim.api.nvim_buf_set_option()` → `vim.bo[buf].option`
- `vim.api.nvim_win_set_option()` → `vim.wo[win].option`
- `vim.fn.termopen()` → `Snacks.terminal()`
- `vim.notify()` → `Snacks.notify()` (when available)
- `vim.ui.input()` → `Snacks.input` (when available)
