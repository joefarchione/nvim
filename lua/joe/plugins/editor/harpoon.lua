local function harpoon_select(i)
  return function() require("harpoon"):list():select(i) end
end

return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    {
      "<leader>ha",
      function()
        Snacks.notify "Added file to harpoon"
        require("harpoon"):list():add()
      end,
      desc = "Add file",
    },
    {
      "<leader>hh",
      function()
        local harpoon = require "harpoon"
        local list = harpoon:list()
        local items = {}
        for i, item in ipairs(list.items) do
          if item.value and item.value ~= "" then
            table.insert(items, {
              idx = i,
              file = item.value,
              text = string.format("[%d] %s", i, item.value),
            })
          end
        end
        Snacks.picker {
          title = "Harpoon",
          items = items,
          format = function(item)
            return {
              { string.format("[%d] ", item.idx), "SnacksPickerIdx" },
              { vim.fn.fnamemodify(item.file, ":t"), "SnacksPickerFile" },
              { " " },
              { vim.fn.fnamemodify(item.file, ":h"), "SnacksPickerDir" },
            }
          end,
          confirm = function(picker, item)
            picker:close()
            if item then list:select(item.idx) end
          end,
          actions = {
            delete = function(picker, item)
              if item then
                list:remove_at(item.idx)
                -- Refresh picker
                vim.schedule(function()
                  picker:close()
                  vim.cmd "doautocmd User HarpoonRefresh"
                end)
              end
            end,
          },
          win = {
            input = {
              keys = {
                ["dd"] = { "delete", mode = { "n" }, desc = "Remove from Harpoon" },
              },
            },
          },
        }
      end,
      desc = "Toggle menu",
    },
    {
      "<leader>hp",
      function() require("harpoon"):list():prev() end,
      desc = "Previous file",
    },
    {
      "<leader>hn",
      function() require("harpoon"):list():next() end,
      desc = "Next file",
    },
    -- Quick access to first 4 files
    { "<leader>h1", harpoon_select(1), desc = "File 1" },
    { "<leader>h2", harpoon_select(2), desc = "File 2" },
    { "<leader>h3", harpoon_select(3), desc = "File 3" },
    { "<leader>h4", harpoon_select(4), desc = "File 4" },
  },
  opts = {
    settings = {
      save_on_toggle = true,
      sync_on_ui_close = true,
    },
  },
}
