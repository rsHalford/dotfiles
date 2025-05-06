return {
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'sindrets/diffview.nvim', -- optional - Diff integration
      -- Only one of these is needed, not both.
      'nvim-telescope/telescope.nvim', -- optional
      -- "ibhagwan/fzf-lua",              -- optional
    },
    config = function()
      local neogit = require 'neogit'
      neogit.setup {}
      vim.keymap.set('n', '<leader>gs', require('neogit').open, { desc = 'Git status' })
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
