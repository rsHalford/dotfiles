local telescope = require 'telescope'
local previewers = require 'telescope.previewers'
local actions = require 'telescope.actions'
local keymap = vim.api.nvim_set_keymap

-- Navigate buffers and repos
keymap('n', '<leader>fb', [[<cmd>lua require('telescope').extensions.file_browser.file_browser({hidden=true})<CR>]], {
  noremap = true,
})
keymap('n', '<leader>fd', [[<cmd>lua require('telescope.builtin').lsp_definitions()<CR>]], { noremap = true })
keymap('n', '<leader>fe', [[<cmd>lua require('telescope.builtin').lsp_workspace_diagnostics()<CR>]], {
  noremap = true,
})
keymap('n', '<leader>fh', [[<cmd>lua require('telescope.builtin').help_tags()<CR>]], { noremap = true })
keymap('n', '<leader>fi', [[<cmd>lua require('telescope.builtin').lsp_implementations()<CR>]], { noremap = true })
keymap('n', '<leader>fk', [[<cmd>lua require('telescope.builtin').keymaps()<CR>]], { noremap = true })
keymap('n', '<leader>fl', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]], { noremap = true })
keymap('n', '<leader>fo', [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]], { noremap = true })
keymap('n', '<leader>fr', [[<cmd>lua require('telescope.builtin').registers()<CR>]], { noremap = true })
keymap('n', '<leader>fs', [[<cmd>lua require('telescope.builtin').grep_string()<CR>]], { noremap = true })
keymap('n', '<leader>fz', [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>]], {
  noremap = true,
})
-- keymap('n', '<leader>ft', [[<cmd>Telescope termfinder find<CR>]], { noremap = true })

-- Flutter
-- keymap('n', '<leader>fc', [[<cmd>lua require('telescope').extensions.flutter.commands()<CR>]], { noremap = true })

-- Spell Suggest
keymap('n', '<leader>s', [[<cmd>lua require('telescope.builtin').spell_suggest()<CR>]], { noremap = true })

-- Git Pickers
keymap('n', '<leader>gc', [[<cmd>lua require('telescope.builtin').git_commits()<CR>]], { noremap = true })
keymap('n', '<leader>gbc', [[<cmd>lua require('telescope.builtin').git_bcommits()<CR>]], { noremap = true })
keymap('n', '<leader>gbr', [[<cmd>lua require('telescope.builtin').git_branches()<CR>]], { noremap = true })
keymap('n', '<leader>gf', [[<cmd>lua require('telescope.builtin').git_files()<CR>]], { noremap = true })
keymap('n', '<leader>gst', [[<cmd>lua require('telescope.builtin').git_status()<CR>]], { noremap = true })
keymap('n', '<leader>gsa', [[<cmd>lua require('telescope.builtin').git_stash()<CR>]], { noremap = true })

-- Git Worktree
keymap(
  'n',
  '<leader>w',
  [[<cmd>lua require('telescope').extensions.git_worktree.git_worktrees()<CR>]],
  { noremap = true }
)
keymap(
  'n',
  '<leader>aw',
  [[<cmd>lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>]],
  { noremap = true }
)

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
        ['<C-k>'] = actions.preview_scrolling_up,
        ['<C-j>'] = actions.preview_scrolling_down,
      },
      n = {
        ['<C-k>'] = actions.preview_scrolling_up,
        ['<C-j>'] = actions.preview_scrolling_down,
      },
    },
  },
}

-- Extensions
-- telescope.load_extension 'fzf'
-- telescope.load_extension 'flutter'
telescope.load_extension 'file_browser'
telescope.load_extension 'git_worktree'
-- telescope.load_extension 'termfinder'
