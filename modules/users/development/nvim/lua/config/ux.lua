local g = vim.g
local keymap = vim.api.nvim_set_keymap

-- Colorizer
local colorizer = require 'colorizer'

colorizer.setup({
  'css',
  'javascript',
  'vim',
  'html',
}, {
  mode = 'background',
  css = true,
})

-- nvim-tree
keymap('n', '<leader>b', [[<cmd>NvimTreeToggle<CR>]], { noremap = true, silent = true })

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
  renderer = {
    highlight_git = true,
    group_empty = true,
    icons = {
      glyphs = {
        default = '',
        symlink = '',
        git = {
          unstaged = '',
          staged = '',
          unmerged = '',
          renamed = '',
          untracked = '',
          deleted = '',
          ignored = '',
        },
        folder = {
          arrow_open = '',
          arrow_closed = '',
          default = '',
          open = '',
          empty = '',
          empty_open = '',
          symlink = '',
          symlink_open = '',
        },
      },
      symlink_arrow = ' -> ',
      show = {
        file = true,
	      folder = true,
	      folder_arrow = true,
	      git = true,
      },
    },
  },
  respect_buf_cwd = true,
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

-- Comment
local comment = require 'Comment'

comment.setup {
  ignore = '^$',
  mappings = {
    extended = true,
  },
}

-- autopairs
local npairs = require 'nvim-autopairs'

npairs.setup {
  disable_in_macro = true,
  check_ts = true,
}
