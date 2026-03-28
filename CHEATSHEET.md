# Neovim + Tmux Cheat Sheet

> Leader: `Space` | Local Leader: `,` | Tmux Prefix: `C-a`

---

## Navigation

### Cross-Environment (Neovim + Tmux)

| Key | Description |
|-----|-------------|
| `C-h/j/k/l` | Move between Neovim splits and tmux panes seamlessly |

### In-Buffer Motion

| Key | Mode | Description |
|-----|------|-------------|
| `s` + chars | n, x, o | Flash jump to any match |
| `S` | n, x, o | Flash treesitter selection |
| `r` | o | Remote flash (operator-pending) |
| `R` | o, x | Treesitter search |
| `{` / `}` | n | Prev / next symbol (Aerial) |
| `[y` / `]y` | n | Prev / next symbol |
| `[Y` / `]Y` | n | Prev / next symbol (up level) |

### Between Functions, Classes, Arguments

| Key | Description |
|-----|-------------|
| `]f` / `[f` | Next / prev function start |
| `]F` / `[F` | Next / prev function end |
| `]c` / `[c` | Next / prev class start |
| `]C` / `[C` | Next / prev class end |
| `]a` / `[a` | Next / prev argument |
| `]t` / `[t` | Next / prev TODO comment |
| `]h` / `[h` | Next / prev git hunk |
| `]H` / `[H` | Last / first git hunk |

### File Navigation

| Key | Description |
|-----|-------------|
| `<leader><space>` | Find files (root) |
| `<leader>,` | Open buffers |
| `<leader>ff` | Find files (root) |
| `<leader>fF` | Find files (cwd) |
| `<leader>fg` | Git files |
| `<leader>fr` | Recent files |
| `<leader>fO` | Recent files (cwd) |
| `<leader>fp` | Projects |
| `<leader>fX` | Config files |
| `<leader>fR` | Rename file |

### Harpoon (Pinned Files)

| Key | Description |
|-----|-------------|
| `<leader>ha` | Pin current file |
| `<leader>hh` | Toggle harpoon menu |
| `<leader>hp` / `hn` | Prev / next pinned file |
| `<leader>h1-4` | Jump to pinned file 1-4 |

---

## Editing

### Text Objects (Treesitter)

| Object | Inner | Around | Description |
|--------|-------|--------|-------------|
| Function | `if` | `af` | Function body / full function |
| Class | `ic` | `ac` | Class body / full class |
| Argument | `ia` | `aa` | Single argument / with separator |
| Conditional | `ii` | `ai` | Conditional body / full if-block |
| Loop | `il` | `al` | Loop body / full loop |
| Git hunk | `ih` | -- | Git hunk (gitsigns) |

### Selection & Manipulation

| Key | Mode | Description |
|-----|------|-------------|
| `C-Space` | n | Init / expand treesitter selection |
| `BS` | n | Shrink treesitter selection |
| `<leader>a` | n | Swap argument with next |
| `<leader>A` | n | Swap argument with previous |
| `gc` | n, v | Toggle line comment |
| `gb` | n, v | Toggle block comment |
| `ys`/`ds`/`cs` | n | Add / delete / change surround |

### Folding (nvim-ufo)

| Key | Description |
|-----|-------------|
| `za` | Toggle fold under cursor |
| `zR` | Open all folds |
| `zM` | Close all folds |
| `zK` | Peek inside fold |

### Completion (blink.cmp)

| Key | Mode | Description |
|-----|------|-------------|
| Type | i | Auto-shows completion |
| `C-y` | i | Accept completion |
| `C-S-Space` | i | Manually trigger menu |
| `Tab` | i, s | Expand snippet / jump next |
| `S-Tab` | i, s | Jump to prev snippet field |

### Copilot

| Key | Mode | Description |
|-----|------|-------------|
| `M-l` | i | Accept inline suggestion |
| `M-]` / `M-[` | i | Next / prev suggestion |
| `C-]` | i | Dismiss suggestion |

