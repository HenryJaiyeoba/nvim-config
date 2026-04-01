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
          local function with_desc(desc)
            return vim.tbl_extend('force', opts, { desc = desc })
          end

          -- Keybindings
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, with_desc 'Hover documentation')
          vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, with_desc 'Go to definition')
          vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references, with_desc 'Go to references')
          vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, with_desc 'Code action')
          vim.keymap.set('n', '<leader>gf', function()
            vim.lsp.buf.format { async = true }
          end, with_desc 'Format buffer')
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, with_desc 'Rename symbol')
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
