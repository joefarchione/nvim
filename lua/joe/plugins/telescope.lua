return {
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
    config = function()
      local telescope = require('telescope')
      telescope.load_extension 'projects'
      telescope.load_extension 'fzf'
      telescope.setup {
        defaults = {
          mappings = {
            i = {
              ['<C-h>'] = "which_key",
              ['<C-u>'] = false,
              ['<C-d>'] = false,
            },
          },
          file_ignore_patterns = {
            '.git/',
            'target/',
            'vendor/*',
            '%.lock',
            '__pycache__/*',
            '%.sqlite3',
            'node_modules/*',
            '%.jpg',
            '%.jpeg',
            '%.png',
            '%.svg',
            '%.otf',
            '%.ttf',
            '%.webp',
            '.gradle/',
            '.idea/',
            '.settings/',
            '.vscode/',
            '__pycache__/',
            'build/',
            'env/',
            'gradle/',
            'smalljre_*/*',
          },
        },
      }
    end
  },
}
