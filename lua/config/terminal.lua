local state = {
  buf = nil,
  win = nil,
}

local function create_float()
  local width = math.floor(vim.o.columns * 0.85)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  if not state.buf or not vim.api.nvim_buf_is_valid(state.buf) then
    state.buf = vim.api.nvim_create_buf(false, true)
  end

  state.win = vim.api.nvim_open_win(state.buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
    title = ' Terminal ',
    title_pos = 'center',
  })

  vim.wo[state.win].number = false
  vim.wo[state.win].relativenumber = false
end

local function toggle_terminal()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_hide(state.win)
    state.win = nil
    return
  end

  create_float()

  if vim.bo[state.buf].buftype ~= 'terminal' then
    vim.cmd.terminal()
    vim.bo[state.buf].buflisted = false
  end

  vim.cmd.startinsert()
end

vim.api.nvim_create_user_command('FloatTerm', toggle_terminal, {
  desc = 'Toggle floating terminal',
})

vim.keymap.set({ 'n', 't' }, '<leader>tf', toggle_terminal, {
  desc = 'Toggle floating terminal',
})
