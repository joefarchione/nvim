local M = {}

local neorg = require "neorg.core"


M.get_current_workspace = function()
  local dirman = neorg.modules.get_module "core.dirman"
  if dirman then
    ---@diagnostic disable-next-line: undefined-field
    local current_workspace = dirman.get_current_workspace()[2]:tostring()
    return current_workspace
  end
  return nil
end

M.get_project_root_directory = function()
  return vim.fn.finddir(".git", ".;") or M.get_current_workspace()
end

-- Helper function to create daily note with link to previous day
M.create_daily_with_prev_link = function()
  local today = os.date "%Y-%m-%d"
  local yesterday = os.date("%Y-%m-%d", os.time() - 86400)

  -- Open today's journal
  vim.cmd "Neorg journal today"

  -- Wait for buffer to load, then add link to previous day
  vim.defer_fn(function()
    local buf = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

    -- Check if buffer is empty or just has template
    local has_prev_link = false
    for _, line in ipairs(lines) do
      if line:match "Previous:" then
        has_prev_link = true
        break
      end
    end

    if not has_prev_link then
      -- Add previous day link at the top after any existing header
      local insert_line = 0
      for i, line in ipairs(lines) do
        if line:match "^%* " then
          insert_line = i
          break
        end
      end

      local prev_link = string.format("{:$journal/%s:}[Previous: %s]", yesterday, yesterday)
      local new_lines = { "", "Previous: " .. prev_link, "" }

      if insert_line > 0 then
        vim.api.nvim_buf_set_lines(buf, insert_line, insert_line, false, new_lines)
      else
        -- No header found, add at top
        local header = string.format("* Journal - %s", today)
        vim.api.nvim_buf_set_lines(buf, 0, 0, false, { header, "", "Previous: " .. prev_link, "", "" })
      end
    end
  end, 100)
end

-- Helper to create notes in specific workspaces
M.create_work_note = function()
  vim.ui.input({ prompt = "Work note title: " }, function(title)
    if title and title ~= "" then
      local filename = title:gsub(" ", "_"):lower()
      vim.cmd(string.format "Neorg workspace work")
      vim.cmd(string.format("edit ~/.notes/work/%s.norg", filename))
    end
  end)
end

M.create_reading_note = function()
  vim.ui.input({ prompt = "Book/Article title: " }, function(title)
    if title and title ~= "" then
      local filename = title:gsub(" ", "_"):lower()
      vim.cmd(string.format "Neorg workspace reading")
      vim.cmd(string.format("edit ~/.notes/reading/%s.norg", filename))
    end
  end)
end
-- Find neorg headings using Snacks.picker
M.find_headings = function()
  local current_workspace = M.get_current_workspace()

  if not current_workspace then return end
  Snacks.picker.grep {
    dirs = { current_workspace },
    search = "^\\*+ ",
    glob = "*.norg",
    title = "Neorg Headings",
  }
end

M.find_linkables = function()
  local current_workspace = M.get_current_workspace()

  if not current_workspace then return end
  Snacks.picker.grep {
    finder = "grep",
    live = false,
    supports_live = true,
    title = "Find Linkables",

    dirs = { current_workspace },

    search = function() return [[^\s*(\*+|\|{1,2}|\${1,2})\s+]] end,
    ---@param item snacks.picker.Item
    ---@param picker snacks.Picker
    format = function(item, picker)
      local ret = {}
      return vim.list_extend(ret, Snacks.picker.format.file(item, picker))
    end,
    previewer = function(ctx) Snacks.picker.preview.file(ctx) end,
  }
end

-- Grep all notes
M.grep_notes = function()
  local current_workspace = M.get_current_workspace()

  if not current_workspace then return end
  Snacks.picker.grep {
    dirs = { current_workspace },
    glob = "*.norg",
    title = "Search Notes",
  }
end

-- Find all norg files
M.find_files = function()
  local current_workspace = M.get_current_workspace()

  if not current_workspace then return end
  Snacks.picker.files {
    finder = "files",
    live = false,
    supports_live = true,
    dirs = { current_workspace },
    title = "Find Norg Files",
    args = { "-e", "norg" },

    ---@param item snacks.picker.Item
    ---@param picker snacks.Picker
    format = function(item, picker)
      local ret = {}
      return vim.list_extend(ret, Snacks.picker.format.file(item, picker))
    end,
    previewer = function(ctx) Snacks.picker.preview.file(ctx) end,
  }
end
---@module "snacks"

--- Get the title set in the metadata block of file
--- @param file string
--- @return string?
local function get_file_title(file)
  local dirman = neorg.modules.get_module "core.dirman"
  if not dirman then return nil end

  local ts = neorg.modules.get_module "core.integrations.treesitter"
  if not ts then return nil end

  local metadata = ts.get_document_metadata(file)
  if not metadata or not metadata.title then return nil end
  return metadata.title
end

M.insert_file_link = function(opts)
  opts = opts or {}

  local current_workspace = M.get_current_workspace()

  if not current_workspace then return end

  Snacks.picker.files {
    finder = "files",
    live = false,
    supports_live = true,
    dirs = { current_workspace },
    title = "Find Norg Files",
    args = { "-e", "norg" },

    ---@param item snacks.picker.Item
    ---@param picker snacks.Picker
    format = function(item, picker)
      local ret = {}
      return vim.list_extend(ret, Snacks.picker.format.file(item, picker))
    end,
    previewer = function(ctx) Snacks.picker.preview.file(ctx) end,
    actions = {
      confirm = function(picker, entry)
        local Path = require "pathlib"

        local file = Path(entry.file)
        local relative = file:relative_to(Path(current_workspace)):tostring()

        picker:close()
        local title = get_file_title(entry.file)

        vim.api.nvim_put({
          "{" .. ":$/" .. relative .. ":" .. "}" .. "[" .. (title or relative) .. "]",
        }, "c", false, true)
        vim.api.nvim_feedkeys("hf]a", "t", false)
      end,
    },
  }
end

return M
