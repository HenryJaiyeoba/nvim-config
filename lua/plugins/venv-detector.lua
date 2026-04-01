return {
  'linux-cultist/venv-selector.nvim',
  dependencies = {
    'neovim/nvim-lspconfig',
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    require('venv-selector').setup {
      auto_refresh = true,
      auto_select = true,
      search_venv_managers = true,
    }
  end,
}
