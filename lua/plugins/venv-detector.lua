local function has_fd()
  return vim.fn.executable 'fd' == 1 or vim.fn.executable 'fdfind' == 1 or vim.fn.executable 'fd_find' == 1
end

return {
  'linux-cultist/venv-selector.nvim',
  ft = 'python',
  enabled = has_fd,
  dependencies = {
    'neovim/nvim-lspconfig',
    'nvim-telescope/telescope.nvim',
  },
  opts = {},
}
