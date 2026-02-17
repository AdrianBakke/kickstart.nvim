-- Custom options and keymaps
-- This file is loaded by custom/plugins/init.lua

-- Options
vim.g.have_nerd_font = true
vim.o.mousescroll = 'ver:1'
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.expandtab = true
vim.o.colorcolumn = '150'
vim.o.autoread = true
vim.o.list = false

-- Diagnostic config
vim.diagnostic.config {
  virtual_text = false,
  underline = false,
}

-- Keymaps
-- Select all
vim.keymap.set('n', '<leader>a', 'ggVG', { desc = 'Select all text' })

-- Toggle terminal
local term_buf = nil
local term_win = nil
vim.keymap.set({ 'n', 't' }, '<leader>tt', function()
  if vim.bo.buftype == 'terminal' then
    term_win = nil
    vim.cmd 'hide'
    return
  end

  if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
    vim.cmd 'below split'
    vim.api.nvim_set_current_buf(term_buf)
    vim.cmd 'startinsert'
    term_win = vim.api.nvim_get_current_win()
    return
  end

  vim.cmd 'below split'
  vim.cmd 'terminal'
  term_buf = vim.api.nvim_get_current_buf()
  term_win = vim.api.nvim_get_current_win()
  vim.cmd 'startinsert'
end, { desc = 'Toggle terminal' })
