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
      "<leader>nt",
      function() Snacks.terminal("dotnet test", { win = { style = "terminal" } }) end,
      desc = "Test (CLI)",
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
    {
      "<leader>nw",
      function() Snacks.terminal("dotnet watch run", { win = { style = "terminal" } }) end,
      desc = "Watch run",
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
    { "<leader>nf", group = ".NET File" },
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
            -- Restart to pick up the new solution cleanly
            vim.schedule(function()
              vim.cmd "LspRestart fsautocomplete"
            end)
          end
        end)
      end,
      desc = "Switch solution",
    },
  },
}
