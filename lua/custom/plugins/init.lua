-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'luckasRanarison/tailwind-tools.nvim',
    name = 'tailwind-tools',
    build = ':UpdateRemotePlugins',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-telescope/telescope.nvim', -- optional
      'neovim/nvim-lspconfig', -- optional
    },
    opts = {}, -- your configuration
  },
  { 'github/copilot.vim' },
  {
    'rmagatti/auto-session',
    config = function()
      require('auto-session').setup {
        auto_restore_enabled = true,
        auto_save_enabled = true,
        suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
        auto_session_enable_last_session = true,
        session_lens = {
          load_on_setup = true, -- Initialize on startup (requires Telescope)
          theme_conf = { -- Pass through for Telescope theme options
            -- layout_config = { -- As one example, can change width/height of picker
            --   width = 0.8,    -- percent of window
            --   height = 0.5,
            -- },
          },
          previewer = false, -- File preview for session picker

          mappings = {
            -- Mode can be a string or a table, e.g. {"i", "n"} for both insert and normal mode
            delete_session = { 'i', '<C-D>' },
            alternate_session = { 'i', '<C-S>' },
            copy_session = { 'i', '<C-Y>' },
          },

          session_control = {
            control_dir = vim.fn.stdpath 'data' .. '/auto_session/', -- Auto session control dir, for control files, like alternating between two sessions with session-lens
            control_filename = 'session_control.json', -- File name of the session control file
          },
        },
      }
    end,
  },
  {
    'kylechui/nvim-surround',
    version = '^3.0.0', -- Use for stability; omit to use `main` branch for the latest features
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup {
        -- Configuration here, or leave empty to use defaults
      }
    end,
  },
  {
    'numToStr/Comment.nvim',
    opts = {
      -- add any options here
    },
  },
  {
    'psliwka/vim-smoothie',
  },
  {
    'norcalli/nvim-colorizer.lua',
  },

  -- { 'rafamadriz/friendly-snippets' },
}
