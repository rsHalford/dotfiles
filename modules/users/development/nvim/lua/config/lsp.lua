local lspconfig = require 'lspconfig'

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local on_attach = function(_, bufnr)

  local nmap = function(keys, func, desc)
    if desc then
      desc = '[L]SP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>lr', vim.lsp.buf.rename, '[R]ename')
  nmap('<leader>la', vim.lsp.buf.code_action, 'Code [A]ction')
  nmap('<leader>ld', vim.lsp.buf.definition, '[D]efinition')
  nmap('<leader>lf', require('telescope.builtin').lsp_references, '[F]ind References')
  nmap('<leader>li', vim.lsp.buf.implementation, '[I]mplementation')
  nmap('<leader>lt', vim.lsp.buf.type_definition, '[T]ype Definition')
  nmap('<leader>lh', vim.lsp.buf.signature_help, 'Signature [H]elp')
  nmap('<leader>sd', require('telescope.builtin').lsp_document_symbols, '[S]ymbols [D]ocument')
  nmap('<leader>sw', require('telescope.builtin').lsp_workspace_symbols, '[S]ymbols [W]orkspace')
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<leader>e', vim.diagnostic.open_float, 'List Diagnostic [E]rrors')
  nmap(']d', vim.diagnostic.goto_next, 'Goto next [D]iagnostic error')
  nmap('[d', vim.diagnostic.goto_prev, 'Goto prev [D]iagnostic error')

  vim.api.nvim_create_autocmd('BufWritePre', { callback = function()
    vim.lsp.buf.format()
  end, desc = 'Format current buffer with LSP' })
end

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
  }
}

luasnip.config.set_config {
  history = true,
  updateevents = "TextChanged,TextChangedI",
  enable_autosnippets = true,
}

require('luasnip.loaders.from_vscode').lazy_load()

require('neodev').setup()

-- Install and configure servers
local servers = {
  astro = {},
  gopls = {},
  marksman = {},
  nil_ls = {},
  sumneko_lua = {},
}

for lsp, _ in pairs(servers) do
  lspconfig[lsp].setup {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = lsp['settings'],
  }
end
