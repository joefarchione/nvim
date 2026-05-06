-- Shared state for solution selection
local selected_solution = nil

--- Find all solution files (.sln, .slnx, .slnf) under the project root
local function find_solution_files()
  local root = vim.fs.root(0, { ".git", ".sln", ".slnx", ".slnf", ".fsproj" }) or vim.uv.cwd()
  local patterns = { "*.sln", "*.slnx", "*.slnf" }
  local files = {}
  for _, pat in ipairs(patterns) do
    for _, f in ipairs(vim.fn.globpath(root, "**/" .. pat, false, true)) do
      table.insert(files, f)
    end
  end
  return files, root
end

--- Get the currently selected solution (used by neotest-vstest)
local function get_selected_solution()
  return selected_solution
end

-- Expose getter for other modules
_G._fsharp_get_selected_solution = get_selected_solution

--- Helper to get the nearest fsproj for the current buffer
local function current_fsproj()
  local fsproj_util = require "joe.utils.fsproj"
  return fsproj_util.find_fsproj(vim.api.nvim_buf_get_name(0))
end

return {
  "ionide/Ionide-vim",
  ft = "fsharp",
  dependencies = { "neovim/nvim-lspconfig" },
  init = function()
    vim.g.fsharp_lsp_auto_setup = 0
    -- Disable Ionide's built-in LSP backend so it can't pass --attachdebugger
    vim.g["fsharp#backend"] = "disable"
    -- Safety net: if Ionide somehow starts FSAC, use our command
    vim.g["fsharp#fsautocomplete_command"] = { "dotnet", "fsautocomplete", "--background-service-enabled" }
  end,
  keys = {
    { "<leader>n", group = ".NET" },

    -- Build & Run
    {
      "<leader>nb",
      function() Snacks.terminal("dotnet build", { win = { style = "terminal" } }) end,
      desc = "Build",
    },
    {
      "<leader>nr",
      function() Snacks.terminal("dotnet run", { win = { style = "terminal" } }) end,
      desc = "Run",
    },
    {
      "<leader>nw",
      function() Snacks.terminal("dotnet watch run", { win = { style = "terminal" } }) end,
      desc = "Watch run",
    },
    {
      "<leader>nc",
      function() Snacks.terminal("dotnet clean", { win = { style = "terminal" } }) end,
      desc = "Clean",
    },
    {
      "<leader>nR",
      function() Snacks.terminal("dotnet restore", { win = { style = "terminal" } }) end,
      desc = "Restore",
    },
    {
      "<leader>ni",
      function() Snacks.terminal("dotnet fsi", { win = { style = "terminal" } }) end,
      desc = "F# Interactive",
      ft = "fsharp",
    },

    -- Solution
    {
      "<leader>ns",
      function()
        local files, root = find_solution_files()
        if #files == 0 then
          Snacks.notify("No solution files found under " .. root, { level = "warn" })
          return
        end

        Snacks.picker.select(files, { prompt = "Switch solution" }, function(choice)
          if not choice then return end
          selected_solution = choice
          Snacks.notify("Switching to " .. vim.fn.fnamemodify(choice, ":t"))

          -- Update FSAC workspace path and restart
          for _, client in ipairs(vim.lsp.get_clients { name = "fsautocomplete" }) do
            client:notify("workspace/didChangeConfiguration", {
              settings = {
                FSharp = {
                  workspacePath = choice,
                },
              },
            })
            vim.schedule(function()
              vim.cmd "LspRestart fsautocomplete"
            end)
          end
        end)
      end,
      desc = "Switch solution",
    },
    {
      "<leader>np",
      function()
        local root = vim.fs.root(0, function(name) return name:match "%.fsproj$" end) or vim.uv.cwd()
        local projs = vim.fn.globpath(root, "*.fsproj", false, true)
        if #projs == 1 then
          vim.cmd.edit(projs[1])
        elseif #projs > 1 then
          vim.ui.select(projs, { prompt = "Select .fsproj:" }, function(choice)
            if choice then vim.cmd.edit(choice) end
          end)
        else
          Snacks.notify("No .fsproj found", { level = "warn" })
        end
      end,
      desc = "Open .fsproj",
    },

    -- File management (F# specific)
    { "<leader>nf", group = ".NET File" },
    {
      "<leader>nfa",
      function() require("joe.utils.fsproj").create_fs_file() end,
      desc = "Add new F# file",
      ft = "fsharp",
    },
    {
      "<leader>nfd",
      function() require("joe.utils.fsproj").delete_fs_file(vim.api.nvim_buf_get_name(0)) end,
      desc = "Delete F# file",
      ft = "fsharp",
    },
    {
      "<leader>nfr",
      function() require("joe.utils.fsproj").rename_fs_file(vim.api.nvim_buf_get_name(0)) end,
      desc = "Rename F# file",
      ft = "fsharp",
    },
    {
      "<leader>nfm",
      function() require("joe.utils.fsproj").move_fs_file(vim.api.nvim_buf_get_name(0)) end,
      desc = "Move F# file",
      ft = "fsharp",
    },

    -- Compile order (F# file order matters!)
    { "<leader>no", group = "Compile order" },
    {
      "<leader>nok",
      function()
        local fsproj_util = require "joe.utils.fsproj"
        local filepath = vim.api.nvim_buf_get_name(0)
        local fsproj = fsproj_util.find_fsproj(filepath)
        if not fsproj then
          Snacks.notify("No .fsproj found", { level = "warn" })
          return
        end
        local rel = fsproj_util.relative_path(fsproj, filepath)
        if fsproj_util.move_compile(fsproj, rel, "up") then
          Snacks.notify("Moved up in compile order")
        else
          Snacks.notify("Already at top or not found", { level = "warn" })
        end
      end,
      desc = "Move file up",
      ft = "fsharp",
    },
    {
      "<leader>noj",
      function()
        local fsproj_util = require "joe.utils.fsproj"
        local filepath = vim.api.nvim_buf_get_name(0)
        local fsproj = fsproj_util.find_fsproj(filepath)
        if not fsproj then
          Snacks.notify("No .fsproj found", { level = "warn" })
          return
        end
        local rel = fsproj_util.relative_path(fsproj, filepath)
        if fsproj_util.move_compile(fsproj, rel, "down") then
          Snacks.notify("Moved down in compile order")
        else
          Snacks.notify("Already at bottom or not found", { level = "warn" })
        end
      end,
      desc = "Move file down",
      ft = "fsharp",
    },
    {
      "<leader>nol",
      function()
        local fsproj_util = require "joe.utils.fsproj"
        local fsproj = current_fsproj()
        if not fsproj then
          Snacks.notify("No .fsproj found", { level = "warn" })
          return
        end
        local entries = fsproj_util.get_compile_order(fsproj)
        if #entries == 0 then
          Snacks.notify("No compile entries found", { level = "warn" })
          return
        end

        -- Highlight current file in the list
        local current = vim.api.nvim_buf_get_name(0)
        local current_rel = fsproj_util.relative_path(fsproj, current)
        local lines = {}
        for i, entry in ipairs(entries) do
          local marker = entry == current_rel and " <--" or ""
          table.insert(lines, string.format("%2d. %s%s", i, entry:gsub("\\", "/"), marker))
        end
        Snacks.notify(
          "Compile order (" .. vim.fn.fnamemodify(fsproj, ":t") .. "):\n" .. table.concat(lines, "\n"),
          { title = "F# Compile Order" }
        )
      end,
      desc = "List compile order",
      ft = "fsharp",
    },

    -- NuGet package management
    { "<leader>nP", group = "NuGet" },
    {
      "<leader>nPa",
      function()
        Snacks.input({ prompt = "Package name:" }, function(pkg)
          if not pkg or pkg == "" then return end
          Snacks.input({ prompt = "Version (blank for latest):", default = "" }, function(ver)
            local cmd = "dotnet add package " .. pkg
            if ver and ver ~= "" then cmd = cmd .. " --version " .. ver end
            Snacks.terminal(cmd, { win = { style = "terminal" } })
          end)
        end)
      end,
      desc = "Add package",
    },
    {
      "<leader>nPr",
      function()
        Snacks.input({ prompt = "Package to remove:" }, function(pkg)
          if not pkg or pkg == "" then return end
          Snacks.terminal("dotnet remove package " .. pkg, { win = { style = "terminal" } })
        end)
      end,
      desc = "Remove package",
    },
    {
      "<leader>nPl",
      function() Snacks.terminal("dotnet list package", { win = { style = "terminal" } }) end,
      desc = "List packages",
    },
    {
      "<leader>nPo",
      function() Snacks.terminal("dotnet list package --outdated", { win = { style = "terminal" } }) end,
      desc = "List outdated packages",
    },

    -- Scaffolding
    {
      "<leader>nn",
      function()
        -- lang_aware = pass `-lang "F#"`; sln/gitignore are language-neutral.
        local templates = {
          { name = "console", lang_aware = true },
          { name = "classlib", lang_aware = true },
          { name = "web", lang_aware = true },
          { name = "webapi", lang_aware = true },
          { name = "xunit", lang_aware = true },
          { name = "nunit", lang_aware = true },
          { name = "mstest", lang_aware = true },
          { name = "sln", lang_aware = false },
          { name = "gitignore", lang_aware = false },
        }
        local labels = vim.tbl_map(function(t) return t.name end, templates)
        vim.ui.select(labels, { prompt = "dotnet new template:" }, function(choice)
          if not choice then return end
          local template
          for _, t in ipairs(templates) do
            if t.name == choice then template = t end
          end
          vim.ui.input({ prompt = "Project name (blank = current dir): " }, function(name)
            local cmd = "dotnet new " .. template.name
            if template.lang_aware then cmd = cmd .. ' -lang "F#"' end
            if name and name ~= "" then cmd = cmd .. " -n " .. vim.fn.shellescape(name) end
            Snacks.terminal(cmd, { win = { style = "terminal" } })
          end)
        end)
      end,
      desc = "dotnet new from template (F#)",
    },
    {
      "<leader>nN",
      function() Snacks.terminal("dotnet new list", { win = { style = "terminal" } }) end,
      desc = "dotnet new (list templates)",
    },

    -- Test via CLI (complement to neotest)
    {
      "<leader>nT",
      function() Snacks.terminal("dotnet test", { win = { style = "terminal" } }) end,
      desc = "Test (dotnet CLI)",
    },
    {
      "<leader>nTv",
      function() Snacks.terminal("dotnet test --verbosity normal", { win = { style = "terminal" } }) end,
      desc = "Test (verbose)",
    },
  },
}
