return {
  { -- Autocompletion
    'saghen/blink.cmp',
    lazy = false,
    version = '1.*',
    dependencies = {
      'saghen/blink.lib',
      {
        'L3MON4D3/LuaSnip',
        version = 'v2.*',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
      },
    },
    opts = {
      keymap = {
        preset = 'super-tab',
        ['<CR>'] = { 'select_and_accept', 'fallback' },
      },
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        ghost_text = { enabled = false },
      },
      signature = { enabled = true },
      snippets = { preset = 'luasnip' },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
      fuzzy = { implementation = 'lua' },
    },
  },
}
