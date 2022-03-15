-- Zen
local zen = require 'zen-mode'

-- FIX: fix augroup prose (trailing white space Error 448)
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
  on_open = function(_)
    vim.cmd 'cabbrev <buffer> q let b:quitting = 1 <bar> q'
    vim.cmd 'cabbrev <buffer> wq let b:quitting = 1 <bar> wq'
  end,
  on_close = function()
    if vim.b.quitting == 1 then
      vim.b.quitting = 0
      vim.cmd 'q'
    end
  end,
}

-- Twilight
local twilight = require 'twilight'

twilight.setup {
  dimming = {
    alpha = 0.3,
  },
  context = 0,
}

-- Orgmode
local orgmode = require 'orgmode'

orgmode.setup_ts_grammar()

orgmode.setup {
  -- Use GoDo instead
  -- org_agenda_files = { '~/Documents/org/*' },
  -- org_default_notes_file = { '~/Documents/org/notes.org' },
}
