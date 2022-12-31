local opt = vim.opt

opt.autochdir = true
opt.cmdheight = 1
opt.colorcolumn = '80'
opt.completeopt = { 'menu', 'menuone', 'noselect' }
opt.cursorcolumn = true
opt.cursorline = true
opt.errorbells = false
opt.expandtab = true
opt.hlsearch = false
opt.ignorecase = true
opt.number = true
opt.path:append '**'
opt.relativenumber = true
opt.scrolloff = 8
opt.shiftwidth = 2
opt.shortmess:append 'c'
opt.signcolumn = 'no'
opt.smartcase = true
opt.smartindent = true
opt.softtabstop = 2
opt.spelllang = 'en_gb'
opt.splitbelow = true
opt.splitright = true
opt.tabstop = 2
opt.termguicolors = true
opt.title = true
opt.undofile = true
opt.updatetime = 50
opt.wildmode = { 'longest', 'full' }
