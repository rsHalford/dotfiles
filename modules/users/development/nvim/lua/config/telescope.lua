local tele = require 'telescope'
local telebuilt = require 'telescope.builtin'

-- Navigate buffers and repos
vim.keymap.set('<leader>fb', tele.extensions.file_browser.file_browser({ hidden = true }), desc = '[F]ile [B]rowser')
vim.keymap.set('<leader>wd', telebuilt.lsp_workspace_diagnostics, desc = '[W]orkspace [D]iagnostics')
vim.keymap.set('<leader>fh', telebuilt.help_tags, desc = '[H]elp Tags')
-- vim.keymap.set('<leader>fi', telebuilt.lsp_implementations, desc = '[F]ind [I]mplementations')
vim.keymap.set('<leader>fk', telebuilt.keymaps, desc = 'List [K]eymaps')
vim.keymap.set('<leader>fl', telebuilt.live_grep, desc = '[L]ive Grep')
vim.keymap.set('<leader>fo', telebuilt.oldfiles, desc = '[O]ld [F]iles')
vim.keymap.set('<leader>fr', telebuilt.registers, desc = 'List [R]egisters')
vim.keymap.set('<leader>fs', telebuilt.grep_string, desc = 'Grep [S]tring')
vim.keymap.set('<leader>fz', telebuilt.current_buffer_fuzzy_find, desc = 'Buffer [F]u[Z]zy Find')

-- Spell Suggest
vim.keymap.set('<leader>sp', telebuilt.spell_suggest, desc = '[SP]ell Suggest')

-- Telescope
local teleprev = require 'telescope.previewers'

tele.setup {
  defaults = {
    prompt_prefix = ' ',
    layout_strategy = 'flex',
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    file_previewer = teleprev.vim_buffer_cat.new,
    grep_previewer = teleprev.vim_buffer_vimgrep.new,
    qflist_previewer = teleprev.vim_buffer_qflist.new,
    vimgrep_arguments = {
      'rg',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--hidden',
    },
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Harpoon
local harpoon = require 'harpoon'

vim.keymap.set('<leader>ha', require("harpoon.mark").add_file)
vim.keymap.set('<C-h>', require("harpoon.ui").nav_file(1))
vim.keymap.set('<C-j>', require("harpoon.ui").nav_file(2))
vim.keymap.set('<C-k>', require("harpoon.ui").nav_file(3))
vim.keymap.set('<C-l>', require("harpoon.ui").nav_file(4))
vim.keymap.set('<leader>hm', require("harpoon.ui").toggle_quick_menu)

harpoon.setup {
  global_settings = {
    save_on_toggle = false,
    save_on_change = true,
    enter_on_sendcmd = false,
  },
}

-- Extensions
tele.load_extension 'file_browser'
tele.load_extension 'harpoon'
