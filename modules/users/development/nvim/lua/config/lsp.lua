local lspconfig = require 'lspconfig'

-- capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- on_attach
local on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = '[L]SP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  local vmap = function(keys, func, desc)
    if desc then
      desc = '[L]SP: ' .. desc
    end

    vim.keymap.set('v', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>lr', '<cmd>Lspsaga rename<CR>', '[R]ename')
  nmap('<leader>la', '<cmd>Lspsaga code_action<CR>', 'Code [A]ction')
  vmap('<leader>la', '<cmd>Lspsaga code_action<CR>', 'Code [A]ction')
  nmap('<leader>ld', '<cmd>Lspsaga peek_definition<CR>', 'Peek [D]efinition')
  nmap('<leader>lf', '<cmd>Lspsaga lsp_finder<CR>', '[F]ind References')
  nmap('<leader>o', '<cmd>Lspsaga outline<CR>', 'Symbols Outline')
  nmap('<leader>sd', require('telescope.builtin').lsp_document_symbols, '[S]ymbols [D]ocument')
  nmap('<leader>sw', require('telescope.builtin').lsp_workspace_symbols, '[S]ymbols [W]orkspace')
  nmap('K', '<cmd>Lspsaga hover_doc<CR>', 'Hover Documentation')
  nmap('<leader>e', '<cmd>Lspsaga show_buf_diagnostics<CR>', 'List Diagnostic [E]rrors')
  nmap(']d', '<cmd>Lspsaga diagnostic_jump_next<CR>', 'Goto next [D]iagnostic error')
  nmap('[d', '<cmd>Lspsaga diagnostic_jump_prev<CR>', 'Goto prev [D]iagnostic error')
  vmap('<leader>rf', [[<Esc><cmd>lua require('refactoring').refactor('Extract Function')<CR>]], 'Extract function')
  vmap(
    '<leader>rF',
    [[<Esc><cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]],
    'Extract to file'
  )
  vmap('<leader>rv', [[<Esc><cmd>lua require('refactoring').refactor('Extract Variable')<CR>]], 'Extract variable')
  vmap('<leader>ri', [[<Esc><cmd>lua require('refactoring').refactor('Inline Variable')<CR>]], 'Inline variable')
  nmap('<leader>rb', [[<cmd>lua require('refactoring').refactor('Extract Block')<CR>]], 'Extract block')
  nmap('<leader>rB', [[<cmd>lua require('refactoring').refactor('Extract Block To File')<CR>]], 'Extract block to file')
  nmap('<leader>ri', [[<cmd>lua require('refactoring').refactor('Inline Variable')<CR>]], 'Inline variable')
  vmap('<leader>rl', [[<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>]], 'List refactors')
  nmap('<leader>rp', [[<cmd>lua require('refactoring').debug.printf({below = false})<CR>]], 'Create printf statement')
  nmap(
    '<leader>rP',
    [[<cmd>lua require('refactoring').debug.print_var({normal = true})<CR>]],
    'Create print var statement'
  )
  vmap('<leader>rP', [[<cmd>lua require('refactoring').debug.print_var()<CR>]], 'Create print var statement')
  nmap('<leader>rc', [[<cmd>lua require('refactoring').debug.cleanup({})<CR>]], 'Cleanup printf statements')

  vim.api.nvim_create_autocmd('BufWritePost', {
    callback = function()
      vim.cmd 'FormatWrite'
    end,
    desc = 'Format current buffer with LSP',
  })
end

-- cmp
local cmp = require 'cmp'
local luasnip = require 'luasnip'
local lspkind = require 'lspkind'

cmp.setup {
  mapping = cmp.mapping.preset.insert {
    ['<M-d>'] = cmp.mapping.scroll_docs(-4),
    ['<M-f>'] = cmp.mapping.scroll_docs(4),
    ['<M-e>'] = cmp.mapping.abort(),
    ['<M-y>'] = cmp.mapping.confirm { select = true },
    ['<M-Space>'] = cmp.mapping.complete(),
    ['<M-j>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<M-k>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lua' },
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'luasnip' },
    { name = 'buffer', keyword_length = 5 },
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  formatting = {
    format = lspkind.cmp_format {
      with_text = true,
      menu = {
        nvim_lua = '[api]',
        nvim_lsp = '[lsp]',
        path = '[path]',
        luasnip = '[snip]',
        buffer = '[buf]',
      },
    },
  },
}

-- luasnip
luasnip.config.set_config {
  history = true,
  updateevents = 'TextChanged,TextChangedI',
  enable_autosnippets = true,
}

require('luasnip.loaders.from_vscode').lazy_load()

-- nvim-lint
do
  local lint = require 'lint'
  lint.linters_by_ft = {
    go = { 'golangcilint' },
    lua = { 'selene' },
    markdown = { 'vale' }, -- 'markdownlint',
    nix = { 'nix' }, --, 'statix' },
    python = { 'mypy', 'ruff' },
    sh = { 'shellcheck' },
    -- { 'codespell' },
  }
  vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufEnter', 'BufLeave' }, {
    group = vim.api.nvim_create_augroup('Lint', { clear = true }),
    callback = function()
      lint.try_lint()
    end,
    desc = 'Run linter after writing to the file',
  })
