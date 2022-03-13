-- Colorizer
local colorizer = require 'colorizer'

colorizer.setup({
  'css',
  'javascript',
  'vim',
  'html',
  'vue',
  'svelte',
}, {
  mode = 'background',
  css = true,
})

-- nvim-tree
local g = vim.g
local keymap = vim.api.nvim_set_keymap

keymap('n', '<leader>b', [[<cmd>NvimTreeToggle<CR>]], { noremap = true, silent = true })

g.nvim_tree_git_hl = 1
g.nvim_tree_group_empty = 1
g.nvim_tree_symlink_arrow = ' -> '
g.nvim_tree_respect_buf_cwd = 1
g.nvim_tree_show_icons = {
  ['git'] = 1,
  ['files'] = 1,
  ['folders'] = 1,
  ['folder_arrows'] = 1,
}
g.nvim_tree_icons = {
  ['default'] = '',
  ['symlink'] = '',
  ['git'] = {
    ['unstaged'] = '',
    ['staged'] = '',
    ['unmerged'] = '',
    ['renamed'] = '',
    ['untracked'] = '',
    ['deleted'] = '',
    ['ignored'] = '',
  },
  ['folder'] = {
    ['arrow_open'] = '',
    ['arrow_closed'] = '',
    ['default'] = '',
    ['open'] = '',
    ['empty'] = '',
    ['empty_open'] = '',
    ['symlink'] = '',
    ['symlink_open'] = '',
  },
}

local ntree = require 'nvim-tree'

ntree.setup {
  actions = {
    open_file = {
      quit_on_open = true,
    },
  },
  disable_netrw = false,
  open_on_setup = true,
  ignore_ft_on_setup = { 'vim' },
  hijack_cursor = true,
  diagnostics = {
    enable = true,
  },
  view = {
    width = 20,
    height = 8,
    side = 'right',
    auto_resize = true,
  },
  git = {
    ignore = true,
  },
}

-- lualine
local lualine = require 'lualine'

lualine.setup {
  options = {
    theme = 'gruvbox_dark',
    section_separators = '',
    component_separators = '',
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { { 'diagnostics', sources = { 'nvim_diagnostic' } } },
    lualine_c = { 'filename' },
    lualine_x = { 'diff', 'branch' },
    lualine_y = { 'filetype' },
    lualine_z = { 'progress' },
  },
  extensions = {
    'fugitive',
    'fzf',
    'nvim-tree',
    'toggleterm',
  },
}
