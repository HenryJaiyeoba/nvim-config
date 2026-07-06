-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>n', '<cmd>nohlsearch<CR>')

-- Better exit from insert mode
vim.keymap.set('i', 'jk', '<Esc>')
vim.keymap.set('v', 'jk', '<Esc>')

-- Paste over a selection without replacing the last yank
vim.keymap.set('x', 'p', '"_dP')

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

local function clamp(value, min_value, max_value)
  return math.min(math.max(value, min_value), max_value)
end

local function get_visual_range()
  local start_line = vim.fn.getpos('v')[2]
  local end_line = vim.api.nvim_win_get_cursor(0)[1]
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end
  return start_line, end_line
end

local function move_range(start_line, end_line, target_start)
  local buf = 0
  local total_lines = vim.api.nvim_buf_line_count(buf)
  local count = end_line - start_line + 1
  local max_start = math.max(1, total_lines - count + 1)
  local clamped_target = clamp(target_start, 1, max_start)

  if start_line == clamped_target and end_line == clamped_target + count - 1 then
    return start_line, end_line
  end

  local lines = vim.api.nvim_buf_get_lines(buf, start_line - 1, end_line, false)
  vim.api.nvim_buf_set_lines(buf, start_line - 1, end_line, false, {})
  vim.api.nvim_buf_set_lines(buf, clamped_target - 1, clamped_target - 1, false, lines)

  return clamped_target, clamped_target + count - 1
end

local function restore_visual_selection(start_line, end_line, reindent)
  vim.fn.setpos("'<", { 0, start_line, 1, 0 })
  vim.fn.setpos("'>", { 0, end_line, 1, 0 })
  vim.api.nvim_win_set_cursor(0, { start_line, 0 })
  if reindent then
    vim.cmd 'normal! gv=gv'
  else
    vim.cmd 'normal! gv'
  end
end

local function move_current_line(delta)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line = cursor[1]
  local total_lines = vim.api.nvim_buf_line_count(0)
  local target = clamp(line + delta, 1, total_lines)
  local new_start = move_range(line, line, target)
  vim.api.nvim_win_set_cursor(0, { new_start, cursor[2] })
end

local function move_visual_selection(delta)
  local start_line, end_line = get_visual_range()
  local total_lines = vim.api.nvim_buf_line_count(0)
  local count = end_line - start_line + 1
  local max_start = math.max(1, total_lines - count + 1)
  local target = clamp(start_line + delta, 1, max_start)
  local new_start, new_end = move_range(start_line, end_line, target)
  restore_visual_selection(new_start, new_end, true)
end

local function prompt_move_target(default_line, max_start)
  local input = vim.trim(vim.fn.input(('Move to line (1-%d or 20j/20k): '):format(max_start), tostring(default_line)))
  if input == '' then
    return nil
  end

  local relative_count, relative_direction = input:match('^(%d+)([jk])$')
  if relative_count and relative_direction then
    local delta = tonumber(relative_count)
    if relative_direction == 'k' then
      delta = -delta
    end
    return clamp(default_line + delta, 1, max_start)
  end

  local signed_delta = input:match('^([+-]%d+)$')
  if signed_delta then
    return clamp(default_line + tonumber(signed_delta), 1, max_start)
  end

  local target = tonumber(input)
  if target then
    return clamp(math.floor(target), 1, max_start)
  end

  notify('Enter a line number, +N/-N, or Nj/Nk', vim.log.levels.WARN)
  return nil
end

local function move_current_line_to_line()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line = cursor[1]
  local total_lines = vim.api.nvim_buf_line_count(0)
  local target = prompt_move_target(line, total_lines)
  if not target then
    return
  end

  local new_start = move_range(line, line, target)
  vim.api.nvim_win_set_cursor(0, { new_start, cursor[2] })
end

local function move_visual_selection_to_line()
  local start_line, end_line = get_visual_range()
  local total_lines = vim.api.nvim_buf_line_count(0)
  local count = end_line - start_line + 1
  local max_start = math.max(1, total_lines - count + 1)
  local target = prompt_move_target(start_line, max_start)
  if not target then
    return
  end

  local new_start, new_end = move_range(start_line, end_line, target)
  restore_visual_selection(new_start, new_end, false)
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

-- Move lines and selections
vim.keymap.set('n', '<A-j>', function()
  move_current_line(1)
end, { desc = 'Move line down' })
vim.keymap.set('n', '<A-k>', function()
  move_current_line(-1)
end, { desc = 'Move line up' })
vim.keymap.set('x', '<A-j>', function()
  move_visual_selection(1)
end, { desc = 'Move selection down' })
vim.keymap.set('x', '<A-k>', function()
  move_visual_selection(-1)
end, { desc = 'Move selection up' })
vim.keymap.set('n', '<leader>mj', function()
  move_current_line(1)
end, { desc = 'Move line down' })
vim.keymap.set('n', '<leader>mk', function()
  move_current_line(-1)
end, { desc = 'Move line up' })
vim.keymap.set('x', '<leader>mj', function()
  move_visual_selection(1)
end, { desc = 'Move selection down' })
vim.keymap.set('x', '<leader>mk', function()
  move_visual_selection(-1)
end, { desc = 'Move selection up' })
vim.keymap.set('n', '<leader>ml', move_current_line_to_line, { desc = 'Move line to line' })
vim.keymap.set('x', '<leader>ml', move_visual_selection_to_line, { desc = 'Move selection to line' })

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
