local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local cmd = vim.api.nvim_create_user_command
local namespace = vim.api.nvim_create_namespace

local utils = require "joe.utils"
local is_available = utils.is_available

vim.on_key(function(char)
  if vim.fn.mode() == "n" then
    local new_hlsearch = vim.tbl_contains({ "<CR>", "n", "N", "*", "#", "?", "/" }, vim.fn.keytrans(char))
    if vim.opt.hlsearch:get() ~= new_hlsearch then vim.opt.hlsearch = new_hlsearch end
  end
end, namespace "auto_hlsearch")

autocmd("BufReadPre", {
  desc = "Disable certain functionality on very large files",
  group = augroup("large_buf", { clear = true }),
  callback = function(args)
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(args.buf))
    vim.b[args.buf].large_buf = (ok and stats and stats.size > vim.g.max_file.size)
        or vim.api.nvim_buf_line_count(args.buf) > vim.g.max_file.lines
  end,
})

if is_available "alpha-nvim" then
  autocmd({ "VimEnter", "BufEnter" }, {
    desc = "Disable status, tablines, and cmdheight for alpha",
    group = augroup("alpha_settings", { clear = true }),
    callback = function(args)
      if
          (
            (args.event == "User" and args.file == "AlphaReady")
            or (args.event == "BufEnter" and vim.api.nvim_get_option_value("filetype", { buf = args.buf }) == "alpha")
          ) and not vim.g.before_alpha
      then
        vim.g.before_alpha = {
          showtabline = vim.opt.showtabline:get(),
          laststatus = vim.opt.laststatus:get(),
          cmdheight = vim.opt.cmdheight:get(),
        }
        vim.opt.showtabline, vim.opt.laststatus, vim.opt.cmdheight = 0, 0, 0
      elseif
          vim.g.before_alpha
          and args.event == "BufEnter"
          and vim.api.nvim_get_option_value("buftype", { buf = args.buf }) ~= "nofile"
      then
        vim.opt.laststatus, vim.opt.showtabline, vim.opt.cmdheight =
            vim.g.before_alpha.laststatus, vim.g.before_alpha.showtabline, vim.g.before_alpha.cmdheight
        vim.g.before_alpha = nil
      end
    end,
  })
  autocmd("VimEnter", {
    desc = "Start Alpha when vim is opened with no arguments",
    group = augroup("alpha_autostart", { clear = true }),
    callback = function()
      local should_skip = false
      if vim.fn.argc() > 0 or vim.fn.line2byte(vim.fn.line "$") ~= -1 or not vim.o.modifiable then
        should_skip = true
      else
        for _, arg in pairs(vim.v.argv) do
          if arg == "-b" or arg == "-c" or vim.startswith(arg, "+") or arg == "-S" then
            should_skip = true
            break
          end
        end
      end
      if not should_skip then
        require("alpha").stare(true, require("alpha").config)
        vim.schedule(function() vim.cmd.doautocmd "FileType" end)
      end
    end,
  })
end
if is_available "neo-tree.nvim" then
  autocmd("BufEnter", {
    desc = "Open Neo-Tree on startup with directory",
    group = augroup("neotree_start", { clear = true }),
    callback = function()
      if package.loaded["neo-tree"] then
        vim.api.nvim_del_augroup_by_name "neotree_start"
      else
        local stats = (vim.uv or vim.loop).fs_stat(vim.api.nvim_buf_get_name(0)) -- TODO: REMOVE vim.loop WHEN DROPPING SUPPORT FOR Neovim v0.9
        if stats and stats.type == "directory" then
          vim.api.nvim_del_augroup_by_name "neotree_start"
          require "neo-tree"
        end
      end
    end,
  })
  autocmd("TermClose", {
    pattern = "*lazygit",
    desc = "Refresh Neo-Tree git when closing lazygit",
    group = augroup("neotree_git_refresh", { clear = true }),
    callback = function()
      if package.loaded["neo-tree.sources.git_status"] then require("neo-tree.sources.git_status").refresh() end
    end,
  })
end

if is_available "resession" then
  -- save last session
  local resession = require("resession")
  vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
      -- Always save a special session named "last"
      resession.save("last")
    end,
  })
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      -- Only load the session if nvim was started with no args
      if vim.fn.argc(-1) == 0 then
        -- Save these to a different directory, so our manual sessions don't get polluted
        resession.load(vim.fn.getcwd(), { dir = "dirsession", silence_errors = true })
      end
    end,
  })
  -- directory session
  vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
      resession.save(vim.fn.getcwd(), { dir = "dirsession", notify = false })
    end,
  })
  -- git session
  local function get_session_name()
    local name = vim.fn.getcwd()
    local branch = vim.trim(vim.fn.system("git branch --show-current"))
    if vim.v.shell_error == 0 then
      return name .. branch
    else
      return name
    end
  end
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      -- Only load the session if nvim was started with no args
      if vim.fn.argc(-1) == 0 then
        resession.load(get_session_name(), { dir = "dirsession", silence_errors = true })
      end
    end,
  })
  vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
      resession.save(get_session_name(), { dir = "dirsession", notify = false })
    end,
  })
end

if is_available "lint" then
  vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    callback = function()
      require("lint").try_lint()
    end,
  })
end
