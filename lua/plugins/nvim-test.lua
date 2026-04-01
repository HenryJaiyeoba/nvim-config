return {
  'vim-test/vim-test',
  dependencies = {
    'preservim/vimux',
  },
  keys = {
    { '<leader>tt', '<cmd>TestNearest<CR>', desc = 'Test nearest' },
    { '<leader>tT', '<cmd>TestFile<CR>', desc = 'Test file' },
    { '<leader>ta', '<cmd>TestSuite<CR>', desc = 'Test suite' },
    { '<leader>lt', '<cmd>TestLast<CR>', desc = 'Test last' },
    { '<leader>tg', '<cmd>TestVisit<CR>', desc = 'Test visit' },
  },
  config = function()
    vim.g['test#strategy'] = 'vimux'
  end,
}
