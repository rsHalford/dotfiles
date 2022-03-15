local saga = require 'lspsaga'
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

keymap('n', '<leader>vf', [[<cmd>lua require('lspsaga.provider').lsp_finder()<CR>]], opts)
keymap('n', '<leader>ca', [[<cmd>lua require('lspsaga.codeaction').code_action()<CR>]], opts)
keymap('v', '<leader>ca', [[<C-U>lua require('lspsaga.codeaction').range_code_action()<CR>]], opts)
keymap('n', '<leader>vh', [[<cmd>lua require('lspsaga.hover').render_hover_doc()<CR>]], opts)
keymap('n', '<leader>vr', [[<cmd>lua require('lspsaga.rename').rename()<CR>]], opts)
keymap('n', '<leader>vd', [[<cmd>lua require('lspsaga.provider').preview_definition()<CR>]], opts)
keymap('n', '<leader>ve', [[<cmd>lua require('lspsaga.diagnostic').show_line_diagnostics()<CR>]], opts)
keymap('n', '<leader>[', [[<cmd>lua require('lspsaga.diagnostic').lsp_jump_diagnostic_prev()<CR>]], opts)
keymap('n', '<leader>]', [[<cmd>lua require('lspsaga.diagnostic').lsp_jump_diagnostic_next()<CR>]], opts)

saga.init_lsp_saga()
