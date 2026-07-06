return {
  'folke/trouble.nvim',
  cmd = 'Trouble',
  opts = {
    focus = false,
    follow = true,
  },
  keys = {
    { '<leader>dt', '<cmd>Trouble diagnostics toggle focus=true<cr>', desc = 'Diagnostics' },
    { '<leader>dl', '<cmd>Trouble diagnostics toggle filter.buf=0 focus=true<cr>', desc = 'Buffer diagnostics' },
    { '<leader>dq', '<cmd>Trouble qflist toggle<cr>', desc = 'Quickfix list' },
    { '<leader>gd', '<cmd>Trouble lsp_definitions toggle focus=false win.position=right<cr>', desc = 'Go to definition' },
    { '<leader>gr', '<cmd>Trouble lsp_references toggle focus=false win.position=right<cr>', desc = 'Go to references' },
    { '<leader>cs', '<cmd>Trouble symbols toggle focus=false<cr>', desc = 'Symbols' },
    { '<leader>xl', '<cmd>Trouble loclist toggle<cr>', desc = 'Location list' },
    { '<leader>xx', '<cmd>Trouble diagnostics toggle focus=true<cr>', desc = 'Diagnostics (Trouble)' },
  },
}
