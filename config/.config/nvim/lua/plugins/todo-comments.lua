return {
  -- Highlight todo, notes, etc in comments
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
    keys = {
      { '<leader>wc', '<cmd>TodoTrouble<CR>', { desc = '[W]orkspac [C]omments' } },
      {
        ']t',
        function()
          require('todo-comments').jump_next()
        end,
        { desc = 'Next todo comment' },
      },
      {
        '[t',
        function()
          require('todo-comments').jump_prev()
        end,
        { desc = 'Previous todo comment' },
      },
    },
  },
}

-- vim: ts=2 sts=2 sw=2 et
