return {
  -- 1. Lazydev: Configures Lua LSP for Neovim config development
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  -- 2. Mason: The Portable Package Manager
  {
    'williamboman/mason.nvim',
    lazy = false,
    config = function()
      require('mason').setup()
    end,
  },

  -- 3. Mason-Lspconfig: Bridges Mason with Neovim's LSP
  {
    'williamboman/mason-lspconfig.nvim',
    lazy = false,
    opts = {
      auto_install = true,
      ensure_installed = {
        'tailwindcss',
        'lua_ls',
        'pyright',
        'ts_ls',
      },
    },
  },

  -- 4. Nvim-Lspconfig: Using the new 0.11+ Native API
  {
    'neovim/nvim-lspconfig',
    lazy = false,
    dependencies = {
      'hrsh7th/cmp-nvim-lsp', -- Required for autocompletion capabilities
    },
    config = function()
      -- [[ 1. Keymaps: Only attach when an LSP is active in a buffer ]]
      -- Optional: Diagnostic keymaps
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(event)
          local opts = { buffer = event.buf }

          -- Keybindings
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', '<leader>gf', function()
            vim.lsp.buf.format { async = true }
          end, opts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        end,
      })

      -- [[ 2. Capabilities: Inform servers of features supported by cmp-nvim-lsp ]]
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- [[ 3. Server Registration (Native 0.11 API) ]]
      local servers = {
        'tailwindcss',
        'lua_ls',
        'pyright',
        'ts_ls',
      }

      for _, server_name in ipairs(servers) do
        -- Register the server configuration
        vim.lsp.config(server_name, {
          capabilities = capabilities,
          -- You can add server-specific settings here if needed
          -- settings = { ... }
        })

        -- Enable the server globally
        vim.lsp.enable(server_name)
      end
    end,
  },
}
