return {
  'folke/trouble.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local tb = require 'trouble'

    vim.keymap.set('n', '<leader>wd', function()
      tb.toggle 'workspace_diagnostics'
    end, { desc = '[W]orkspace [D]iagnostics' })

    vim.keymap.set('n', '<leader>dd', function()
      tb.toggle 'document_diagnostics'
    end, { desc = '[D]ocument [D]iagnostics' })

    vim.keymap.set('n', '<leader>q', function()
      tb.toggle 'quickfix'
    end, { desc = '[Q]uickfix' })

    vim.keymap.set('n', '<leader>l', function()
      tb.toggle 'loclist'
    end, { desc = '[L]oclist' })
  end,
}

-- vim: ts=2 sts=2 sw=2 et
