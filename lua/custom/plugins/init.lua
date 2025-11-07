return {
  {
    'AdrianBakke/hint.nvim',
    branch = 'insert_functionality',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local hint = require 'hint'
      vim.keymap.set({ 'n', 'v' }, '<C-h>', hint.ui.toggle_window, { desc = 'Open HINT Window' })
      vim.keymap.set({ 'n', 'v' }, '<leader>1', hint.api.openai_chat_completion, { desc = 'OpenAI Chat Completion' })
      vim.keymap.set({ 'n', 'v' }, '<leader>2', hint.api.openai_chat_completion_reasoner, { desc = 'OpenAI Chat Completion Reasoner' })
      vim.keymap.set({ 'n', 'v' }, '<leader>3', hint.api.deepseek_chat_completion, { desc = 'DeepSeek Chat Completion Reasoner' })
    end,
  },
  {
    'petertriho/nvim-scrollbar',
    config = function()
      require('scrollbar').setup()
    end,
  },
}
