return {
  'romgrk/barbar.nvim',
  version = '^1.0.0',
  event = 'VeryLazy',
  dependencies = {
    'lewis6991/gitsigns.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  init = function()
    vim.g.barbar_auto_setup = false
    vim.opt.showtabline = 2
  end,
  opts = {
    animation = false,
    insert_at_end = true,
    maximum_padding = 1,
    minimum_padding = 1,
  },
  keys = {
    { '[b', '<Cmd>BufferPrevious<CR>', desc = 'Previous buffer' },
    { ']b', '<Cmd>BufferNext<CR>', desc = 'Next buffer' },
    { '<leader>1', '<Cmd>BufferGoto 1<CR>', desc = 'Go to buffer 1' },
    { '<leader>2', '<Cmd>BufferGoto 2<CR>', desc = 'Go to buffer 2' },
    { '<leader>3', '<Cmd>BufferGoto 3<CR>', desc = 'Go to buffer 3' },
    { '<leader>4', '<Cmd>BufferGoto 4<CR>', desc = 'Go to buffer 4' },
    { '<leader>5', '<Cmd>BufferGoto 5<CR>', desc = 'Go to buffer 5' },
    { '<leader>6', '<Cmd>BufferGoto 6<CR>', desc = 'Go to buffer 6' },
    { '<leader>7', '<Cmd>BufferGoto 7<CR>', desc = 'Go to buffer 7' },
    { '<leader>8', '<Cmd>BufferGoto 8<CR>', desc = 'Go to buffer 8' },
    { '<leader>9', '<Cmd>BufferGoto 9<CR>', desc = 'Go to buffer 9' },
    { '<leader><leader>', '<Cmd>BufferPick<CR>', desc = 'Pick buffer' },
    { '<leader>bd', '<Cmd>BufferClose<CR>', desc = 'Close buffer' },
    { '<leader>bo', '<Cmd>BufferCloseAllButCurrentOrPinned<CR>', desc = 'Close other buffers' },
    { '<leader>bp', '<Cmd>BufferPin<CR>', desc = 'Pin buffer' },
    { '<leader>br', '<Cmd>BufferRestore<CR>', desc = 'Restore buffer' },
  },
}
