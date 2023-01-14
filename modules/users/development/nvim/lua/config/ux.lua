local cmd = vim.cmd
local keymap = vim.api.nvim_set_keymap

-- Rose Pine
local rpine = require 'rose-pine'

rpine.setup {
  dark_variant = 'moon',
  disable_background = false,
  disable_float_background = false,
  dim_nc_background = false,
}

cmd 'colorscheme rose-pine'

-- Colorizer
local colorizer = require 'colorizer'

colorizer.setup {
  user_default_options = {
    css = true,
  },
  mode = 'background',
  tailwind = true,
  sass = {
    enable = true,
  },
}

-- nvim-tree
keymap('n', '<leader>tb', [[<cmd>NvimTreeToggle<CR>]], { noremap = true, silent = true, desc = 'Toggle NvimTree' })

local ntree = require 'nvim-tree'

ntree.setup {
  actions = {
    open_file = {
      quit_on_open = true,
    },
  },
  disable_netrw = false,
  ignore_ft_on_setup = { 'vim' },
  hijack_cursor = true,
  diagnostics = {
    enable = true,
  },
  view = {
    width = 20,
    side = 'right',
    adaptive_size = true,
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
    section_separators = '',
    component_separators = '',
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { { 'diagnostics', sources = { 'nvim_diagnostic' } } },
    lualine_c = { 'filename' },
    lualine_x = { 'diff', 'branch' },
    lualine_y = { 'filetype' },
    lualine_z = { 'location' },
  },
  extensions = {
    'fzf',
    'nvim-tree',
    'toggleterm',
  },
}

-- toggleterm
local term = require 'toggleterm'

keymap('n', '<leader>tt', [[<cmd>ToggleTerm<CR>]], { noremap = true, silent = true, desc = 'Toggle Terminal' })

local set_terminal_keymaps = function()
  local tmap = function(keys, func)
    vim.keymap.set('t', keys, func, { buffer = 0 })
  end

  tmap('<esc>', [[<C-\><C-n>]])
  tmap('<C-h>', [[<Cmd>wincmd h<CR>]])
  tmap('<C-j>', [[<Cmd>wincmd j<CR>]])
  tmap('<C-k>', [[<Cmd>wincmd k<CR>]])
  tmap('<C-l>', [[<Cmd>wincmd l<CR>]])
end

vim.api.nvim_create_autocmd('TermOpen', {
  pattern = 'term://*toggleterm#*',
  callback = function()
    set_terminal_keymaps()
  end,
  desc = 'Set terminal keymaps when the terminal buffer opens',
})

term.setup {
  persist_size = false,
  direction = 'tab',
  float_opts = {
    border = 'curved',
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

-- fidget
require('fidget').setup {}
