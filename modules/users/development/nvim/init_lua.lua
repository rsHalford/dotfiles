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
