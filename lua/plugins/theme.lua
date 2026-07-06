return {
  {
    'rebelot/kanagawa.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('kanagawa').setup {
        -- This removes the background color from the gutter (line numbers, etc.)
        colors = {
          theme = {
            all = {
              ui = {
                bg_gutter = 'none',
              },
            },
          },
        },
      }

      vim.cmd.colorscheme 'kanagawa-wave'
    end,
  },
  -- You can keep TokyoNight here as a backup if you want,
  -- but ensure you only have one `vim.cmd.colorscheme` active.
  { 'EdenEast/nightfox.nvim' },
  {
    'catppuccin/nvim',
    name = 'catppuccin',

    config = function()
      require('catppuccin').setup {
        -- Transparent backgrounds tend to expose Neovide redraw artifacts when
        -- scaling, so keep them only outside of Neovide.
        transparent_background = not vim.g.neovide,
      }
    end,
  },
}
