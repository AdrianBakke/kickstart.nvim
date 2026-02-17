-- Custom plugins and overrides
-- This folder is ignored by kickstart.nvim upstream - no merge conflicts!

-- Load custom options first
require 'custom.options'

return {
  -- Hint.nvim - your AI plugin
  {
    'AdrianBakke/hint.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('hint').setup {
        model = 'codex-mini-latest',
        models = { 'codex-mini-latest', 'gpt-4.1-mini', 'o4-mini' },
        keymaps = {
          prompt = '<C-h>',
          run_comment = '<leader>hr',
          show_last = '<leader>hs',
          model_1 = '<leader>1',
          model_2 = '<leader>2',
          model_3 = '<leader>3',
        },
      }
    end,
  },

  { require 'kickstart.plugins.neo-tree' },

  -- Scrollbar
  {
    'petertriho/nvim-scrollbar',
    config = function()
      require('scrollbar').setup()
    end,
  },

  -- Tokyonight colorscheme with custom settings
  {
    'folke/tokyonight.nvim',
    priority = 1000,
    opts = {
      style = 'night',
      on_colors = function(colors)
        colors.border = '#565f89'
      end,
    },
    init = function()
      vim.cmd.colorscheme 'tokyonight-night'
      vim.api.nvim_set_hl(0, 'Comment', { fg = '#ff82ab' })
    end,
  },

  -- Override telescope with custom keymaps
  {
    'nvim-telescope/telescope.nvim',
    keys = {
      { '<C-p>', '<cmd>Telescope find_files<cr>', desc = 'Find files' },
      { '<C-n>', '<cmd>Telescope live_grep<cr>', desc = 'Live grep' },
    },
  },

  -- Override mini.surround mappings
  {
    'echasnovski/mini.nvim',
    opts = function(_, opts)
      opts = opts or {}
      return opts
    end,
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup {
        mappings = {
          add = '<leader>sa',
          delete = '<leader>sd',
          replace = '<leader>sr',
          find = '',
          find_left = '',
          highlight = '',
          update_n_lines = '',
          suffix_last = '',
          suffix_next = '',
        },
      }
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },

  -- Custom LSP servers
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        clangd = {},
        pyright = {},
        ts_ls = {},
        html = {},
        cssls = {},
        hls = {
          cmd = { 'haskell-language-server-wrapper', '--lsp' },
          settings = {
            haskell = {
              formattingProvider = 'ormolu',
            },
          },
        },
      },
    },
  },
}
