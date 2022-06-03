local keymap = vim.api.nvim_set_keymap
local g = vim.g

keymap('n', '<leader>gh', ':diffget //2<CR>', { noremap = true })
keymap('n', '<leader>gl', ':diffget //3<CR>', { noremap = true })

require('gitsigns').setup {
  numhl = true,
  signcolumn = false,
}
