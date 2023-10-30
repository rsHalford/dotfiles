local cmd = vim.cmd
local nmap = function(keys, func, desc)
  vim.keymap.set('n', keys, func, { desc = desc })
end

-- zen mode
local zen = require 'zen-mode'

zen.setup {
  window = {
    backdrop = 1,
    width = 80,
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
      showcmd = true,
      wrap = true,
      linebreak = true,
    },
    twilight = { enabled = false },
    gitsigns = { enabled = false },
  },
  on_open = function(_)
    cmd 'cabbrev <buffer> q let b:quitting = 1 <bar> q'
    cmd 'cabbrev <buffer> wq let b:quitting = 1 <bar> wq'
  end,
  on_close = function()
    if vim.b.quitting == 1 then
      vim.b.quitting = 0
      cmd 'q'
    end
  end,
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

-- writing mode
local writingG = vim.api.nvim_create_augroup('Writing', { clear = true })
vim.api.nvim_create_autocmd('VimEnter', {
  group = writingG,
  pattern = { '*.ms', '*.mom', '*.me', '*.man', '*.md', '*.mdx', '*.tex', '*.org', '*.norg', '*.txt' },
  callback = function()
    require('zen-mode').toggle()
  end,
  desc = 'Enter writing mode',
})

nmap('<leader>tw', [[<cmd>lua require('zen-mode').toggle()<CR>]], 'Toggle writing mode')
nmap('<leader>tp', '<cmd>MarkdownPreviewToggle<CR>', 'Toggle markdown preview')
nmap('<leader>ts', '<cmd>set spell!<CR>', 'Toggle spell suggestions')
