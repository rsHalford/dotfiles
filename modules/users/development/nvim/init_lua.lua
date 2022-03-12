local g = vim.g
local cmd = vim.cmd

-- require 'filetypes'
-- require 'keymaps'
-- require 'options'
-- require 'plugins'

-- TODO: find a home for the below commands and convert to lua.
-- Python Venv
-- g.python3_host_prog = '/usr/bin/python3'

--  Highlight on Yank
cmd [[ autocmd TextYankPost * silent! lua vim.highlight.on_yank() ]]

-- Copy & Paste
cmd [[
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"
inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()
function! XTermPasteBegin()
	set pastetoggle=<Esc>[201~
	set paste
	return ""
endfunction
]]

-- Undotree
g.undotree_SetFocusWhenToggle = 1

-- Gruvbox
g.gruvbox_contrast_dark = 'hard'
cmd [[
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
]]
g.gruvbox_invert_selection = '0'
cmd [[
colorscheme gruvbox
highlight ColorColumn guibg=#282828
highlight CursorColumn guibg=#282828
highlight CursorLine guibg=#282828
highlight CursorLineNR guibg=#282828
highlight GitSignsAddNr guibg=None guifg=#b8bb26
highlight GitSignsChangeNr guibg=None guifg=#8ec07c
highlight GitSignsDeleteNr guibg=None guifg=#fb4934
highlight EndOfBuffer guifg=#1d2021
highlight VertSplit guifg=#282828
highlight VertSplit guibg=#282828
highlight Comment gui=italic
]]
