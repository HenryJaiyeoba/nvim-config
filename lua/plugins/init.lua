return {
  {
    'luckasRanarison/tailwind-tools.nvim',
    name = 'tailwind-tools',
    build = ':UpdateRemotePlugins',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-telescope/telescope.nvim',
      'neovim/nvim-lspconfig',
    },
    opts = {
      server = {
        -- Set to false because we already set up tailwindcss in lsp.lua!
        -- This prevents the plugin from trying to start a second instance.
        override = false,
      },
    },
  },

  { 'github/copilot.vim' },

  {
    'kylechui/nvim-surround',
    version = '*', -- Use for stability; omit to use `main` branch for the latest features
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup {}
    end,
  },

  {
    'numToStr/Comment.nvim',
    opts = {},
  },

  -- Smooth scrolling (vim-smoothie is fine, but neoscroll.nvim is the modern Lua equivalent if you prefer)
  {
    'psliwka/vim-smoothie',
  },

  -- Replaced 'norcalli' with the maintained 'NvChad' fork
  {
    'NvChad/nvim-colorizer.lua',
    event = 'User FileOpened',
    opts = {
      user_default_options = {
        tailwind = true, -- Enable tailwind colors
        css = true,
      },
    },
  },
}
