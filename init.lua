-- Set <space> as the leader key
-- See `:help mapleader`
-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- make splitting sensible
vim.o.splitright = true
vim.o.splitbelow = true

-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = true

-- Load core config
require 'config.options'
require 'config.keymaps'
require 'config.autocmds'

-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

--inline errors
vim.diagnostic.config {
  virtual_text = true,
  signs = true,
  underline = false,
  update_in_insert = false,
  severity_sort = true,
}

-- [[ Configure and install plugins ]]
require('lazy').setup({
  -- This line tells Lazy to import every .lua file in lua/plugins/
  { import = 'plugins' },
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
-- [[configure GUI Neovide]
if vim.g.neovide then
  vim.o.guifont = 'Iosevka Nerd Font Propo:h21' -- Adjust :h14 for size
  vim.g.neovide_menu = false
  vim.opt.linespace = 0
  vim.opt.guioptions:remove 'm'
  vim.g.neovide_hide_title_bar = true
end
