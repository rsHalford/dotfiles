local lspconfig = require 'lspconfig'

local on_attach = function()
  vim.cmd 'autocmd BufWritePre <buffer> lua vim.lsp.buf.format()'
end

-- null-ls
local null_ls = require 'null-ls'
local b = null_ls.builtins

null_ls.setup {
  sources = {
    b.code_actions.gitsigns,
    b.diagnostics.shellcheck,
    b.formatting.stylua.with {
      extra_args = {
        '--column-width=120',
        '--line-endings=Unix',
        '--indent-type=Spaces',
        '--indent-width=2',
        '--quote-style=AutoPreferSingle',
        '--no-call-parenthesis=true',
      },
    },
  },
  on_attach = on_attach,
}

-- lsp servers
local servers = {
  'bashls',
  'cssls',
  'eslint',
  'html',
  'jsonls',
  'rnix',
  'vimls',
  'yamlls',
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    capabilities = capabilities,
    on_attach = on_attach,
  }
end
