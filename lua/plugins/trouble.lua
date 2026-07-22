return {
  'folke/trouble.nvim',
  cmd = 'Trouble',
  opts = {
    focus = false,
    follow = true,
  },
  keys = {
    { '<leader>gd', '<cmd>Trouble lsp_definitions toggle focus=false win.position=right<cr>', desc = 'Go to definition' },
    { '<leader>gr', '<cmd>Trouble lsp_references toggle focus=true win.position=right<cr>', desc = 'Go to references' },
    { '<leader>cs', '<cmd>Trouble symbols toggle focus=false<cr>', desc = 'Symbols' },
  },
}
