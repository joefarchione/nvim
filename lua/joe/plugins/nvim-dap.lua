return {
  'mfussenegger/nvim-dap',
  config = function()
    local dap = require('dap')

    dap.configurations.python = {
      {
        type = 'python',
        request = 'launch',
        name = "Launch file",
        program = "${file}",
      },
      {
        type = 'python',
        request = 'launch',
        name = "Module",
        module = "${file}",
      },
    }
  end
}
