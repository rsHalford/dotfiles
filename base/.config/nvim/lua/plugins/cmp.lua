return {
  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
      },
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-path',
      'ray-x/cmp-treesitter',
      'hrsh7th/cmp-buffer',
      'rafamadriz/friendly-snippets',
    },
    config = function()
      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
      end

      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },
        mapping = cmp.mapping.preset.insert {
          ['<PageUp>'] = cmp.mapping.scroll_docs(-1),
          ['<PageDown>'] = cmp.mapping.scroll_docs(1),
          ['<M-l>'] = cmp.mapping.confirm { select = true },
          ['<Right>'] = cmp.mapping.confirm { select = true },
          ['<M-h>'] = cmp.mapping.abort(),
          ['<Left>'] = cmp.mapping.abort(),
          ['<C-Space>'] = cmp.mapping.complete {},
          ['<M-j>'] = cmp.mapping.select_next_item(),
          ['<Down>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<M-k>'] = cmp.mapping.select_prev_item(),
          ['<Up>'] = cmp.mapping(function(fallback)
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
          { name = 'luasnip' },
          { name = 'nvim_lsp' },
          { name = 'nvim_lua' },
          { name = 'nvim_lsp_signature_help' },
          { name = 'path' },
          { name = 'treesitter' },
          { name = 'buffer', keyworkLength = 5 },
        },
      }

      require('luasnip.loaders.from_vscode').lazy_load()
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
