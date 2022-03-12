local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
parser_config.org = {
  install_info = {
    url = 'https://github.com/milisims/tree-sitter-org',
    revision = 'f110024d539e676f25b72b7c80b0fd43c34264ef',
    files = { 'src/parser.c', 'src/scanner.cc' },
  },
  filetype = 'org',
}

local ts_config = require 'nvim-treesitter.configs'

ts_config.setup {
  ensure_installed = 'org',
  indent = {
    enable = true,
  },
  highlight = {
    enable = true,
    disable = 'org',
    additional_vim_regex_highlighting = 'org',
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
