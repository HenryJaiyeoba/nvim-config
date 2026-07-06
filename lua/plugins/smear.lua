return {
  'sphamba/smear-cursor.nvim',
  cond = function()
    -- Neovide already renders its own animated cursor and this plugin can
    -- leave shadow/ghost artifacts on transparent backgrounds.
    return not vim.g.neovide
  end,
  opts = {
    stiffness = 0.7,
    trailing_stiffness = 0.35,
    distance_stop_animating = 0.25,
  },
}
