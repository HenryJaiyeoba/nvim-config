-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>n', '<cmd>nohlsearch<CR>')

-- Better exit from insert mode
vim.keymap.set('i', 'jk', '<Esc>')
vim.keymap.set('v', 'jk', '<Esc>')

-- Diagnostic navigation
vim.keymap.set('n', '<leader>l', vim.diagnostic.setloclist, { desc = 'Open diagnostic Loclist' })
vim.keymap.set('n', '<leader>e', function()
  vim.diagnostic.open_float(nil, { focus = false })
end, { desc = 'Show line diagnostics' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setqflist, { desc = 'Diagnostics (workspace)' })
-- Quickfix navigation
vim.keymap.set('n', ']q', ':cnext<CR>', { desc = 'Next quickfix item' })
vim.keymap.set('n', '[q', ':cprev<CR>', { desc = 'Previous quickfix item' })
vim.keymap.set('n', '<leader>co', ':copen<CR>', { desc = 'Open quickfix' })
vim.keymap.set('n', '<leader>cc', ':cclose<CR>', { desc = 'Close quickfix' })

--Location list navigation
vim.keymap.set('n', ']l', ':lnext<CR>', { desc = 'Next loclist item' })
vim.keymap.set('n', '[l', ':lprev<CR>', { desc = 'Previous loclist item' })
vim.keymap.set('n', '<leader>lo', ':lopen<CR>', { desc = 'Open loclist' })
vim.keymap.set('n', '<leader>lc', ':lclose<CR>', { desc = 'Close loclist' })

-- Window spliting
vim.keymap.set('n', '<leader>wv', '<cmd>vsplit<CR>', { desc = 'Split window [V]ertically' })
vim.keymap.set('n', '<leader>wh', '<cmd>split<CR>', { desc = 'Split window [H]orizontally' })
vim.keymap.set('n', '<leader>wq', '<cmd>close<CR>', { desc = '[D]elete current window' })
-- Window Navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', { silent = true })
vim.keymap.set('n', '<C-j>', '<C-w>j', { silent = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { silent = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { silent = true })
-- Quickfix list
vim.keymap.set('n', '<leader>ae', function()
  vim.fn.setqflist({ { text = vim.fn.getline '.' } }, 'a')
  print 'Added to Quickfix List'
end, { noremap = true, silent = true })

-- Terminal exit
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
