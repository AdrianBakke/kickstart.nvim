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
      vim.keymap.set({ 'n', 'v' }, '<leader>o', hint.openai_chat_completion, { desc = 'OpenAI Chat Completion' })
      vim.keymap.set({ 'n', 'v' }, '<leader>k', hint.deepseek_chat_completion, { desc = 'DeepSeek Chat Completion' })
      vim.keymap.set({ 'n', 'v' }, '<leader>h', hint.open_window, { desc = 'Open HINT Window' })
    end,
  },
}