---

## LSP

| Key | Description |
|-----|-------------|
| `grd` | Go to definition |
| `grr` | References |
| `gri` | Implementations |
| `grt` | Type definition |
| `gO` | Document symbols |
| `K` | Hover documentation |
| `<leader>ls` | Signature help |
| `<leader>lc` | Run CodeLens |
| `<leader>lC` | Toggle CodeLens |
| `<leader>lf` | Format buffer |
| `<leader>lwa` | Add workspace folder |
| `<leader>lwr` | Remove workspace folder |
| `<leader>lwl` | List workspace folders |

---

## Diagnostics

| Key | Description |
|-----|-------------|
| `<leader>xh` | Hover diagnostic float |
| `<leader>xx` | All diagnostics (Trouble) |
| `<leader>xX` | Buffer diagnostics (Trouble) |
| `<leader>xs` | Symbols (Trouble) |
| `<leader>xl` | LSP defs/refs (Trouble) |
| `<leader>xL` | Location list |
| `<leader>xQ` | Quickfix list |
| `<leader>sd` | Diagnostics (picker) |
| `<leader>sD` | Buffer diagnostics (picker) |

---

## Search & Grep

| Key | Description |
|-----|-------------|
| `<leader>/` | Grep (root) |
| `<leader>sg` | Grep (root) |
| `<leader>sG` | Grep (cwd) |
| `<leader>sb` | Buffer lines |
| `<leader>sB` | Grep open buffers |
| `<leader>sw` | Word under cursor (root) |
| `<leader>sW` | Word under cursor (cwd) |
| `<leader>st` | TODOs (Trouble) |
| `<leader>sT` | TODOs (picker) |
| `<leader>sh` | Help pages |
| `<leader>sk` | Keymaps |
| `<leader>sm` | Marks |
| `<leader>sR` | Resume last picker |
| `<leader>su` | Undo tree |
| `<leader>:` | Command history |

---

## Debugging

### General DAP

| Key | Description |
|-----|-------------|
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Conditional breakpoint |
| `<leader>dc` | Continue |
| `<leader>dC` | Run to cursor |
| `<leader>di` | Step into |
| `<leader>do` | Step over |
| `<leader>dO` | Step out |
| `<leader>dp` | Pause |
| `<leader>dt` | Terminate |
| `<leader>dl` | Run last session |
| `<leader>dr` | Toggle REPL |
| `<leader>du` | Toggle DAP UI |
| `<leader>de` | Eval expression (n, v) |

### Python DAP

| Key | Description |
|-----|-------------|
| `<leader>dpt` | Debug test method |
| `<leader>dpc` | Debug test class |
| `<leader>dps` | Debug selection (visual) |

### Adapters

| Language | Adapter | Launch Config |
|----------|---------|---------------|
| Python | debugpy | Auto (pytest) |
| C# / F# / VB | netcoredbg | Prompts for DLL path |
| C / C++ | codelldb | Prompts for executable |
| Rust | codelldb | Defaults to `target/debug/` |

---

## Testing (Neotest)

| Key | Description |
|-----|-------------|
| `<leader>tt` | Run nearest test |
| `<leader>tf` | Run current file |
| `<leader>tT` | Run all tests |
| `<leader>td` | Debug nearest test |
| `<leader>ts` | Stop test |
| `<leader>to` | Show output |
| `<leader>tO` | Toggle output panel |
| `<leader>tS` | Toggle summary |
| `<leader>tw` | Toggle watch |

### Adapters

