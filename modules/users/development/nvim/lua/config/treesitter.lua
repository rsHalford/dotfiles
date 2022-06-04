local parser_config = require('nvim-treesitter.parsers').get_parser_configs()

local ts_config = require 'nvim-treesitter.configs'

ts_config.setup {
  ensure_installed = {
    'bash',
    'c',
    'clojure',
    'cmake',
    'commonlisp',
    'cpp',
    'css',
    'dart',
    'dockerfile',
    'fish',
    'go',
    'haskell',
    'html',
    'javascript',
    'json',
    'jsonc',
    'latex',
    'lua',
    'make',
    'markdown',
    'nix',
    'org',
    'python',
    'regex',
    'ruby',
    'rust',
    'scala',
    'scheme',
    'scss',
    'svelte',
    'toml',
    'tsx',
    'typescript',
    'vim',
    'vue',
    'yaml',
  },
  indent = {
    enable = true,
  },
  highlight = {
    enable = true,
  },
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  },
  autotag = {
    enable = true,
  },
}
