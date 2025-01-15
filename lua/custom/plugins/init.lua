-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'yacineMTB/dingllm.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local dingllm = require 'dingllm'

      local function handle_openai_spec_data(data_stream, event)
        -- Attempt to decode the JSON data
        local success, json = pcall(vim.json.decode, data_stream)

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
              dingllm.write_string_at_cursor(content)
            end
          else
            print 'No content found in the response'
          end
        elseif data_stream == '[DONE]' then
          dingllm.write_string_at_cursor '\n'
          print 'Stream complete'
        else
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

      -- Function to invoke OpenAI chat-based completion
      local function openai_chat_completion()
        print 'Invoking OpenAI chat completion' -- Debugging: Check if the function is being called
        vim.api.nvim_command 'normal! o'
        dingllm.write_string_at_cursor '\n'
        dingllm.invoke_llm_and_stream_into_editor({
          url = 'https://api.openai.com/v1/chat/completions',
          model = 'gpt-4o', -- Replace with your desired chat model
          max_tokens = 150,
          --replace = true,
        }, custom_make_openai_spec_curl_args, handle_openai_spec_data)
      end

      vim.keymap.set({ 'n', 'v' }, '<leader>o', openai_chat_completion, { desc = 'OpenAI Chat Completion' })

      print 'Finished setting up key mappings' -- Debugging: Configuration is complete
    end,
  },
}
