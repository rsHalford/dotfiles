local wezterm = require 'wezterm'

local M = {}

function M.apply(config)
  -- Window
  config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  }

  -- Scroll Bar
  config.enable_scroll_bar = false

  -- Tabbar
  config.use_fancy_tab_bar = false
  config.tab_bar_at_bottom = true
  config.hide_tab_bar_if_only_one_tab = true

  -- Font
  config.font = wezterm.font_with_fallback {
    'BlexMono Nerd Font',
    -- 'Berkeley Mono',
    -- 'nonicons',
  }
  config.font_size = 14.0
  config.freetype_load_target = 'HorizontalLcd'

  -- Colors
  -- config.color_scheme = 'kanagawa'
  config.force_reverse_video_cursor = true
  config.colors = {
    foreground = '#dcd7ba',
    background = '#1f1f28',
    cursor_bg = '#c8c093',
    cursor_fg = '#c8c093',
    cursor_border = '#c8c093',
    selection_fg = '#c8c093',
    selection_bg = '#2d4f67',
    scrollbar_thumb = '#16161d',
    split = '#16161d',
    ansi = { '#090618', '#c34043', '#76946a', '#c0a36e', '#7e9cd8', '#957fb8', '#6a9589', '#c8c093' },
    brights = { '#727169', '#e82424', '#98bb6c', '#e6c384', '#7fb4ca', '#938aa9', '#7aa89f', '#dcd7ba' },
    indexed = { [16] = '#ffa066', [17] = '#ff5d62' },
  }
end

return M
