return {
  'coffebar/neovim-project',
  lazy = false,
  priority = 100,
  init = function()
    -- Preserve plugin state that stores UI/session metadata.
    vim.opt.sessionoptions:append 'globals'
  end,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'Shatur/neovim-session-manager',
  },
  keys = {
    { '<leader>pp', '<cmd>NeovimProjectDiscover history<CR>', desc = 'Projects discover' },
    { '<leader>ph', '<cmd>NeovimProjectHistory<CR>', desc = 'Projects history' },
    { '<leader>pr', '<cmd>NeovimProjectLoadRecent<CR>', desc = 'Projects recent' },
  },
  opts = {
    projects = {
      '~/core/*',
      '~/.config/*',
    },
    picker = {
      type = 'telescope',
      preview = {
        enabled = true,
        git_status = true,
        show_hidden = true,
      },
    },
    last_session_on_startup = false,
    dashboard_mode = false,
    session_manager_opts = {
      autosave_ignore_dirs = {
        vim.fn.expand '~',
        '/tmp',
      },
      autosave_ignore_filetypes = {
        'dap-repl',
        'gitcommit',
        'gitrebase',
        'qf',
      },
    },
  },
}
