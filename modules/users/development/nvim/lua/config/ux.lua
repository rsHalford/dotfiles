local cmd = vim.cmd
local keymap = vim.api.nvim_set_keymap

-- Tokyo Night
local tokyo = require 'tokyonight'

tokyo.setup {
  style = 'night',
  transparent = false,
  terminal_colors = true,
}

cmd 'colorscheme tokyonight'

-- Dashboard
local alpha = require 'alpha'
local header = {
  type = 'text',
  val = {
    '              ██████  ██████',
    '              ██░░██  ██░░██',
    '              ██░░██  ██░░██',
    '              ██░░██  ██░░██',
    '████████████████░░██████░░██',
    '██░░░░░░░░░░░░░░░░░░░░░░░░██',
    '██░░██████░░████░░██████░░██',
    '██░░██  ██░░░░░░░░██  ██░░██',
    '██░░██  ████████░░██  ██░░██',
    '██░░██  ██░░░░░░░░██  ██░░██',
    '██████  ████████████  ██████',
  },
  opts = {
    position = 'center',
    hl = 'Type',
  },
}

local handle = io.popen 'nix-store -qR "$(which "nvim")" | rg "vimplugin" | wc -l'
local plugins = handle:read '*a'
handle:close()
plugins = plugins:gsub('^%s*(.-)%s*$', '%1')

local thingy = io.popen 'echo "$(date +%a) $(date +%d) $(date +%b)" | tr -d "\n"'
local date = thingy:read '*a'
thingy:close()

local heading = {
  type = 'text',
  val = '┌─   Today is ' .. date .. ' ─┐',
  opts = {
    position = 'center',
    hl = 'Identifier',
  },
}

local plugin_count = {
  type = 'text',
  val = '└─ 󰏖  ' .. plugins .. ' plugins in total ─┘',
  opts = {
    position = 'center',
    hl = 'Identifier',
  },
}

local function button(sc, txt, keybind)
  local sc_ = sc:gsub('%s', ''):gsub('SPC', '<leader>')

  local opts = {
    position = 'center',
    text = txt,
    shortcut = sc,
    cursor = 5,
    width = 24,
    align_shortcut = 'right',
    hl_shortcut = 'String',
  }
  if keybind then
    opts.keymap = { 'n', sc_, keybind, { noremap = true, silent = true } }
  end

  return {
    type = 'button',
    val = txt,
    on_press = function()
      local key = vim.api.nvim_replace_termcodes(sc_, true, false, true)
      vim.api.nvim_feedkeys(key, 'normal', false)
    end,
    opts = opts,
  }
end

local buttons = {
  type = 'group',
  val = {
    button('z', '  Zettelkasten', [[<cmd>cd $ZETTELKASTEN_DIR<CR><cmd>e QuickNote.md<CR>]]),
    button('n', '  New file', [[<cmd>ene <BAR> startinsert <CR>]]),
    button('r', '󰋚  Recent', [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]]),
    button('q', '󰅚  Quit', [[<cmd>qa<CR>]]),
  },
  opts = {
    spacing = 1,
  },
}

local fortune = require 'alpha.fortune'()
-- fortune = fortune:gsub("^%s+", ""):gsub("%s+$", "")
local footer = {
  type = 'text',
  val = fortune,
  opts = {
    position = 'center',
    hl = 'Comment',
    hl_shortcut = 'Comment',
  },
}

local section = {
  header = header,
  buttons = buttons,
  plugin_count = plugin_count,
  heading = heading,
  footer = footer,
}

local opts = {
  layout = {
    { type = 'padding', val = 8 },
    section.header,
    { type = 'padding', val = 4 },
    section.heading,
    section.plugin_count,
    { type = 'padding', val = 3 },
    section.buttons,
    { type = 'padding', val = 2 },
    section.footer,
  },
  opts = {
    margin = 0,
  },
}

alpha.setup(opts)

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
          deleted = '󰆴',
          ignored = '󰈉',
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

-- trouble
require('trouble').setup {}

keymap(
  'n',
  '<leader>te',
  [[<cmd>TroubleToggle workspace_diagnostics<CR>]],
  { noremap = true, silent = true, desc = 'Toggle workspace diagnostics' }
)
keymap(
  'n',
  '<leader>tq',
  [[<cmd>TroubleToggle quickfix<CR>]],
  { noremap = true, silent = true, desc = 'Toggle quickfix list' }
)
keymap(
  'n',
  '<leader>tl',
  [[<cmd>TroubleToggle loclist<CR>]],
  { noremap = true, silent = true, desc = 'Toggle loclist' }
)

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
    lualine_c = { { 'filename', newfile_status = true, path = 3 } },
    lualine_x = { 'diff', 'branch' },
    lualine_y = { 'filetype' },
    lualine_z = { 'location', 'progress' },
  },
  extensions = {
    'fzf',
    'nvim-tree',
    'quickfix',
    'symbols-outline',
    'toggleterm',
    'trouble',
  },
}

-- toggleterm
local term = require 'toggleterm'

keymap('n', '<leader>tt', [[<cmd>ToggleTerm<CR>]], { noremap = true, silent = true, desc = 'Toggle terminal' })

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
