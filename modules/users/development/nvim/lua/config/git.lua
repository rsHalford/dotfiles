local nmap = function(keys, func, desc, silent)
  vim.keymap.set('n', keys, func, { noremap = true, desc = desc, silent = silent })
end

nmap('<leader>gh', ':diffget //2<CR>')
nmap('<leader>gl', ':diffget //3<CR>')
nmap(
  '<leader>td',
  [[<cmd>lua require('gitsigns').toggle_linehl() require('gitsigns').toggle_deleted()<CR>]],
  'Toggle Diff View'
)

local gitsigns = require 'gitsigns'

gitsigns.setup {
  numhl = true,
  signcolumn = false,
}

local neogit = require 'neogit'

neogit.setup {}

nmap('<leader>ng', [[<cmd>lua require('neogit').open()<CR>]], 'Open NeoGit')
