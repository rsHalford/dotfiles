-- zen mode
local zen = require 'zen-mode'

zen.setup {
  window = {
    backdrop = 1,
    width = 70,
    height = 0.8,
    options = {
      number = false,
      relativenumber = false,
      cursorline = false,
      cursorcolumn = false,
    },
  },
  plugins = {
    options = {
      enabled = true,
      ruler = true,
      showcmd = false,
    },
    twilight = { enabled = true },
    gitsigns = { enabled = false },
  },
  -- on_open = function(_)
  --   vim.cmd 'cabbrev <buffer> q let b:quitting = 1 <bar> q'
  --   vim.cmd 'cabbrev <buffer> wq let b:quitting = 1 <bar> wq'
  -- end,
  -- on_close = function()
  --   if vim.b.quitting == 1 then
  --     vim.b.quitting = 0
  --     vim.cmd 'q'
  --   end
  -- end,
}

-- twilight
local twilight = require 'twilight'

twilight.setup {
  dimming = {
    alpha = 0.3,
  },
  context = 0,
}

-- markdown preview
local g = vim.g

g.mkdp_auto_start = 0
g.mkdp_auto_close = 0
g.mkdp_refresh_slow = 0
g.mkdp_command_for_global = 0
g.mkdp_open_to_the_world = 0
g.mkdp_filetypes = { 'markdown' }

local proseG = vim.api.nvim_create_augroup('Prose', { clear = true })
vim.api.nvim_create_autocmd('VimEnter', {
  group = proseG,
  pattern = { '*.ms', '*.mom', '*.me', '.man', '*.md', '*.tex', '*.org', '*.norg', '*.txt' },
  callback = function()
    require('zen-mode').toggle({
      plugins = {
        options = {
          wrap = true,
          linebreak = true,
        },
      },
    })
    vim.opt.spell = true
  end, desc = 'Enter Prose writing mode'
})

vim.keymap.set('n', '<leader>tp', [[<cmd>lua require('zen-mode').toggle()<CR>]], { desc = 'Toggle Zen Mode' })