end

-- formatter
local format = require 'formatter'

format.setup {
  logging = false,
  filetype = {
    css = { require('formatter.filetypes.css').prettier },
    html = { require('formatter.filetypes.html').prettier },
    javascript = { require('formatter.filetypes.javascript').prettier },
    go = { require('formatter.filetypes.go').gofmt, require('formatter.filetypes.go').gofumpt },
    lua = { require('formatter.filetypes.lua').stylua },
    markdown = { require('formatter.filetypes.markdown').prettier },
    nix = { require('formatter.filetypes.nix').alejandra },
    python = { require('formatter.filetypes.python').black },
    rust = { require('formatter.filetypes.rust').rustfmt },
    toml = { require('formatter.filetypes.toml').taplo },
    typescript = { require('formatter.filetypes.typescript').prettier },
    yaml = { require('formatter.filetypes.yaml').prettier },
  },
  ['*'] = {
    require('formatter.filetypes.any').remove_trailing_whitespace,
  },
}

-- lsp-saga
local saga = require 'lspsaga'

saga.init_lsp_saga {
  --  scroll_preview = {
  --    scroll_down = '<M-j>',
  --    scroll_up = '<M-k>',
  --  },
  --  definition = {
  --    edit = '<CR>',
  --    quit = { 'q', '<Esc>' },
  --  },
  --  code_action = {
  --    keys = {
  --      quit = { 'q', '<Esc>' },
  --      exec = '<CR>',
  --    },
  --  },
  --  lightbulb = {
  --    enable_in_insert = false,
  --  },
  --  diagnostic = {
  --    keys = {
  --      exec_action = '<CR>',
  --      quit = { 'q', '<Esc>' },
  --    },
  --  },
  --  rename = {
  --    quit = '<Esc>',
  --    exec = '<CR>',
  --    in_select = true,
  --  },
  --  outline = {
  --    keys = {
  --      jump = '<CR>',
  --      expand_collapse = { 'l', '<Tab>' },
  --      quit = { 'q', '<Esc>' },
  --    },
  --  },
}

-- refactoring
local refactor = require 'refactoring'

refactor.setup {}

-- neodev
require('neodev').setup()

-- Install and configure servers
local servers = {
  astro = {},
  gopls = {},
  marksman = {},
  nil_ls = {},
  sumneko_lua = {},
  tsserver = {},
}

for server, config in pairs(servers) do
  lspconfig[server].setup(vim.tbl_deep_extend('force', {
    capabilities = capabilities,
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
  }, config))
end
