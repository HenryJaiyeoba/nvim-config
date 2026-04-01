-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>n', '<cmd>nohlsearch<CR>')

-- Better exit from insert mode
vim.keymap.set('i', 'jk', '<Esc>')
vim.keymap.set('v', 'jk', '<Esc>')

local function notify(message, level)
  vim.notify(message, level or vim.log.levels.INFO, { title = 'Keymaps' })
end

local function current_location_item()
  local cursor = vim.api.nvim_win_get_cursor(0)
  return {
    filename = vim.api.nvim_buf_get_name(0),
    lnum = cursor[1],
    col = cursor[2] + 1,
    text = vim.api.nvim_get_current_line(),
  }
end

local function is_quickfix_open()
  for _, win in ipairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 and win.loclist == 0 then
      return true
    end
  end
  return false
end

local function is_loclist_open()
  return vim.fn.getloclist(0, { winid = 0 }).winid ~= 0
end

local function toggle_quickfix()
  if is_quickfix_open() then
    vim.cmd 'cclose'
  else
    vim.cmd 'copen'
  end
end

local function toggle_loclist()
  if is_loclist_open() then
    vim.cmd 'lclose'
  else
    vim.cmd 'lopen'
  end
end

local function add_to_quickfix()
  vim.fn.setqflist({ current_location_item() }, 'a')
  notify 'Added current location to quickfix'
end

local function add_to_loclist()
  vim.fn.setloclist(0, { current_location_item() }, 'a')
  notify 'Added current location to loclist'
end

local function clear_quickfix()
  vim.fn.setqflist({}, 'r')
  notify 'Cleared quickfix'
end

local function clear_loclist()
  vim.fn.setloclist(0, {}, 'r')
  notify 'Cleared loclist'
end

local function diagnostics_to_quickfix(scope)
  vim.diagnostic.setqflist(scope and { scope = scope } or nil)
  vim.cmd 'copen'
end

local function diagnostics_to_loclist(scope)
  vim.diagnostic.setloclist(scope and { scope = scope } or nil)
  vim.cmd 'lopen'
end

local function loclist_to_quickfix()
  local items = vim.fn.getloclist(0)
  vim.fn.setqflist({}, 'r', { items = items })
  vim.cmd 'copen'
end

local function quickfix_to_loclist()
  local items = vim.fn.getqflist()
  vim.fn.setloclist(0, {}, 'r', { items = items })
  vim.cmd 'lopen'
end

local function remove_current_list_item(kind)
  local info = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  if not info or info.quickfix ~= 1 then
    notify('Focus the ' .. kind .. ' window to remove an item', vim.log.levels.WARN)
    return
  end

  if kind == 'quickfix' and info.loclist == 1 then
    notify('Focus the quickfix window to remove an item', vim.log.levels.WARN)
    return
  end

  if kind == 'loclist' and info.loclist == 0 then
    notify('Focus the loclist window to remove an item', vim.log.levels.WARN)
    return
  end

  local index = vim.fn.line '.'
  if kind == 'quickfix' then
    local items = vim.fn.getqflist()
    table.remove(items, index)
    vim.fn.setqflist({}, 'r', { items = items })
  else
    local items = vim.fn.getloclist(0)
    table.remove(items, index)
    vim.fn.setloclist(0, {}, 'r', { items = items })
  end
  notify('Removed ' .. kind .. ' item')
end

local function goto_diag(next, severity)
  local jump = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  jump { severity = severity }
end

