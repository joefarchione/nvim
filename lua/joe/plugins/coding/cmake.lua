return {
  "Civitasv/cmake-tools.nvim",
  ft = { "cmake", "cpp", "c", "cuda" },
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    cmake_command = "cmake",
    ctest_command = "ctest",
    cmake_build_directory = "build/${variant:buildType}",
    cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" },
    cmake_soft_link_compile_commands = true,
    cmake_executor = {
      name = "toggleterm",
      default_opts = {
        toggleterm = {
          direction = "horizontal",
          close_on_exit = false,
        },
      },
    },
    cmake_runner = {
      name = "toggleterm",
      default_opts = {
        toggleterm = {
          direction = "horizontal",
          close_on_exit = false,
        },
      },
    },
    cmake_notifications = {
      runner = { enabled = true },
      executor = { enabled = true },
    },
  },
  keys = {
    { "<leader>k", group = "CMake" },
    { "<leader>kg", "<cmd>CMakeGenerate<cr>", desc = "Configure (generate)" },
    { "<leader>kb", "<cmd>CMakeBuild<cr>", desc = "Build" },
    { "<leader>kr", "<cmd>CMakeRun<cr>", desc = "Run" },
    { "<leader>kd", "<cmd>CMakeDebug<cr>", desc = "Debug" },
    { "<leader>kt", "<cmd>CMakeRunTest<cr>", desc = "Test (ctest)" },
    { "<leader>kc", "<cmd>CMakeClean<cr>", desc = "Clean" },
    { "<leader>ks", "<cmd>CMakeSelectBuildTarget<cr>", desc = "Select build target" },
    { "<leader>kS", "<cmd>CMakeSelectLaunchTarget<cr>", desc = "Select launch target" },
    { "<leader>kp", "<cmd>CMakeSelectBuildType<cr>", desc = "Select build type" },
    { "<leader>kP", "<cmd>CMakeSelectBuildPreset<cr>", desc = "Select build preset" },
    { "<leader>kq", "<cmd>CMakeClose<cr>", desc = "Close executor/runner" },
    { "<leader>ki", "<cmd>CMakeSettings<cr>", desc = "CMake settings" },
  },
}
