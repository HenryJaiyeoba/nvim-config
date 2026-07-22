return {
  'MeanderingProgrammer/render-markdown.nvim',
  ft = { 'markdown' },
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  keys = {
    { '<leader>md', '<cmd>RenderMarkdown toggle<cr>', desc = 'Toggle markdown render' },
  },
  opts = {
    completions = {
      lsp = { enabled = true },
    },
  },
}
