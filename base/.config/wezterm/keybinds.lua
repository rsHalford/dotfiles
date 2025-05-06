local wezterm = require 'wezterm'
local act = wezterm.action

local M = {}

function M.apply(config)
  config.leader = { key = 'a', mods = 'CTRL' }

  config.keys = {
    { key = 'a', mods = 'LEADER|CTRL', action = act { SendString = '\x01' } },
    { key = 'l', mods = 'LEADER', action = act.ShowLauncher },
    { key = 'c', mods = 'LEADER', action = act { SpawnTab = 'CurrentPaneDomain' } },
    { key = 'n', mods = 'LEADER', action = act.ActivateTabRelative(-1) },
    { key = 'p', mods = 'LEADER', action = act.ActivateTabRelative(1) },
    { key = '&', mods = 'LEADER|SHIFT', action = act { CloseCurrentTab = { confirm = false } } },

    { key = 'Enter', mods = 'LEADER', action = act.ActivateCopyMode },

    { key = 'o', mods = 'LEADER', action = 'TogglePaneZoomState' },
    { key = 'z', mods = 'LEADER', action = 'TogglePaneZoomState' },

    { key = '-', mods = 'LEADER', action = act { SplitVertical = { domain = 'CurrentPaneDomain' } } },
    { key = 's', mods = 'LEADER', action = act { SplitVertical = { domain = 'CurrentPaneDomain' } } },
    { key = '\\', mods = 'LEADER', action = act { SplitHorizontal = { domain = 'CurrentPaneDomain' } } },
    { key = 'v', mods = 'LEADER', action = act { SplitHorizontal = { domain = 'CurrentPaneDomain' } } },

    { key = '0', mods = 'LEADER', action = act.PaneSelect { mode = 'SwapWithActive' } },
    { key = 'Space', mods = 'LEADER', action = act.RotatePanes 'Clockwise' },
    { key = 'h', mods = 'LEADER', action = act { ActivatePaneDirection = 'Left' } },
    { key = 'j', mods = 'LEADER', action = act { ActivatePaneDirection = 'Down' } },
    { key = 'k', mods = 'LEADER', action = act { ActivatePaneDirection = 'Up' } },
    { key = 'l', mods = 'LEADER', action = act { ActivatePaneDirection = 'Right' } },
    { key = 'H', mods = 'LEADER|SHIFT', action = act { AdjustPaneSize = { 'Left', 2 } } },
    { key = 'J', mods = 'LEADER|SHIFT', action = act { AdjustPaneSize = { 'Down', 2 } } },
    { key = 'K', mods = 'LEADER|SHIFT', action = act { AdjustPaneSize = { 'Up', 2 } } },
    { key = 'L', mods = 'LEADER|SHIFT', action = act { AdjustPaneSize = { 'Right', 2 } } },
    { key = 'd', mods = 'LEADER', action = act { CloseCurrentPane = { confirm = true } } },
    { key = 'x', mods = 'LEADER', action = act { CloseCurrentPane = { confirm = true } } },
  }

  for i = 1, 9 do
    table.insert(config.keys, {
      key = tostring(i),
      mods = 'LEADER',
      action = act.ActivateTab(i - 1),
    })
  end

  config.key_tables = {
    copy_mode = {
      { key = 'c', mods = 'CTRL', action = act.CopyMode 'Close' },
      { key = 'g', mods = 'CTRL', action = act.CopyMode 'Close' },
      { key = 'q', mods = 'NONE', action = act.CopyMode 'Close' },
      { key = 'Escape', mods = 'NONE', action = act.CopyMode 'Close' },
      { key = 'h', mods = 'NONE', action = act.CopyMode 'MoveLeft' },
      { key = 'j', mods = 'NONE', action = act.CopyMode 'MoveDown' },
      { key = 'k', mods = 'NONE', action = act.CopyMode 'MoveUp' },
      { key = 'l', mods = 'NONE', action = act.CopyMode 'MoveRight' },
      { key = 'LeftArrow', mods = 'NONE', action = act.CopyMode 'MoveLeft' },
      { key = 'DownArrow', mods = 'NONE', action = act.CopyMode 'MoveDown' },
      { key = 'UpArrow', mods = 'NONE', action = act.CopyMode 'MoveUp' },
      { key = 'RightArrow', mods = 'NONE', action = act.CopyMode 'MoveRight' },
      { key = 'RightArrow', mods = 'ALT', action = act.CopyMode 'MoveForwardWord' },
      { key = 'f', mods = 'ALT', action = act.CopyMode 'MoveForwardWord' },
      { key = 'Tab', mods = 'NONE', action = act.CopyMode 'MoveForwardWord' },
      { key = 'w', mods = 'NONE', action = act.CopyMode 'MoveForwardWord' },
      { key = 'LeftArrow', mods = 'ALT', action = act.CopyMode 'MoveBackwardWord' },
      { key = 'b', mods = 'ALT', action = act.CopyMode 'MoveBackwardWord' },
      { key = 'Tab', mods = 'SHIFT', action = act.CopyMode 'MoveBackwardWord' },
      { key = 'b', mods = 'NONE', action = act.CopyMode 'MoveBackwardWord' },
      { key = '0', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLine' },
      { key = 'Enter', mods = 'NONE', action = act.CopyMode 'MoveToStartOfNextLine' },
      { key = '$', mods = 'NONE', action = act.CopyMode 'MoveToEndOfLineContent' },
      { key = '$', mods = 'SHIFT', action = act.CopyMode 'MoveToEndOfLineContent' },
      { key = '^', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLineContent' },
      { key = '^', mods = 'SHIFT', action = act.CopyMode 'MoveToStartOfLineContent' },
      { key = 'm', mods = 'ALT', action = act.CopyMode 'MoveToStartOfLineContent' },
      { key = ' ', mods = 'NONE', action = act.CopyMode { SetSelectionMode = 'Cell' } },
      { key = 'v', mods = 'NONE', action = act.CopyMode { SetSelectionMode = 'Cell' } },
      { key = 'V', mods = 'NONE', action = act.CopyMode { SetSelectionMode = 'Line' } },
      { key = 'V', mods = 'SHIFT', action = act.CopyMode { SetSelectionMode = 'Line' } },
      { key = 'v', mods = 'CTRL', action = act.CopyMode { SetSelectionMode = 'Block' } },
      { key = 'G', mods = 'NONE', action = act.CopyMode 'MoveToScrollbackBottom' },
      { key = 'G', mods = 'SHIFT', action = act.CopyMode 'MoveToScrollbackBottom' },
      { key = 'g', mods = 'NONE', action = act.CopyMode 'MoveToScrollbackTop' },
      { key = 'H', mods = 'NONE', action = act.CopyMode 'MoveToViewportTop' },
      { key = 'H', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportTop' },
      { key = 'M', mods = 'NONE', action = act.CopyMode 'MoveToViewportMiddle' },
      { key = 'M', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportMiddle' },
      { key = 'L', mods = 'NONE', action = act.CopyMode 'MoveToViewportBottom' },
      { key = 'L', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportBottom' },
      { key = 'o', mods = 'NONE', action = act.CopyMode 'MoveToSelectionOtherEnd' },
      { key = 'O', mods = 'NONE', action = act.CopyMode 'MoveToSelectionOtherEndHoriz' },
      { key = 'O', mods = 'SHIFT', action = act.CopyMode 'MoveToSelectionOtherEndHoriz' },
      { key = 'PageUp', mods = 'NONE', action = act.CopyMode 'PageUp' },
      { key = 'PageDown', mods = 'NONE', action = act.CopyMode 'PageDown' },
      { key = 'b', mods = 'CTRL', action = act.CopyMode 'PageUp' },
      { key = 'f', mods = 'CTRL', action = act.CopyMode 'PageDown' },
      { key = 'y', mods = 'NONE', action = act.Multiple { act.CopyTo 'ClipboardAndPrimarySelection', act.CopyMode 'Close' } },
      { key = 'Enter', mods = 'NONE', action = act.Multiple { act.CopyTo 'ClipboardAndPrimarySelection', act.CopyMode 'Close' } },

      { key = '/', mods = 'NONE', action = act { Search = { CaseSensitiveString = '' } } },
      { key = '?', mods = 'NONE', action = act { Search = { CaseInSensitiveString = '' } } },
      { key = 'n', mods = 'CTRL', action = act { CopyMode = 'NextMatch' } },
      { key = 'p', mods = 'CTRL', action = act { CopyMode = 'PriorMatch' } },
    },

    search_mode = {
      { key = 'Escape', mods = 'NONE', action = act { CopyMode = 'Close' } },
      { key = 'Enter', mods = 'NONE', action = 'ActivateCopyMode' },
      { key = 'c', mods = 'CTRL', action = 'ActivateCopyMode' },
      { key = 'n', mods = 'CTRL', action = act { CopyMode = 'NextMatch' } },
      { key = 'p', mods = 'CTRL', action = act { CopyMode = 'PriorMatch' } },
      { key = 'r', mods = 'CTRL', action = act.CopyMode 'CycleMatchType' },
      { key = 'u', mods = 'CTRL', action = act.CopyMode 'ClearPattern' },
    },
  }

  -- Integrate Neovim into pane select
  local function is_vim(pane)
    -- this is set by the plugin, and unset on ExitPre in Neovim
    return pane:get_user_vars().IS_NVIM == 'true'
  end

  local direction_keys = {
    Left = 'h',
    Down = 'j',
    Up = 'k',
    Right = 'l',
    -- reverse lookup
    h = 'Left',
    j = 'Down',
    k = 'Up',
    l = 'Right',
  }

  local function split_nav(resize_or_move, key)
    return {
      key = key,
      mods = resize_or_move == 'resize' and 'META' or 'CTRL',
      action = wezterm.action_callback(function(win, pane)
        if is_vim(pane) then
          -- pass the keys through to vim/nvim
          win:perform_action({
            SendKey = { key = key, mods = resize_or_move == 'resize' and 'META' or 'CTRL' },
          }, pane)
        else
          if resize_or_move == 'resize' then
            win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
          else
            win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
          end
        end
      end),
    }
  end

  return {
    keys = {
      -- move between split panes
      split_nav('move', 'h'),
      split_nav('move', 'j'),
      split_nav('move', 'k'),
      split_nav('move', 'l'),
      -- resize panes
      split_nav('resize', 'h'),
      split_nav('resize', 'j'),
      split_nav('resize', 'k'),
      split_nav('resize', 'l'),
    },
  }
end

return M
