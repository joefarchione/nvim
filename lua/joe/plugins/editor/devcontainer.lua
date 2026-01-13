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
    { "<leader>Dca", "<cmd>DevcontainerAttachAuto<cr>", desc = "Attach to container" },
    { "<leader>Dcb", "<cmd>DevcontainerBuild<cr>", desc = "Build container" },
    { "<leader>Dcr", "<cmd>DevcontainerBuildRunAndAttach<cr>", desc = "Build, run & attach" },
    { "<leader>Dcs", "<cmd>DevcontainerStartAutoAndAttach<cr>", desc = "Start & attach" },
    { "<leader>Dcx", "<cmd>DevcontainerStopAuto<cr>", desc = "Stop container" },
    { "<leader>Dcl", "<cmd>DevcontainerLogs<cr>", desc = "View logs" },
    { "<leader>Dce", "<cmd>DevcontainerEditNearestConfig<cr>", desc = "Edit devcontainer.json" },
    { "<leader>Dcu", "<cmd>DevcontainerComposeUp<cr>", desc = "Compose up" },
    { "<leader>Dcd", "<cmd>DevcontainerComposeDown<cr>", desc = "Compose down" },
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
