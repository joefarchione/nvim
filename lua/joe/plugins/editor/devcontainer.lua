return {
  "esensar/nvim-dev-container",
  dependencies = { "nvim-treesitter/nvim-treesitter", "folke/snacks.nvim" },
  cmd = {
    "DevcontainerBuild",
    "DevcontainerImageRun",
    "DevcontainerBuildAndRun",
    "DevcontainerBuildRunAndAttach",
    "DevcontainerComposeUp",
    "DevcontainerComposeDown",
    "DevcontainerComposeRm",
    "DevcontainerStartAuto",
    "DevcontainerStartAutoAndAttach",
    "DevcontainerAttachAuto",
    "DevcontainerStopAuto",
    "DevcontainerStopAll",
    "DevcontainerLogs",
    "DevcontainerOpenNearestConfig",
    "DevcontainerEditNearestConfig",
  },
  keys = {
    { "<leader>vca", "<cmd>DevcontainerAttachAuto<cr>", desc = "Attach to container" },
    { "<leader>vcb", "<cmd>DevcontainerBuild<cr>", desc = "Build container" },
    { "<leader>vcr", "<cmd>DevcontainerBuildRunAndAttach<cr>", desc = "Build, run & attach" },
    { "<leader>vcs", "<cmd>DevcontainerStartAutoAndAttach<cr>", desc = "Start & attach" },
    { "<leader>vcx", "<cmd>DevcontainerStopAuto<cr>", desc = "Stop container" },
    { "<leader>vcl", "<cmd>DevcontainerLogs<cr>", desc = "View logs" },
    { "<leader>vce", "<cmd>DevcontainerEditNearestConfig<cr>", desc = "Edit devcontainer.json" },
    { "<leader>vcu", "<cmd>DevcontainerComposeUp<cr>", desc = "Compose up" },
    { "<leader>vcd", "<cmd>DevcontainerComposeDown<cr>", desc = "Compose down" },
  },
  opts = {
    -- Path to cache directory (stores container status)
    cache_dir = vim.fn.stdpath "cache" .. "/devcontainer",

    -- Container runtime: "docker" or "podman"
    container_runtime = "docker",

    -- Compose command: "docker-compose" or "docker compose"
    compose_command = "docker compose",

    -- Generate statusline info
    generate_commands = true,

    -- Attach to running container behavior
    attach_mounts = {
      -- Mount neovim config
      neovim_config = {
        enabled = true,
        options = { "readonly" },
      },
      -- Mount neovim data (plugins, etc.)
      neovim_data = {
        enabled = false,
        options = {},
      },
      -- Mount neovim state
      neovim_state = {
        enabled = false,
        options = {},
      },
    },

    -- Always install these in the container
    always_mount = {},

    -- Terminal handler for attaching
    terminal_handler = function(command)
      Snacks.terminal(command, {
        win = { style = "terminal" },
      })
    end,
  },
}
