-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'AdrianBakke/hint.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local hint = require 'hint'
      vim.keymap.set({ 'n', 'v' }, '<C-j>', hint.toggle_window, { desc = 'Open HINT Window' })
      vim.keymap.set({ 'n', 'v' }, '<leader>1', hint.openai_chat_completion, { desc = 'OpenAI Chat Completion' })
      vim.keymap.set({ 'n', 'v' }, '<leader>2', hint.openai_chat_completion_reasoner, { desc = 'OpenAI Chat Completion Reasoner' })
      vim.keymap.set({ 'n', 'v' }, '<leader>3', hint.deepseek_chat_completion, { desc = 'DeepSeek Chat Completion Reasoner' })
    end,
  },
}
