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
          vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, with_desc 'Code action')
          vim.keymap.set('n', '<leader>gf', function()
            vim.lsp.buf.format { async = true }
          end, with_desc 'Format buffer')
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, with_desc 'Rename symbol')
        end,
      })

      -- [[ 2. Capabilities: Inform servers of features supported by blink.cmp ]]
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      local function find_python(root_dir)
        local candidates = {
          vim.fs.joinpath(root_dir, '.venv', 'bin', 'python'),
          vim.fs.joinpath(root_dir, 'venv', 'bin', 'python'),
          vim.fs.joinpath(root_dir, '.venv', 'Scripts', 'python.exe'),
          vim.fs.joinpath(root_dir, 'venv', 'Scripts', 'python.exe'),
        }

        for _, python in ipairs(candidates) do
          if vim.fn.executable(python) == 1 then
            return python
          end
        end
      end

      -- [[ 3. Server Registration (Native 0.11 API) ]]
      local servers = {
        tailwindcss = {},
        lua_ls = {},
        pyright = {
          before_init = function(_, config)
            local root_dir = config.root_dir or vim.fn.getcwd()
            local python = find_python(root_dir)
            if not python then
              return
            end

            config.settings = config.settings or {}
            config.settings.python = vim.tbl_deep_extend('force', config.settings.python or {}, {
              pythonPath = python,
              venvPath = root_dir,
              venv = python:find('/%.venv/', 1, false) and '.venv' or 'venv',
            })
          end,
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = 'workspace',
              },
            },
          },
        },
        ts_ls = {},
      }

      for server_name, server_config in pairs(servers) do
        -- Register the server configuration
        vim.lsp.config(server_name, vim.tbl_deep_extend('force', {
          capabilities = capabilities,
        }, server_config))

        -- Enable the server globally
        vim.lsp.enable(server_name)
      end
    end,
  },
}
