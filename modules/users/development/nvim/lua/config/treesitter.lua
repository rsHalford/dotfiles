local parser_config = require('nvim-treesitter.parsers').get_parser_configs()

local ts_config = require 'nvim-treesitter.configs'

ts_config.setup {
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