-- Diagnostics, quickfix, and loclist navigation
vim.keymap.set('n', ']q', '<cmd>cnext<CR>', { desc = 'Quickfix next' })
vim.keymap.set('n', '[q', '<cmd>cprev<CR>', { desc = 'Quickfix previous' })
vim.keymap.set('n', ']l', '<cmd>lnext<CR>', { desc = 'Loclist next' })
vim.keymap.set('n', '[l', '<cmd>lprev<CR>', { desc = 'Loclist previous' })
vim.keymap.set('n', ']d', function()
  goto_diag(true)
end, { desc = 'Diagnostic next' })
vim.keymap.set('n', '[d', function()
  goto_diag(false)
end, { desc = 'Diagnostic previous' })
vim.keymap.set('n', ']e', function()
  goto_diag(true, vim.diagnostic.severity.ERROR)
end, { desc = 'Error next' })
vim.keymap.set('n', '[e', function()
  goto_diag(false, vim.diagnostic.severity.ERROR)
end, { desc = 'Error previous' })
vim.keymap.set('n', ']w', function()
  goto_diag(true, vim.diagnostic.severity.WARN)
end, { desc = 'Warning next' })
vim.keymap.set('n', '[w', function()
  goto_diag(false, vim.diagnostic.severity.WARN)
end, { desc = 'Warning previous' })

-- Quickfix actions
vim.keymap.set('n', '<leader>qo', '<cmd>copen<CR>', { desc = 'Quickfix open' })
vim.keymap.set('n', '<leader>qc', '<cmd>cclose<CR>', { desc = 'Quickfix close' })
vim.keymap.set('n', '<leader>qt', toggle_quickfix, { desc = 'Quickfix toggle' })
vim.keymap.set('n', '<leader>qa', add_to_quickfix, { desc = 'Quickfix add location' })
vim.keymap.set('n', '<leader>qd', function()
  remove_current_list_item 'quickfix'
end, { desc = 'Quickfix remove item' })
vim.keymap.set('n', '<leader>qr', clear_quickfix, { desc = 'Quickfix clear' })
vim.keymap.set('n', '<leader>qb', function()
  diagnostics_to_quickfix 'buffer'
end, { desc = 'Buffer diagnostics to quickfix' })
vim.keymap.set('n', '<leader>qw', function()
  diagnostics_to_quickfix()
end, { desc = 'Workspace diagnostics to quickfix' })
vim.keymap.set('n', '<leader>ql', loclist_to_quickfix, { desc = 'Loclist to quickfix' })

-- Loclist actions
vim.keymap.set('n', '<leader>lo', '<cmd>lopen<CR>', { desc = 'Loclist open' })
vim.keymap.set('n', '<leader>lc', '<cmd>lclose<CR>', { desc = 'Loclist close' })
vim.keymap.set('n', '<leader>lt', toggle_loclist, { desc = 'Loclist toggle' })
vim.keymap.set('n', '<leader>la', add_to_loclist, { desc = 'Loclist add location' })
vim.keymap.set('n', '<leader>ld', function()
  remove_current_list_item 'loclist'
end, { desc = 'Loclist remove item' })
vim.keymap.set('n', '<leader>lr', clear_loclist, { desc = 'Loclist clear' })
vim.keymap.set('n', '<leader>lb', function()
  diagnostics_to_loclist 'buffer'
end, { desc = 'Buffer diagnostics to loclist' })
vim.keymap.set('n', '<leader>lq', quickfix_to_loclist, { desc = 'Quickfix to loclist' })

-- Diagnostics actions
vim.keymap.set('n', '<leader>dd', function()
  vim.diagnostic.open_float(nil, { focus = false })
end, { desc = 'Line diagnostics' })
vim.keymap.set('n', '<leader>dl', function()
  diagnostics_to_loclist 'buffer'
end, { desc = 'Buffer diagnostics list' })
vim.keymap.set('n', '<leader>dq', function()
  diagnostics_to_quickfix()
end, { desc = 'Workspace diagnostics list' })

-- Window spliting
vim.keymap.set('n', '<leader>wv', '<cmd>vsplit<CR>', { desc = 'Split window [V]ertically' })
vim.keymap.set('n', '<leader>wh', '<cmd>split<CR>', { desc = 'Split window [H]orizontally' })
vim.keymap.set('n', '<leader>wq', '<cmd>close<CR>', { desc = '[D]elete current window' })
-- Window Navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', { silent = true })
vim.keymap.set('n', '<C-j>', '<C-w>j', { silent = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { silent = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { silent = true })

-- Terminal exit
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
