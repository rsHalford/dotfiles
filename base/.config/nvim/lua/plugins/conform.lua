return {
  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    opts = {
      notify_on_error = false,
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
      formatters_by_ft = {
        elixir = { 'mix' },
        go = { 'goimports', 'gofmt' },
        json = { 'jq' },
        lua = { 'stylua' },
        nix = { 'alejandra' },
        -- python = function(bufnr)
        --   if require('conform').get_formatter_info('ruff_format', bufnr).available then
        --     return { 'ruff_format' }
        --   else
        --     return { 'isort', 'black' }
        --   end
        -- end,
        ruby = { 'rubocop' },
        sh = { 'shfmt' },
        sql = { 'sql_formatter' },
        toml = { 'taplo' },
        yaml = { 'yq' },
        zig = { 'zigfmt' },
        -- javascript = { { "prettierd", "prettier" } }, -- You can use a sub-list to tell conform to run *until* a formatter is found.
        ['_'] = { 'trim_whitespace' },
      },
      -- formatters = {},
    },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
