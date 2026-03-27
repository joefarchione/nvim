local fsproj = require "joe.utils.fsproj"

return {
  {
    "folke/snacks.nvim",
    opts = {
      explorer = {
        auto_close = false,
        enable = true,
      },
      picker = {
        sources = {
          explorer = {
            -- default setting is for floating window. overide below in keys for sidebar
            enable = true,
            auto_close = true,
            hidden = true,
            ignored = true,
            exclude = { "__pycache__", "*.pyc", "*.pyi", "*.pyo" },
            -- Pin the explorer root so DirChanged events (e.g. from project.nvim)
            -- don't change the explorer's scope when opening files in subdirectories
            on_show = function(picker)
              if picker.list and picker.list.win and picker.list.win.augroup then
                pcall(vim.api.nvim_clear_autocmds, {
                  group = picker.list.win.augroup,
                  event = "DirChanged",
                })
              end
            end,
            -- Git integration
            git_status = true,
            git_status_open = false, -- recursive git status freezes large repos
            git_untracked = true,
            -- Diagnostics integration
            diagnostics = true,
            diagnostics_open = false, -- recursive diagnostics slow on expand
            -- Default floating layout for explorer
            layout = {
              preview = true,
              layout = {
                box = "horizontal",
                width = 0.8,
                height = 0.8,
                {
                  box = "vertical",
                  border = "rounded",
                  title = "{source} {live} {flags}",
                  title_pos = "center",
                  { win = "input", height = 1, border = "rounded" },
                  { win = "list", border = "rounded" },
                },
                { win = "preview", border = "rounded", width = 0.7, title = "{preview}" },
              },
            },
            -- fsproj-aware actions for F# file operations
            actions = {
              fsproj_delete = function(picker)
                local Tree = require "snacks.explorer.tree"
                local Actions = require "snacks.explorer.actions"
                local paths = vim.tbl_map(Snacks.picker.util.path, picker:selected { fallback = true })
                if #paths == 0 then return end

                -- Check if any are F# files
                local has_fsharp = false
                for _, path in ipairs(paths) do
                  if fsproj.is_fsharp_file(path) then
                    has_fsharp = true
                    break
                  end
                end

                if not has_fsharp then
                  return Actions.actions.explorer_del(picker)
                end

                local what = #paths == 1 and vim.fn.fnamemodify(paths[1], ":p:~:.") or #paths .. " files"
                Snacks.picker.util.confirm("Delete " .. what .. "?", function()
                  for _, path in ipairs(paths) do
                    fsproj.remove_compile_for_path(path)
                    local ok, err = Actions.trash(path)
                    if ok then
                      Snacks.bufdelete { file = path, force = true }
                    else
                      Snacks.notify.error("Failed to delete `" .. path .. "`:\n" .. err)
                    end
                    Tree:refresh(vim.fs.dirname(path))
                  end
                  picker.list:set_selected()
                  Actions.update(picker)
                end)
              end,

              fsproj_rename = function(picker, item)
                local Tree = require "snacks.explorer.tree"
                local Actions = require "snacks.explorer.actions"
                if not item then return end

                if not fsproj.is_fsharp_file(item.file) then
                  return Actions.actions.explorer_rename(picker, item)
                end

                Snacks.rename.rename_file {
                  from = item.file,
                  on_rename = function(new, old, ok)
                    if ok then
                      fsproj.update_compile_for_path(old, new)
                    end
                    Tree:refresh(vim.fs.dirname(old))
                    Tree:refresh(vim.fs.dirname(new))
                    Actions.update(picker, { target = new })
                  end,
                }
              end,

              fsproj_move = function(picker)
                local Tree = require "snacks.explorer.tree"
                local Actions = require "snacks.explorer.actions"
                local paths = vim.tbl_map(Snacks.picker.util.path, picker:selected())
                if #paths == 0 then
                  -- No selection: fall back to rename
                  return Actions.actions.explorer_rename(picker, picker:current())
                end

                -- Check if any are F# files
                local has_fsharp = false
                for _, path in ipairs(paths) do
                  if fsproj.is_fsharp_file(path) then
                    has_fsharp = true
                    break
                  end
                end

                if not has_fsharp then
                  return Actions.actions.explorer_move(picker)
                end

                local target = picker:dir()
                local what = #paths == 1 and vim.fn.fnamemodify(paths[1], ":p:~:.") or #paths .. " files"
                local t = vim.fn.fnamemodify(target, ":p:~:.")

                Snacks.picker.util.confirm("Move " .. what .. " to " .. t .. "?", function()
                  for _, from in ipairs(paths) do
                    local to = target .. "/" .. vim.fn.fnamemodify(from, ":t")
                    fsproj.update_compile_for_path(from, to)
                    Snacks.rename.rename_file { from = from, to = to }
                    Tree:refresh(vim.fs.dirname(from))
                  end
                  Tree:refresh(target)
                  picker.list:set_selected()
                  Actions.update(picker, { target = target })
                end)
              end,
            },
            win = {
              list = {
                keys = {
                  ["d"] = "fsproj_delete",
                  ["r"] = "fsproj_rename",
                  ["m"] = "fsproj_move",
                },
              },
            },
          },
        },
      },
    },
    keys = {
      {
        "<leader>ee",
        function() Snacks.explorer.open() end,
        desc = "Open (Float)",
      },
      {
        "<leader>el",
        function() Snacks.picker.explorer { layout = "sidebar", auto_close = false } end,
        desc = "Open (Left)",
      },
      { "<leader>eh", function() Snacks.explorer.health() end, desc = "Health" },
      { "<leader>er", function() Snacks.explorer.reveal() end, desc = "Reveal" },
    },
  },
  {
    "stevearc/oil.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      {
        "refractalize/oil-git-status.nvim",
        opts = {},
      },
    },
    keys = {
      { "<leader>eb", "<cmd>Oil --float<cr>", desc = "Oil - open parent directory" },
    },
    opts = {
      default_file_explorer = false,
      view_options = {
        show_hidden = true,
      },
      git = {
        add = true,
        rm = true,
        mv = true,
      },
      win_options = {
        signcolumn = "yes:2",
      },
    },
  },
}
