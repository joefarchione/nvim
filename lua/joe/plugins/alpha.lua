return {
  {
    "goolord/alpha-nvim",
    cmd = "Alpha",
    event = "VimEnter",
    opts = function()
      local dashboard = require "alpha.themes.dashboard"
      dashboard.section.header.val = {
        '                            ...,ooooooooo......',
        '                      .o8888888888888888888888888o.',
        '                  .o888888888888888888888888888888888o.',
        '                o8888888888A88"V888888888888888888888888o',
        '              o88888887"8"  "   V888  88888888888888888888o',
        '            o88888888            V     888888888888888888888o',
        '           o888888888                   888888888888888888888o',
        '          .88888888888                  88888V"  "V88888888888.',
        '          o88888888888v                 8888"  v8  88888888888o',
        '          88888888888v                  8888v  v88 888888888888',
        '          888888888888                  88888v  "88888888888888',
        '           88888888888V                  V88888v  "88888888888',
        '           88888888888v                            "8888888888',
        '____________8888888888888v.........................v888888888_____________',
        ":::::::::::::::::::::::::'                         :::::::::::::::::::::::",
        ":::::::::::::::::::::::                .:::::::    .::::::::::::::::::::::",
        "::::::::::::::::::::::                 :::::::  .:::::::::::::::::::::::::",
        ":::::::::::::::::::::                  ::::::  ::: :::::::::::::::::::::::",
        ":::::::::::::::::::::.                 ::::::. :: .:::::::::::::::::::::::",
        "::::::::::::::::::::::                 :::::::.  .::::::::::::::::::::::::",
        ":::::::::::::::::::::.           .     :::::::::::::::::::::::::::::::::::",
        ":::::::::::::::::::::          :::.   ::::::::::::::::::::::::::::::::::::",
        "::::::::::::::::::::::.::.:: :::::::.:::::::::::::::::::::::::::::::::::::",
        "::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::",
      }
      dashboard.section.header.opts.hl = "DashboardHeader"

      local button = require("joe.utils").alpha_button
      local get_icon = require("joe.utils").get_icon
      dashboard.section.buttons.val = {
        button("LDR n", get_icon("FileNew", 2, true) .. "New File  "),
        button("LDR f f", get_icon("Search", 2, true) .. "Find File  "),
        button("LDR f o", get_icon("DefaultFile", 2, true) .. "Recents  "),
        button("LDR f w", get_icon("WordFile", 2, true) .. "Find Word  "),
        button("LDR f '", get_icon("Bookmarks", 2, true) .. "Bookmarks  "),
        button("LDR f p", get_icon("FolderOpen", 2, true) .. "Find Project  "),
        button("LDR S l", get_icon("Refresh", 2, true) .. "Last Session  "),
      }

      dashboard.config.layout = {
        { type = "padding", val = vim.fn.max { 2, vim.fn.floor(vim.fn.winheight(0) * 0.2) } },
        dashboard.section.header,
        { type = "padding", val = 5 },
        dashboard.section.buttons,
        { type = "padding", val = 3 },
        dashboard.section.footer,
      }
      dashboard.config.opts.noautocmd = true
      return dashboard
    end,
    config = require "joe.plugins.configs.alpha",
  },
}
