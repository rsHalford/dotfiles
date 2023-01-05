local g = vim.g
local wk = require 'which-key'

wk.register()

-- Leader Keys
g.mapleader = [[ ]]
g.maplocalleader = [[ ]]
g.user_emmet_leader_key = [[<C-,>]]

local nmap = function(keys, func, desc, silent)
  vim.keymap.set('n', keys, func, { noremap = true, desc = desc, silent = silent })
end

local vmap = function(keys, func, desc, silent)
  vim.keymap.set('v', keys, func, { noremap = true, desc = desc, silent = silent })
end

local imap = function(keys, func, desc, silent)
  vim.keymap.set('i', keys, func, { noremap = true, desc = desc, silent = silent })
end

-- Über Yoinking
nmap('<leader>y', [["+y]], '[Y]ank movement to clipboard')
vmap('<leader>y', [["+y]], '[Y]ank selection to clipboard')
nmap('<leader>Y', [[gg"+yG]], '[Y]ank file to clipboard')
nmap('<leader>p', [["_dP]], '[P]reserve Yank')
nmap('<leader>d', [["_d]], '[D]elete movement')
vmap('<leader>d', [["_d]], '[D]elete selection')

-- Center Next
nmap('n', 'nzzzv', 'Centre next match')
nmap('N', 'Nzzzv', 'Centre prev match')
nmap('<C-u>', '<C-u>zz', 'Centre prev up')
nmap('<C-d>', '<C-d>zz', 'Centre scroll down')

-- Undo Breakpoints
imap(',', ',<c-g>u')
imap('.', '.<c-g>u')
imap('?', '?<c-g>u')
imap('!', '!<c-g>u')
imap('[', '[<c-g>u')
imap('{', '{<c-g>u')
imap('(', '(<c-g>u')

-- Navigation
nmap('<leader>wh', ':wincmd h<CR>', 'Focus window left')
nmap('<leader>wj', ':wincmd j<CR>', 'Focus window down')
nmap('<leader>wk', ':wincmd k<CR>', 'Focus window up')
nmap('<leader>wl', ':wincmd l<CR>', 'Focus window right')
vim.keymap.set('n', 'k', [[(v:count > 5 ? "m'" . v:count : "") . 'k']],
  { noremap = true, desc = 'Mark to jumplist', expr = true })
vim.keymap.set('n', 'j', [[(v:count > 5 ? "m'" . v:count : "") . 'j']],
  { noremap = true, desc = 'Mark to jumplist', expr = true })
-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', [[v:count == 0 ? 'gk' : 'k']],
  { desc = "Moves cursor up a line, including wrapped lines", expr = true, silent = true })
vim.keymap.set('n', 'j', [[v:count == 0 ? 'gj' : 'j']],
  { desc = "Moves cursor down a line, including wrapped lines", expr = true, silent = true })

-- Moving Text
vmap('J', [[:m '>+1<CR>gv=gv]], 'Move selection down')
vmap('K', [[:m '<-2<CR>gv=gv]], 'Move selection up')
imap('<C-j>', '<esc>:m .+1<CR>==', 'Move cursor down')
imap('<C-k>', '<esc>:m .-2<CR>==', 'Move cursor up')
nmap('<leader>j', ':m .+1<CR>==', 'Move line down')
nmap('<leader>k', ':m .-2<CR>==', 'Move line up')

-- Rezising Windows
nmap('zh', ':vertical resize -5<CR>', 'Reduce window width', true)
nmap('zj', ':resize +2<CR>', 'Increase window height', true)
nmap('zk', ':resize -2<CR>', 'Reduce window height', true)
nmap('zl', ':vertical resize +5<CR>', 'Increase window width', true)

-- Undotree
nmap('<leader>tu', ':UndotreeToggle<CR>', 'Toggle Undotree')

-- Run Scripts
nmap('<leader>x', ':!chmod +x %<CR>', 'Make e[X]ecutable', true)
nmap('<C-c>', ':w<CR>:!compiler %:p<CR><CR>', 'Run [C]ompiler script', true)

-- List document's URLs
nmap('<leader>u', ':w<Home>silent <End> !urlview<CR>', 'List [U]RLs in buffer')

-- Netrw
g.netrw_banner = 0
g.netrw_winsize = 25
g.netrw_browse_split = 3
g.netrw_altv = 1
g.netrw_liststyle = 3
g.netrw_list_hide = 'netrw_gitignore#Hide()'
g.netrw_list_hide = [[,(^|ss)zs\S+]]
