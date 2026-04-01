return {
  {
    'karshPrime/tmux-compile.nvim',
    config = function()
      require('tmux-compile').setup {
        build_run_config = {
          {
            extension = { 'cpp', 'cc', 'cxx' },
            build = 'clang++ src/main.cpp src/**/*.cpp -Iinclude -std=c++17 -o app',
            run = './build/app',
            debug = 'lldb ./app',
          },
          {

            extension = { 'py' },
            run = 'python3',
          },
        },
      }
      vim.keymap.set('n', '<leader>rr', ':TMUXcompile Make<CR>')
      vim.keymap.set('n', '<leader>rm', ':TMUXcompile Run<CR>')
    end,
  },
}
