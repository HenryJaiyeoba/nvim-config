return {
  {
    'rebelot/kanagawa.nvim',
    priority = 1000, -- Ensure it loads before everything else
    config = function()
      -- Compile the theme
      require('kanagawa').load 'dragon'
      vim.cmd.colorscheme 'kanagawa-dragon'
    end,
  },
  -- You can keep TokyoNight here as a backup if you want,
  -- but ensure you only have one `vim.cmd.colorscheme` active.
  { 'EdenEast/nightfox.nvim' },
}
