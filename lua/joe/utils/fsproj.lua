local M = {}

--- Check if a file path has an F# extension
---@param path string
---@return boolean
function M.is_fsharp_file(path)
  local ext = vim.fn.fnamemodify(path, ":e"):lower()
  return ext == "fs" or ext == "fsx"
end

--- Walk upward from filepath to find the nearest .fsproj
---@param filepath string
---@return string|nil fsproj absolute path to .fsproj, or nil
function M.find_fsproj(filepath)
  local result = vim.fs.find(function(name)
    return name:match "%.fsproj$"
  end, {
    path = vim.fs.dirname(filepath),
    upward = true,
    type = "file",
    limit = 1,
  })
  return result and result[1] or nil
end

--- Compute relative path from fsproj directory, normalized to backslashes (MSBuild convention)
---@param fsproj string absolute path to .fsproj
---@param filepath string absolute path to the .fs file
---@return string relative path with backslashes
function M.relative_path(fsproj, filepath)
  local proj_dir = vim.fs.dirname(fsproj)
  -- Normalize both to forward slashes for comparison
  proj_dir = proj_dir:gsub("\\", "/"):gsub("/$", "")
  filepath = filepath:gsub("\\", "/")
  local rel = filepath
  if filepath:sub(1, #proj_dir) == proj_dir then
    rel = filepath:sub(#proj_dir + 2) -- skip the trailing slash
  end
  -- Convert to backslashes for MSBuild
  return rel:gsub("/", "\\")
end

--- Read fsproj file content
---@param fsproj string
---@return string|nil content
local function read_fsproj(fsproj)
  local f = io.open(fsproj, "r")
  if not f then return nil end
  local content = f:read "*a"
  f:close()
  return content
end

--- Write fsproj file content
---@param fsproj string
---@param content string
---@return boolean ok
local function write_fsproj(fsproj, content)
  local f = io.open(fsproj, "w")
  if not f then return false end
  f:write(content)
  f:close()
  return true
end

--- Escape a string for use in a Lua pattern
---@param s string
---@return string
local function pattern_escape(s)
  return s:gsub("([%(%)%.%%%+%-%*%?%[%]%^%$])", "%%%1")
end

--- Remove a <Compile Include="rel_path" /> entry from fsproj
---@param fsproj string path to .fsproj
---@param rel_path string relative path (backslash-separated)
---@return boolean ok
function M.remove_compile(fsproj, rel_path)
  local content = read_fsproj(fsproj)
  if not content then return false end

  local escaped = pattern_escape(rel_path)
  -- Match self-closing: <Compile Include="path" />
  local pattern1 = "%s*<Compile%s+Include=\"" .. escaped .. "\"%s*/>\r?\n?"
  -- Match with closing tag: <Compile Include="path"></Compile>
  local pattern2 = "%s*<Compile%s+Include=\"" .. escaped .. "\"%s*>%s*</Compile>\r?\n?"

  local new_content = content:gsub(pattern1, "")
  new_content = new_content:gsub(pattern2, "")

  if new_content == content then
    return false -- nothing was removed
  end

  return write_fsproj(fsproj, new_content)
end

--- Update a <Compile Include="old_rel" /> to use new_rel in fsproj
---@param fsproj string path to .fsproj
---@param old_rel string old relative path
---@param new_rel string new relative path
---@return boolean ok
function M.update_compile(fsproj, old_rel, new_rel)
  local content = read_fsproj(fsproj)
  if not content then return false end

  local escaped_old = pattern_escape(old_rel)
  -- Replace in self-closing tag
  local new_content = content:gsub(
    "(<Compile%s+Include=\")" .. escaped_old .. "(\"%s*/>)",
    "%1" .. new_rel .. "%2"
  )
  -- Replace in open/close tag
  new_content = new_content:gsub(
    "(<Compile%s+Include=\")" .. escaped_old .. "(\"%s*>)",
    "%1" .. new_rel .. "%2"
  )

  if new_content == content then
    return false
  end

  return write_fsproj(fsproj, new_content)
end

--- Delete an F# file: remove compile entry, delete from disk, close buffer
---@param filepath string absolute path to the .fs file
function M.delete_fs_file(filepath)
  filepath = vim.fn.fnamemodify(filepath, ":p")

  if not M.is_fsharp_file(filepath) then
    Snacks.notify("Not an F# file", { level = "warn" })
    return
  end

  local fsproj = M.find_fsproj(filepath)
  if not fsproj then
    Snacks.notify("No .fsproj found", { level = "warn" })
    return
  end

  local display = vim.fn.fnamemodify(filepath, ":t")
  vim.ui.select({ "Yes", "No" }, { prompt = "Delete " .. display .. "?" }, function(choice)
    if choice ~= "Yes" then return end

    local rel = M.relative_path(fsproj, filepath)
    local removed = M.remove_compile(fsproj, rel)

    -- Delete the file from disk
    local ok = vim.fn.delete(filepath) == 0
    if not ok then
      Snacks.notify("Failed to delete " .. display, { level = "error" })
      return
    end

    -- Close buffer if open
    local bufnr = vim.fn.bufnr(filepath)
    if bufnr ~= -1 then
      Snacks.bufdelete { buf = bufnr, force = true }
    end

    local msg = "Deleted " .. display
    if removed then
      msg = msg .. " (fsproj updated)"
    else
      msg = msg .. " (no fsproj entry found)"
    end
    Snacks.notify(msg)
  end)
end

--- Rename an F# file: update compile entry, delegate rename to Snacks.rename
---@param from string absolute path
function M.rename_fs_file(from)
  from = vim.fn.fnamemodify(from, ":p")

  if not M.is_fsharp_file(from) then
    Snacks.notify("Not an F# file", { level = "warn" })
    return
  end

  local fsproj = M.find_fsproj(from)
  if not fsproj then
    Snacks.notify("No .fsproj found – renaming without fsproj update", { level = "warn" })
    Snacks.rename.rename_file { from = from }
    return
  end

  Snacks.rename.rename_file {
    from = from,
    on_rename = function(to, old, ok)
      if not ok then return end
      local old_rel = M.relative_path(fsproj, old)
      -- The new file might be in a different fsproj's scope
      local new_fsproj = M.find_fsproj(to) or fsproj
      local new_rel = M.relative_path(new_fsproj, to)

      if new_fsproj == fsproj then
        M.update_compile(fsproj, old_rel, new_rel)
      else
        M.remove_compile(fsproj, old_rel)
        -- For cross-project moves, notify but don't auto-add
        Snacks.notify("Moved to different project – add Compile entry manually in\n" .. vim.fn.fnamemodify(new_fsproj, ":t"), { level = "warn" })
        return
      end

      Snacks.notify("Renamed: fsproj updated\n" .. old_rel .. " → " .. new_rel)
    end,
  }
end

--- Move an F# file: prompt for destination, update compile entry
---@param from string absolute path
function M.move_fs_file(from)
  from = vim.fn.fnamemodify(from, ":p")

  if not M.is_fsharp_file(from) then
    Snacks.notify("Not an F# file", { level = "warn" })
    return
  end

  local fsproj = M.find_fsproj(from)
  if not fsproj then
    Snacks.notify("No .fsproj found – moving without fsproj update", { level = "warn" })
  end

  local root = vim.fs.dirname(fsproj or from)
  local default = from:gsub("\\", "/"):sub(#root:gsub("\\", "/") + 2)

  Snacks.input({ prompt = "Move to (relative to project root):", default = default }, function(value)
    if not value or value == "" or value == default then return end

    local to = root:gsub("\\", "/") .. "/" .. value
    to = vim.fn.fnamemodify(to, ":p")

    if fsproj then
      local old_rel = M.relative_path(fsproj, from)
      local new_fsproj = M.find_fsproj(vim.fs.dirname(to)) or fsproj
      local new_rel = M.relative_path(new_fsproj, to)

      Snacks.rename.rename_file {
        from = from,
        to = to,
        on_rename = function(_, _, ok)
          if not ok then return end

          if new_fsproj == fsproj then
            M.update_compile(fsproj, old_rel, new_rel)
          else
            M.remove_compile(fsproj, old_rel)
            Snacks.notify(
              "Moved to different project – add Compile entry manually in\n" .. vim.fn.fnamemodify(new_fsproj, ":t"),
              { level = "warn" }
            )
            return
          end

          Snacks.notify("Moved: fsproj updated\n" .. old_rel .. " → " .. new_rel)
        end,
      }
    else
      Snacks.rename.rename_file { from = from, to = to }
    end
  end)
end

--- Add a <Compile Include="rel_path" /> entry to fsproj.
--- If `after_rel` is given and present, inserts immediately after that entry.
--- Otherwise inserts after the last existing <Compile>, or before </ItemGroup>.
---@param fsproj string path to .fsproj
---@param rel_path string relative path (backslash-separated)
---@param after_rel string|nil insert directly after this entry if present
---@return boolean ok
function M.add_compile(fsproj, rel_path, after_rel)
  local content = read_fsproj(fsproj)
  if not content then return false end

  local escaped = pattern_escape(rel_path)
  if content:match("<Compile%s+Include=\"" .. escaped .. "\"") then
    return true -- already present
  end

  local new_entry = '    <Compile Include="' .. rel_path .. '" />\n'

  -- 1. Try to insert right after `after_rel` if it exists in the file.
  if after_rel and after_rel ~= "" then
    local escaped_after = pattern_escape(after_rel)
    local s, e = content:find("<Compile%s+Include=\"" .. escaped_after .. "\"%s*/>")
    if not s then
      s, e = content:find("<Compile%s+Include=\"" .. escaped_after .. "\"%s*>%s*</Compile>")
    end
    if s then
      local eol = content:find("\n", e) or #content
      return write_fsproj(fsproj, content:sub(1, eol) .. new_entry .. content:sub(eol + 1))
    end
  end

  -- 2. Fall back to inserting after the last <Compile> entry.
  local last_compile_pos = nil
  local search_start = 1
  while true do
    local s, e = content:find("<Compile%s+Include=\"[^\"]*\"%s*/>", search_start)
    if not s then
      s, e = content:find("<Compile%s+Include=\"[^\"]*\"%s*>%s*</Compile>", search_start)
    end
    if not s then break end
    last_compile_pos = e
    search_start = e + 1
  end

  local new_content
  if last_compile_pos then
    local eol = content:find("\n", last_compile_pos)
    if eol then
      new_content = content:sub(1, eol) .. new_entry .. content:sub(eol + 1)
    else
      new_content = content .. "\n" .. new_entry
    end
  else
    -- 3. No compile entries yet; insert before first </ItemGroup> or </Project>.
    local insert_point = content:find "</ItemGroup>" or content:find "</Project>"
    if insert_point then
      new_content = content:sub(1, insert_point - 1) .. new_entry .. content:sub(insert_point)
    else
      return false
    end
  end

  return write_fsproj(fsproj, new_content)
end

--- Get all <Compile Include="..."> entries in order from fsproj
---@param fsproj string path to .fsproj
---@return string[] entries list of relative paths
function M.get_compile_order(fsproj)
  local content = read_fsproj(fsproj)
  if not content then return {} end

  local entries = {}
  for path in content:gmatch '<Compile%s+Include="([^"]*)"' do
    table.insert(entries, path)
  end
  return entries
end

--- Swap two adjacent <Compile> entries in fsproj
---@param fsproj string path to .fsproj
---@param rel_path string relative path of the entry to move
---@param direction "up"|"down"
---@return boolean ok
function M.move_compile(fsproj, rel_path, direction)
  local content = read_fsproj(fsproj)
  if not content then return false end

  -- Collect all compile lines with their positions
  local entries = {}
  for line in content:gmatch "[^\n]*" do
    local include = line:match '<Compile%s+Include="([^"]*)"'
    if include then
      table.insert(entries, { path = include, line = line })
    end
  end

  -- Find our entry
  local idx
  for i, e in ipairs(entries) do
    if e.path == rel_path then
      idx = i
      break
    end
  end

  if not idx then return false end

  local swap_idx = direction == "up" and idx - 1 or idx + 1
  if swap_idx < 1 or swap_idx > #entries then return false end

  -- Swap the two lines in content
  local line_a = entries[idx].line
  local line_b = entries[swap_idx].line
  local escaped_a = pattern_escape(line_a)
  local escaped_b = pattern_escape(line_b)

  -- Use a placeholder to avoid double-replacement
  local placeholder = "<!--__FSPROJ_SWAP_PLACEHOLDER__-->"
  local new_content = content:gsub(escaped_a, placeholder, 1)
  new_content = new_content:gsub(escaped_b, line_a, 1)
  new_content = new_content:gsub(pattern_escape(placeholder), line_b, 1)

  if new_content == content then return false end
  return write_fsproj(fsproj, new_content)
end

--- Create a new F# file, add it to fsproj, and open it
---@param fsproj_path string|nil optional fsproj path (auto-detected from cwd if nil)
function M.create_fs_file(fsproj_path)
  local fsproj = fsproj_path
  if not fsproj then
    fsproj = M.find_fsproj(vim.api.nvim_buf_get_name(0))
    if not fsproj then
      -- Try from cwd
      local cwd = vim.uv.cwd()
      local projs = vim.fn.globpath(cwd, "**/*.fsproj", false, true)
      if #projs == 1 then
        fsproj = projs[1]
      elseif #projs > 1 then
        vim.ui.select(projs, { prompt = "Select .fsproj:" }, function(choice)
          if choice then M.create_fs_file(choice) end
        end)
        return
      else
        Snacks.notify("No .fsproj found", { level = "warn" })
        return
      end
    end
  end

  local proj_dir = vim.fs.dirname(fsproj)

  -- Prefill the prompt with the current buffer's directory (relative to project)
  -- so new files default next to the file you're editing.
  local current = vim.api.nvim_buf_get_name(0)
  local default = ""
  local current_rel = nil
  if current ~= "" and M.is_fsharp_file(current) and M.find_fsproj(current) == fsproj then
    local rel = M.relative_path(fsproj, current):gsub("\\", "/")
    local dir = vim.fs.dirname(rel)
    if dir and dir ~= "" and dir ~= "." then
      default = dir .. "/"
    end
    current_rel = M.relative_path(fsproj, current)
  end

  Snacks.input({ prompt = "New F# file (relative to project):", default = default }, function(value)
    if not value or value == "" or value == default then return end

    if not value:match "%.fsx?$" then
      value = value .. ".fs"
    end

    local filepath = proj_dir .. "/" .. value
    filepath = vim.fn.fnamemodify(filepath, ":p")

    local dir = vim.fs.dirname(filepath)
    vim.fn.mkdir(dir, "p")

    local module_name = vim.fn.fnamemodify(filepath, ":t:r")
    local f = io.open(filepath, "w")
    if not f then
      Snacks.notify("Failed to create " .. filepath, { level = "error" })
      return
    end
    f:write("module " .. module_name .. "\n")
    f:close()

    -- Insert the compile entry immediately after the current file (if any),
    -- so new files land next to their dependency rather than at the bottom.
    local rel = M.relative_path(fsproj, filepath)
    M.add_compile(fsproj, rel, current_rel)

    vim.cmd.edit(filepath)
    Snacks.notify("Created " .. value .. " (fsproj updated)")
  end)
end

--- Remove compile entry for a path (used by explorer integration)
--- Returns true if an entry was removed
---@param filepath string
---@return boolean removed
function M.remove_compile_for_path(filepath)
  if not M.is_fsharp_file(filepath) then return false end
  local fsproj = M.find_fsproj(filepath)
  if not fsproj then return false end
  local rel = M.relative_path(fsproj, filepath)
  return M.remove_compile(fsproj, rel)
end

--- Update compile entry for a rename/move (used by explorer integration)
--- Returns true if an entry was updated
---@param old_path string
---@param new_path string
---@return boolean updated
function M.update_compile_for_path(old_path, new_path)
  if not M.is_fsharp_file(old_path) then return false end
  local fsproj = M.find_fsproj(old_path)
  if not fsproj then return false end
  local old_rel = M.relative_path(fsproj, old_path)
  local new_fsproj = M.find_fsproj(new_path) or fsproj
  local new_rel = M.relative_path(new_fsproj, new_path)

  if new_fsproj == fsproj then
    return M.update_compile(fsproj, old_rel, new_rel)
  else
    M.remove_compile(fsproj, old_rel)
    Snacks.notify(
      "Moved to different project – add Compile entry manually in\n" .. vim.fn.fnamemodify(new_fsproj, ":t"),
      { level = "warn" }
    )
    return true
  end
end

return M
