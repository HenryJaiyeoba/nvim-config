return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'master',
  build = ':TSUpdate',
  config = function()
    local configs = require 'nvim-treesitter.configs'
    configs.setup {
      ensure_installed = { 'c', 'cpp', 'lua', 'vim', 'vimdoc', 'query', 'python' },
      highlight = { enable = true },
      indent = { enable = true },
    }
  end,
}
