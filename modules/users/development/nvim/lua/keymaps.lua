local g = vim.g
local api = vim.api
local keymap = api.nvim_set_keymap

-- Leader Keys
g.mapleader = [[ ]]
g.user_emmet_leader_key = [[<C-,>]]

-- Über Yoinking
keymap('n', 'Y', 'yg$', { noremap = true })
keymap('n', '<leader>y', [["+y]], { noremap = true })
keymap('v', '<leader>y', [["+y]], { noremap = true })
keymap('n', '<leader>Y', [[gg"+yG]], { noremap = true })
keymap('x', '<leader>p', [["_dP]], { noremap = true })
keymap('n', '<leader>d', [["_d]], { noremap = true })
keymap('v', '<leader>d', [["_d]], { noremap = true })

-- Center Next
keymap('n', 'n', 'nzzzv', { noremap = true })
keymap('n', 'N', 'Nzzzv', { noremap = true })
keymap('n', 'J', 'mzJ`z', { noremap = true })

-- Undo Breakpoints
keymap('i', ',', ',<c-g>u', { noremap = true })
keymap('i', '.', '.<c-g>u', { noremap = true })
keymap('i', '?', '?<c-g>u', { noremap = true })
keymap('i', '!', '!<c-g>u', { noremap = true })
keymap('i', '[', '[<c-g>u', { noremap = true })
keymap('i', '{', '{<c-g>u', { noremap = true })
keymap('i', '(', '(<c-g>u', { noremap = true })

-- Navigation
keymap('n', '<leader>h', ':wincmd h<CR>', { noremap = true })
keymap('n', '<leader>j', ':wincmd j<CR>', { noremap = true })
keymap('n', '<leader>k', ':wincmd k<CR>', { noremap = true })
keymap('n', '<leader>l', ':wincmd l<CR>', { noremap = true })
keymap('n', 'k', [[(v:count > 5 ? "m'" . v:count : "") . 'k']], { noremap = true, expr = true })
keymap('n', 'j', [[(v:count > 5 ? "m'" . v:count : "") . 'j']], { noremap = true, expr = true })

-- Moving Text
keymap('v', 'J', [[:m '>+1<CR>gv=gv]], { noremap = true })
keymap('v', 'K', [[:m '<-2<CR>gv=gv]], { noremap = true })
keymap('i', '<C-j>', '<esc>:m .+1<CR>==', { noremap = true })
keymap('i', '<C-k>', '<esc>:m .-2<CR>==', { noremap = true })
-- keymap('n', '<leader>j', ':m .+1<CR>==', { noremap = true })
-- keymap('n', '<leader>k', ':m .-2<CR>==', { noremap = true })

-- Ditto
keymap('n', '-d', '<Plug>DittoPrev', {})
keymap('n', '=d', '<Plug>DittoNext', {})
keymap('n', '+d', '<Plug>DittoGood', {})
keymap('n', '_d', '<Plug>DittoBad', {})
keymap('n', ']d', '<Plug>DittoMore', {})
keymap('n', '[d', '<Plug>DittoLess', {})

-- Rezising Windows
keymap('n', 'zh', ':vertical resize -5<CR>', { noremap = true, silent = true })
keymap('n', 'zj', ':resize +2<CR>', { noremap = true, silent = true })
keymap('n', 'zk', ':resize -2<CR>', { noremap = true, silent = true })
keymap('n', 'zl', ':vertical resize +5<CR>', { noremap = true, silent = true })

-- Markdown Preview
keymap('n', '<leader>m', '<Plug>MarkdownPreviewToggle', {})

-- Undotree
keymap('n', '<leader>z', ':UndotreeToggle<CR>', { noremap = true })

-- Chmod Execute
keymap('n', '<leader>x', ':!chmod +x %<CR>', { noremap = true, silent = true })

-- Compile Execute
keymap('n', '<C-c>', ':w<CR>:!compiler %:p<CR><CR>', { noremap = true, silent = true })

-- List document's URLs
keymap('n', '<leader>u', ':w<Home>silent <End> !urlview<CR>', { noremap = true })

-- Netrw
keymap('n', '<leader>pv', ':wincmd v<BAR> :Ex <BAR> :vertical resize 20<CR>', { noremap = true })
g.netrw_banner = 0
g.netrw_winsize = 25
g.netrw_browse_split = 3
g.netrw_altv = 1
g.netrw_liststyle = 3
g.netrw_list_hide = 'netrw_gitignore#Hide()'
g.netrw_list_hide = [[,(^|ss)zs\S+]]
