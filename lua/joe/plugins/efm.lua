return {
  'creativenull/efmls-configs-nvim',
  version = 'v0.2.x', -- tag is optional
  dependencies = { 'neovim/nvim-lspconfig' },
  config = function()
    local function on_attach(client)
      print('Attached to ' .. client.name)
    end

    local efmls = require 'efmls-configs'
    efmls.init {
      -- Your custom attach function
      on_attach = on_attach,

      -- Enable formatting provided by efm langserver
      init_options = {
        documentFormatting = true,
      },
    }

    local pylint = require 'efmls-configs.linters.pylint'
    local black = require 'efmls-configs.formatters.black'
    efmls.setup {
      javascript = {
        linter = pylint,
        formatter = black,
      },
    }
  end
}
