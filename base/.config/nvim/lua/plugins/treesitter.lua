return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-context',
      'nvim-treesitter/nvim-treesitter-textobjects',
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup {
        ensure_installed = { 'bash', 'c', 'html', 'lua', 'markdown', 'vim', 'vimdoc' },
        auto_install = true,
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,
          disable = { 'python' },
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = '<C-space>',
            node_incremental = '<C-space>',
            scope_incremental = '<C-s>',
            node_decremental = '<C-backspace>',
          },
        },
        rainbow = {
          enable = true,
          extended_mode = true,
          max_file_lines = nil,
        },
        autotag = {
          enable = true,
        },
        textobjects = {
          include_surrounding_whitespace = true,
          select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ['aa'] = { query = '@parameter.outer', desc = 'Select outer part of parameter' },
              ['ia'] = { query = '@parameter.inner', desc = 'Select inner part of parameter' },
              ['af'] = { query = '@function.outer', desc = 'Select outer part of function' },
              ['if'] = { query = '@function.inner', desc = 'Select inner part of function' },
              ['ac'] = { query = '@class.outer', desc = 'Select outer part of class' },
              ['ic'] = { query = '@class.inner', desc = 'Select inner part of class' },
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              [']m'] = { query = '@function.outer', desc = 'Next function start' },
              [']]'] = { query = '@class.outer', desc = 'Next class start' },
            },
            goto_next_end = {
              [']M'] = { query = '@function.outer', desc = 'Next function end' },
              [']['] = { query = '@class.outer', desc = 'Next class end' },
            },
            goto_previous_start = {
              ['[m'] = { query = '@function.outer', desc = 'Prev function start' },
              ['[['] = { query = '@class.outer', desc = 'Prev class start' },
            },
            goto_previous_end = {
              ['[M'] = { query = '@function.outer', desc = 'Prev function end' },
              ['[]'] = { query = '@class.outer', desc = 'Prev class end' },
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ['<leader>a'] = '@parameter.inner',
            },
            swap_previous = {
              ['<leader>A'] = '@parameter.inner',
            },
          },
        },
      }

      require('treesitter-context').setup {
        max_lines = 3,
      }
      vim.api.nvim_set_keymap('n', '<leader>tc', [[<cmd>TSContextToggle<CR>]], { noremap = true, silent = true, desc = '[T]reesitter [C]ontext' })
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
