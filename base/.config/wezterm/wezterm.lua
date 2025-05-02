local wezterm = require 'wezterm'

local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.check_for_updates = false
config.front_end = 'OpenGL'
config.adjust_window_size_when_changing_font_size = true

require('kanagawa').apply(config)
require('keybinds').apply(config)

-- and finally, return the configuration to wezterm
return config
