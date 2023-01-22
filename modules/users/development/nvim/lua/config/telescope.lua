local telescope = require 'telescope'

local tmap = function(keys, func, desc)
  vim.keymap.set('n', keys, func, { desc = desc })
end

-- Navigate buffers and repos
tmap('<leader>wf', [[<cmd>lua require('telescope.builtin').git_files()<CR>]], 'Workspace file')
tmap('<leader>ws', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]], 'Workspace String')
tmap('<leader>fb', [[<cmd>lua require('telescope.builtin').buffers()<CR>]], 'File buffers')
tmap('<leader>fo', [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]], 'File old')
tmap('<leader>fs', [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>]], 'File search')
tmap('<leader>vh', [[<cmd>lua require('telescope.builtin').help_tags()<CR>]], 'View help')
tmap('<leader>vk', [[<cmd>lua require('telescope.builtin').keymaps()<CR>]], 'View keymaps')
tmap('<leader>vr', [[<cmd>lua require('telescope.builtin').registers()<CR>]], 'View register')

-- Spell Suggest
tmap('<leader>sp', [[<cmd>lua require('telescope.builtin').spell_suggest()<CR>]], 'Spell suggest')

-- Telescope
local previewers = require 'telescope.previewers'
local actions = require 'telescope.actions'

telescope.load_extension 'fzf'
telescope.load_extension 'harpoon'
telescope.load_extension 'refactoring'

telescope.setup {
  defaults = {
    prompt_prefix = ' ',
    layout_strategy = 'flex',
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    file_previewer = previewers.vim_buffer_cat.new,
    grep_previewer = previewers.vim_buffer_vimgrep.new,
    qflist_previewer = previewers.vim_buffer_qflist.new,
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
      n = {
        ['<C-k>'] = actions.preview_scrolling_up,
        ['<C-j>'] = actions.preview_scrolling_down,
      },
      i = {
        ['<C-k>'] = actions.preview_scrolling_up,
        ['<C-j>'] = actions.preview_scrolling_down,
        ['<M-k>'] = actions.move_selection_previous,
        ['<M-j>'] = actions.move_selection_next,
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Harpoon
local harpoon = require 'harpoon'

tmap('<leader>ha', [[<cmd>lua require("harpoon.mark").add_file()<CR>]], 'Harpoon add')
tmap('<C-h>', [[<cmd>lua require("harpoon.ui").nav_file(1)<CR>]])
tmap('<C-j>', [[<cmd>lua require("harpoon.ui").nav_file(2)<CR>]])
tmap('<C-k>', [[<cmd>lua require("harpoon.ui").nav_file(3)<CR>]])
tmap('<C-l>', [[<cmd>lua require("harpoon.ui").nav_file(4)<CR>]])
tmap('<leader>hm', [[<cmd>lua require("harpoon.ui").toggle_quick_menu()<CR>]], 'Harpoon menu')

harpoon.setup {
  global_settings = {
    save_on_toggle = false,
    save_on_change = true,
    enter_on_sendcmd = false,
  },
}

-- todo-comments
local todo = require 'todo-comments'

todo.setup {}

tmap('<leader>wc', [[<cmd>TodoTelescope<CR>]], 'Workspace comments')
