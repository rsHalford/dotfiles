return {
  { -- Linting
    'mfussenegger/nvim-lint',
    config = function()
      require('lint').linters_by_ft = {
        elixir = { 'credo' },
        go = { 'golangcilint' },
        json = { 'jsonlint' },
        lua = { 'selene' },
        nix = { 'nix' },
        ruby = { 'rubocop' },
        sh = { 'shellcheck' },
      }

      vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
        callback = function()
          require('lint').try_lint()
        end,
      })
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
