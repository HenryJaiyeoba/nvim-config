return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'master',
  build = ':TSUpdate',
  dependencies = {
    'windwp/nvim-ts-autotag',
  },
  config = function()
    local configs = require 'nvim-treesitter.configs'
    configs.setup {
      ensure_installed = { 'c', 'cpp', 'html', 'javascript', 'lua', 'python', 'query', 'tsx', 'typescript', 'vim', 'vimdoc' },
      highlight = { enable = true },
      indent = { enable = true },
    }

    require('nvim-ts-autotag').setup()
  end,
}
