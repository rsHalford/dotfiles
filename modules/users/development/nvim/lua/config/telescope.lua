local telescope = require 'telescope'

local tmap = function(keys, func, desc)
  vim.keymap.set('n', keys, func, { desc = desc })
end

-- Navigate buffers and repos
tmap('<leader>wf', [[<cmd>lua require('telescope.builtin').git_files()<CR>]], '[W]orkspace [F]ile')
tmap('<leader>ws', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]], '[W]orkspace [S]tring')
tmap('<leader>fb', [[<cmd>lua require('telescope.builtin').buffers()<CR>]], '[F]ile [B]uffers')
tmap('<leader>fo', [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]], '[F]ile [O]ld')
tmap('<leader>fs', [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>]], '[F]ile [S]earch')
tmap('<leader>vh', [[<cmd>lua require('telescope.builtin').help_tags()<CR>]], '[V]iew [H]elp')
tmap('<leader>vk', [[<cmd>lua require('telescope.builtin').keymaps()<CR>]], '[V]iew [K]eymaps')
tmap('<leader>rl', [[<cmd>lua require('telescope.builtin').registers()<CR>]], '[R]egister [L]ist')

-- Spell Suggest
tmap('<leader>sp', [[<cmd>lua require('telescope.builtin').spell_suggest()<CR>]], '[S][P]ell Suggest')

-- Telescope
local previewers = require 'telescope.previewers'

telescope.load_extension 'fzf'
telescope.load_extension 'harpoon'

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
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Harpoon
local harpoon = require 'harpoon'

tmap('<leader>ha', [[<cmd>lua require("harpoon.mark").add_file()<CR>]], '[H]arpoon [A]dd')
tmap('<C-h>', [[<cmd>lua require("harpoon.ui").nav_file(1)<CR>]])
tmap('<C-j>', [[<cmd>lua require("harpoon.ui").nav_file(2)<CR>]])
tmap('<C-k>', [[<cmd>lua require("harpoon.ui").nav_file(3)<CR>]])
tmap('<C-l>', [[<cmd>lua require("harpoon.ui").nav_file(4)<CR>]])
tmap('<leader>hm', [[<cmd>lua require("harpoon.ui").toggle_quick_menu()<CR>]], '[H]arpoon [M]enu')

harpoon.setup {
  global_settings = {
    save_on_toggle = false,
    save_on_change = true,
    enter_on_sendcmd = false,
  },
}