| Language | Runner |
|----------|--------|
| Python | pytest |
| .NET (C#/F#) | xunit (solution discovery) |
| Rust | cargo test |

---

## REPL (vim-slime to tmux)

> Start your REPL in an adjacent tmux pane (`ipython`, `dotnet fsi`, `utop`).
> Slime sends to the last-active tmux pane by default.

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>rs` | n | Send motion to REPL |
| `<leader>rs` | x | Send selection to REPL |
| `<leader>rl` | n | Send line |
| `<leader>rp` | n | Send paragraph |
| `<leader>rC` | n | Configure target pane |

---

## Git

### Hunk Operations

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>ghs` | n, x | Stage hunk |
| `<leader>ghr` | n, x | Reset hunk |
| `<leader>ghS` | n | Stage buffer |
| `<leader>ghu` | n | Undo stage hunk |
| `<leader>ghR` | n | Reset buffer |
| `<leader>ghp` | n | Preview hunk inline |
| `<leader>ghb` | n | Blame line |
| `<leader>ghB` | n | Blame buffer |
| `<leader>ghd` | n | Diff this |
| `<leader>ghD` | n | Diff this ~ (HEAD~) |

### Git Commands

| Key | Description |
|-----|-------------|
| `<leader>go` | Fugitive status |
| `<leader>gc` | Commit |
| `<leader>gp` | Push |
| `<leader>gf` | Pull |
| `<leader>gl` | Log |
| `<leader>gb` | Blame line |
| `<leader>gB` | Browse on GitHub |
| `<leader>gg` | Lazygit |

### Git Picker

| Key | Description |
|-----|-------------|
| `<leader>gs` | Git status |
| `<leader>gS` | Git stash |
| `<leader>gD` | Diff (hunks) |
| `<leader>gO` | Diff (origin) |
| `<leader>gi` | GitHub issues (open) |
| `<leader>gI` | GitHub issues (all) |
| `<leader>gR` | GitHub PRs |

### Diff

| Key | Description |
|-----|-------------|
| `<leader>gd` | Open DiffView |
| `<leader>gF` | File history |
| `<leader>gH` | Branch history |
| `q` | Close DiffView |

### Worktrees

| Key | Description |
|-----|-------------|
| `<leader>gwl` | List & switch (saves/loads session) |
| `<leader>gwa` | Create worktree |
| `<leader>gwd` | Remove worktree |

---

## Language-Specific

### F# / .NET (`<leader>n`)

| Key | Description |
|-----|-------------|
| `<leader>nb` | `dotnet build` |
| `<leader>nr` | `dotnet run` |
| `<leader>nw` | `dotnet watch run` |
| `<leader>nc` | `dotnet clean` |
| `<leader>nR` | `dotnet restore` |
| `<leader>ni` | F# Interactive (fsi) |
| `<leader>ns` | Switch solution |
| `<leader>np` | Open .fsproj |
| `<leader>nn` | `dotnet new` templates |
| `<leader>nT` | `dotnet test` |
| `<leader>nTv` | `dotnet test --verbose` |

**F# File Ops** (`<leader>nf`): `a` add, `d` delete, `r` rename, `m` move
**Compile Order** (`<leader>no`): `k` up, `j` down, `l` list
**NuGet** (`<leader>nP`): `a` add, `r` remove, `l` list, `o` outdated

### CMake / C++ (`<leader>k`)

| Key | Description |
|-----|-------------|
| `<leader>kg` | Configure (generate) |
| `<leader>kb` | Build |
| `<leader>kr` | Run |
| `<leader>kd` | Debug |
| `<leader>kt` | Test (ctest) |
| `<leader>kc` | Clean |
| `<leader>ks` | Select build target |
| `<leader>kS` | Select launch target |
| `<leader>kp` | Select build type |
| `<leader>kP` | Select build preset |
| `<leader>kq` | Close executor |
| `<leader>ki` | CMake settings |

### Rust

| Feature | How |
|---------|-----|
| Diagnostics | rust-analyzer with clippy on save |
| Test | `<leader>tt` (neotest-rust) |
| Debug | `<leader>dc` (codelldb) |
| Crate info | Open `Cargo.toml` (crates.nvim) |
| Format | Auto on save (rustfmt) |

### Python

| Key | Description |
|-----|-------------|
| `<leader>lv` | Select virtualenv |
| `<leader>dpt` | Debug test method |
| `<leader>dpc` | Debug test class |
| `<leader>dps` | Debug selection |
| `<leader>tt` | Run nearest test (pytest) |

---

## Explorer & File Management

| Key | Description |
|-----|-------------|
| `<leader>ee` | Explorer (float) |
| `<leader>el` | Explorer (sidebar) |
| `<leader>er` | Reveal current file |
| `<leader>eh` | Explorer health |
| `<leader>eb` | Oil (parent dir) |

**In explorer**: `d` delete, `r` rename, `m` move (F#-aware)

---

## Sessions & Projects

| Key | Description |
|-----|-------------|
| `<leader>qs` | Load session (cwd) |
| `<leader>qS` | Select session |
| `<leader>ql` | Load last session |
| `<leader>qd` | Stop auto-save |

---

## Toggle Utilities (`<leader>u`)

| Key | Description |
|-----|-------------|
| `<leader>ul` | Line numbers |
| `<leader>ur` | Relative numbers |
| `<leader>uw` | Line wrap |
| `<leader>us` | Spell check |
| `<leader>ud` | Diagnostics |
| `<leader>ui` | Inlay hints |
| `<leader>un` | Dismiss notifications |
| `<leader>z` | Zen mode |
| `<leader>Z` | Zoom |
| `<leader>.` | Scratch buffer |

---

## Mason & Plugins

| Key | Description |
|-----|-------------|
| `<leader>mo` | Open Mason |
| `<leader>mu` | Update Mason |
| `<leader>mt` | Update Mason tools |
| `<leader>Pc` | Check plugin updates |
| `<leader>Pi` | Install plugins |
| `<leader>Ps` | Plugin status |
| `<leader>Ps` | Sync plugins |
| `<leader>Pu` | Update plugins |

---

## Container (`<leader>vc`)

| Key | Description |
|-----|-------------|
| `<leader>vca` | Attach |
| `<leader>vcb` | Build |
| `<leader>vcr` | Build + run + attach |
| `<leader>vcs` | Start + attach |
| `<leader>vcx` | Stop |
| `<leader>vcl` | Logs |
| `<leader>vce` | Edit devcontainer.json |
| `<leader>vcu` | Compose up |
| `<leader>vcd` | Compose down |

---

## Tmux

### Prefix: `C-a`

| Key | Description |
|-----|-------------|
| `C-a \|` | Split vertical (preserves path) |
| `C-a -` | Split horizontal (preserves path) |
| `C-a h/j/k/l` | Navigate panes |
| `C-a H/J/K/L` | Resize panes (repeatable, +5) |
| `C-a r` | Reload config |
| `C-a I` | Install TPM plugins |

### Copy Mode (vi-style)

| Key | Description |
|-----|-------------|
| `v` | Begin selection |
| `y` | Copy and exit |

### Plugins

| Plugin | Purpose |
|--------|---------|
| tmux-sensible | Sensible defaults |
| tmux-resurrect | Session persistence (restores Neovim sessions) |
| vim-tmux-navigator | Seamless `C-h/j/k/l` with Neovim |

---

## Leader Key Map (at a glance)

```
<Space> +
  a/A     Swap argument next/prev
  ,       Buffers
  /       Grep
  :       Command history
  .       Scratch buffer
  <space> Find files
  c       Claude (disabled)
  d       Debugger
  vc      Container (devcontainer)
  e       Explorer
  f       File / find
  g       Git
  gh      Git hunks
  gw      Git worktrees
  h       Harpoon
  k       CMake
  l       LSP
  m       Mason
  n       .NET / F#
  P       Plugins (lazy)
  r       REPL (slime)
  s       Search / grep
  q       Sessions (quick-resume)
  t       Testing
  u       Toggle utilities
  x       Diagnostics (Trouble)
  z/Z     Zen / Zoom
```
