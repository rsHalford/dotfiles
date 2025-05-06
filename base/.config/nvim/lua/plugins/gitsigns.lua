return {
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      signcolumn = false,
      numhl = true,
      current_line_blame = true,
      trouble = true,
    },
    keys = {
      { '<leader>gb', [[<cmd>lua require('gitsigns').blame_line({full = true})<CR>]], { desc = 'Git blame' } },
      { '<leader>gd', [[<cmd>lua require('gitsigns').toggle_linehl() require('gitsigns').toggle_deleted()<CR>]], { desc = 'Git diff' } },
    },
  },
}

-- vim: ts=2 sts=2 sw=2 et
