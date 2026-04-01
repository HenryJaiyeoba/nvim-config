return {
  -- {
  --   'rebelot/kanagawa.nvim',
  --   priority = 1000,
  --   config = function()
  --     require('kanagawa').setup {
  --       -- This removes the background color from the gutter (line numbers, etc.)
  --       colors = {
  --         theme = {
  --           all = {
  --             ui = {
  --               bg_gutter = 'none',
  --             },
  --           },
  --         },
  --       },
  --     }
  --
  --     -- Load the dragon variant specifically
  --     vim.cmd.colorscheme 'kanagawa-dragon'
  --   end,
  -- },
  -- You can keep TokyoNight here as a backup if you want,
  -- but ensure you only have one `vim.cmd.colorscheme` active.
  -- {'EdenEast/nightfox.nvim },
  {
    'catppuccin/nvim',
    lazy = false,
    name = 'catppuccin',
    priority = 1000,

    config = function()
      require('catppuccin').setup {
        transparent_background = true,
      }
      vim.cmd.colorscheme 'catppuccin-mocha'
    end,
  },
}
