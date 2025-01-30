-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'AdrianBakke/dingllm.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local dingllm = require 'dingllm'
      vim.keymap.set({ 'n', 'v' }, '<leader>o', dingllm.openai_chat_completion, { desc = 'OpenAI Chat Completion' })
      vim.keymap.set({ 'n', 'v' }, '<leader>k', dingllm.deepseek_chat_completion, { desc = 'DeepSeek Chat Completion' })
    end,
  },
}
