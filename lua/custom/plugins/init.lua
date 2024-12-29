-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  -- {
  --   'amitds1997/remote-nvim.nvim',
  --   version = '*', -- Pin to GitHub releases
  --   dependencies = {
  --     'nvim-lua/plenary.nvim', -- For standard functions
  --     'MunifTanjim/nui.nvim', -- To build the plugin UI
  --     'nvim-telescope/telescope.nvim', -- For picking between different remote methods
  --   },
  --   config = function()
  --     require('remote-nvim').setup {
  --       server = 'localhost',
  --       port = 8765,
  --       -- additional configuration options
  --     }
  --   end,
  -- },

  -- {
  --   'yetone/avante.nvim',
  --   event = 'VeryLazy',
  --   build = 'make',
  --   opts = {
  --     -- Add any additional options here
  --   },
  --   dependencies = {
  --     'nvim-tree/nvim-web-devicons',
  --     'echasnovski/mini.icons',
  --     'stevearc/dressing.nvim',
  --     'nvim-lua/plenary.nvim',
  --     'MunifTanjim/nui.nvim',
  --     {
  --       'MeanderingProgrammer/render-markdown.nvim',
  --       opts = {
  --         file_types = { 'markdown', 'Avante' },
  --       },
  --       ft = { 'markdown', 'Avante' },
  --     },
  --   },
  --   config = function()
  --     require('avante').setup {
  --       provider = 'openai',
  --       openai = {
  --         endpoint = 'https://api.openai.com/v1',
  --         model = 'gpt-4o', -- Replace with the desired OpenAI model
  --         timeout = 30000,
  --         temperature = 0.7,
  --         max_tokens = 4096,
  --       },
  --       mappings = {
  --         ask = '<leader>aa',
  --         edit = '<leader>ae',
  --         refresh = '<leader>ar',
  --         diff = {
  --           ours = 'co',
  --           theirs = 'ct',
  --           none = 'c0',
  --           both = 'cb',
  --           next = ']x',
  --           prev = '[x',
  --         },
  --         jump = {
  --           next = ']]',
  --           prev = '[[',
  --         },
  --         submit = {
  --           normal = '<CR>',
  --           insert = '<C-s>',
  --         },
  --         toggle = {
  --           debug = '<leader>ad',
  --           hint = '<leader>ah',
  --         },
  --       },
  --       hints = { enabled = true },
  --       windows = {
  --         wrap = true, -- Similar to vim.o.wrap
  --         width = 30, -- Default percentage based on available width
  --         sidebar_header = {
  --           align = 'center', -- 'left', 'center', 'right' for title alignment
  --           rounded = true,
  --         },
  --       },
  --       highlights = {
  --         diff = {
  --           current = 'DiffText',
  --           incoming = 'DiffAdd',
  --         },
  --       },
  --       diff = {
  --         debug = false,
  --         autojump = true,
  --         list_opener = 'copen',
  --       },
  --     }
  --   end,
  -- },
  -- {
  --   'goerz/jupytext.vim',
  --   config = function()
  --     vim.g.jupytext_fmt = 'py:percent'
  --   end,
  -- },
  --
  -- {
  --   dir = '~/newton/.config/nvim/lua/custom/plugins/interact-assistant.lua', -- Update with the correct path
  --   config = function()
  --     require('interact-assistant').setup()
  --   end,
  -- },
  {
    'yacineMTB/dingllm.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local dingllm = require 'dingllm'
      --
      -- Function to handle the response from OpenAI
      local function handle_openai_spec_data(data_stream, event)
        if data_stream == '[DONE]' then
          print 'Stream complete'
          dingllm.write_string_at_cursor '\n'
        end

        -- Attempt to decode the JSON data
        local success, json = pcall(vim.json.decode, data_stream)

        -- If successful, process the content
        if success then
          -- Handle streamed completion where "delta" contains the content
          if json.choices and json.choices[1] and json.choices[1].delta then
            local content = json.choices[1].delta.content
            if content and content ~= '' then
              -- Write the streamed content chunk to the editor
              dingllm.write_string_at_cursor(content)
            end
          elseif json.choices and json.choices[1] and json.choices[1].text then
            -- This handles non-streamed completions
            local content = json.choices[1].text
            if content then
              -- Write the non-streamed content to the editor
              dingllm.write_string_at_cursor(content)
            end
          else
            -- Handle cases with no content (if needed)
            print 'No content found in the response'
          end
        else
          -- Debugging: Print the failed response for further inspection
          print('Failed to parse JSON response:', data_stream)
        end
      end

      -- Function to create the curl arguments for OpenAI requests
      local function custom_make_openai_spec_curl_args(opts, prompt)
        print 'Creating curl arguments' -- Debugging: Check if this function is called
        local url = opts.url
        local api_key = os.getenv 'OPENAI_API_KEY'
        if not api_key then
          print 'API key not found' -- Debugging: Check if the API key is set
        end

        local data = {
          messages = {
            {
              role = 'system',
              content = 'You are HINT (Higher INTelligence) the most intelligent computer in the world. God given you the ability to remember the 10 last prompts. You go straight to the answer',
            },
            { role = 'user', content = prompt }, -- Replace with actual input from Neovim
          },
          model = opts.model,
          temperature = 0.7,
          stream = true,
        }
        local args = { '-N', '-X', 'POST', '-H', 'Content-Type: application/json', '-d', vim.json.encode(data) }
        if api_key then
          table.insert(args, '-H')
          table.insert(args, 'Authorization: Bearer ' .. api_key)
        end
        table.insert(args, url)
        return args
      end

      -- local function custom_make_openai_spec_curl_args_completions(opts, prompt)
      --   print 'Creating curl arguments' -- Debugging: Check if this function is called
      --   local url = opts.url
      --   local api_key = os.getenv 'OPENAI_API_KEY'
      --   if not api_key then
      --     print 'API key not found' -- Debugging: Check if the API key is set
      --   end
      --
      --   local data = {
      --     prompt = { 'You are terence mckenna the American ethnobotanist and mystic ' .. prompt },
      --     model = opts.model,
      --     temperature = 0.7,
      --     stream = true,
      --   }
      --   local args = { '-N', '-X', 'POST', '-H', 'Content-Type: application/json', '-d', vim.json.encode(data) }
      --   if api_key then
      --     table.insert(args, '-H')
      --     table.insert(args, 'Authorization: Bearer ' .. api_key)
      --   end
      --   table.insert(args, url)
      --   return args
      -- end

      -- -- Function to invoke OpenAI completion
      -- local function openai_completion()
      --   print 'Invoking OpenAI completion' -- Debugging: Check if the function is being called
      --   dingllm.invoke_llm_and_stream_into_editor({
      --     url = 'https://api.openai.com/v1/completions',
      --     model = 'gpt-4-turbo', -- Replace with your desired model, e.g., 'gpt-3.5-turbo' or 'gpt-4'
      --     max_tokens = 150,
      --     replace = true,
      --   }, custom_make_openai_spec_curl_args_completions, handle_openai_spec_data)
      -- end

      -- Function to invoke OpenAI chat-based completion
      local function openai_chat_completion()
        print 'Invoking OpenAI chat completion' -- Debugging: Check if the function is being called
        vim.api.nvim_put({ '' }, 'l', true, true)
        dingllm.invoke_llm_and_stream_into_editor({
          url = 'https://api.openai.com/v1/chat/completions',
          model = 'gpt-4o', -- Replace with your desired chat model
          max_tokens = 150,
          replace = true,
        }, custom_make_openai_spec_curl_args, handle_openai_spec_data)
      end

      -- vim.keymap.set({ 'n', 'v' }, '<leader>o', openai_completion, { desc = 'OpenAI Text Completion' })
      vim.keymap.set({ 'n', 'v' }, '<leader>o', openai_chat_completion, { desc = 'OpenAI Chat Completion' })
      --vim.keymap.set({ 'n', 'v' }, '<leader>o', '<cmd>openai_chat_completion()<CR>', { desc = 'OpenAI Chat Completion' })

      print 'Finished setting up key mappings' -- Debugging: Configuration is complete
    end,
  },
}
