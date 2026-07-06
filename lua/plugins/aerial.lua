return {
  'stevearc/aerial.nvim',
  branch = 'nvim-0.11',
  cmd = {
    'AerialToggle',
    'AerialOpen',
    'AerialClose',
    'AerialNext',
    'AerialPrev',
    'AerialNavToggle',
    'AerialNavOpen',
    'AerialNavClose',
  },
  keys = {
    {
      '<leader>co',
      function()
        require('aerial').toggle { focus = true }
      end,
      desc = 'Code outline',
    },
    {
      '<leader>cn',
      function()
        require('aerial').nav_toggle()
      end,
      desc = 'Code nav',
    },
    {
      '[s',
      function()
        require('aerial').prev()
      end,
      desc = 'Previous symbol',
    },
    {
      ']s',
      function()
        require('aerial').next()
      end,
      desc = 'Next symbol',
    },
  },
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  init = function()
    vim.keymap.set('c', '<CR>', function()
      local command = vim.fn.getcmdline()
      if vim.fn.getcmdtype() == ':' and command:match '^aerial%s+nav%s+toggle%s*$' then
        return '<C-u>AerialNavToggle<CR>'
      end
      return '<CR>'
    end, { expr = true, desc = 'Aerial command aliases' })
  end,
  opts = {
    backends = { 'treesitter', 'lsp', 'markdown', 'man' },
    layout = {
      default_direction = 'right',
      min_width = 28,
      max_width = { 40, 0.25 },
    },
    filter_kind = false,
    highlight_mode = 'split_width',
    manage_folds = true,
  },
}
