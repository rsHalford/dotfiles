{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  screenshot = "${pkgs.scripts.screenshotTools}/bin/screenshot";
  browser2mpv = "${pkgs.scripts.mpvTools}/bin/browser2mpv";
  toggle-gammastep = "${pkgs.scripts.gammaTools}/bin/toggle-gammastep";
  terminal = config.richard.terminal.emulator.program;
  terminal-editor = config.richard.terminal.utilities.editor;
  graphical-editor = config.richard.graphical.utilities.editor;
  random-wallpaper = "${pkgs.scripts.wallpaperTools}/bin/random-wallpaper";
  theme = config.richard.theme.colors;
in {
  options.richard.graphical.compositor = {
    river.enable = mkOption {
      description = "Enable river compositor";
      type = types.bool;
      default = false;
    };
  };

  config = {
    home = {
      packages = with pkgs; [
        river
        rivercarro
        lswt
      ];
      file."${config.xdg.configHome}/river/init" = {
        executable = true;
        text = ''
          #!/bin/sh

          # Inputs
          ## Cursor
          riverctl focus-follows-cursor always
          riverctl hide-cursor timeout 5000
          riverctl hide-cursor when-typing enabled
          riverctl set-cursor-warp on-focus-change
          riverctl xcursor-theme Quintom_Ink 24

          ### pointer-2362-628-PIXA3854:00_093A:0274_Touchpad
          riverctl input pointer-2362-628-PIXA3854:00_093A:0274_Touchpad accel-profile flat
          riverctl input pointer-2362-628-PIXA3854:00_093A:0274_Touchpad pointer-accel 0.0
          # riverctl input pointer-2362-628-PIXA3854:00_093A:0274_Touchpad click-method ???
          riverctl input pointer-2362-628-PIXA3854:00_093A:0274_Touchpad drag-enabled enabled
          riverctl input pointer-2362-628-PIXA3854:00_093A:0274_Touchpad drag-lock enabled
          riverctl input pointer-2362-628-PIXA3854:00_093A:0274_Touchpad disable-while-typing enabled
          riverctl input pointer-2362-628-PIXA3854:00_093A:0274_Touchpad middle-emulation enabled
          riverctl input pointer-2362-628-PIXA3854:00_093A:0274_Touchpad natural-scroll enabled
          riverctl input pointer-2362-628-PIXA3854:00_093A:0274_Touchpad left-handed disabled
          riverctl input pointer-2362-628-PIXA3854:00_093A:0274_Touchpad tap enabled
          riverctl input pointer-2362-628-PIXA3854:00_093A:0274_Touchpad tap-button-map left-right-middle
          riverctl input pointer-2362-628-PIXA3854:00_093A:0274_Touchpad scroll-method two-finger

          ## Keyboard
          riverctl set-repeat 50 300

          ### keyboard-1-1-AT_Translated_Set_2_keyboard
          riverctl keyboard-layout -model "pc105" -options "caps:escape_shifted_capslock" "gb"

          ### keyboard-18003-1-foostan_Corne_Keyboard
          if ! riverctl list-inputs | grep keyboard-18003-1-foostan_Corne_Keyboard >/dev/null; then
            riverctl keyboard-layout us
          fi

          # Decorations
          riverctl background-color 0x${theme.base00}
          riverctl border-color-focused 0x${theme.base0D}
          riverctl border-color-unfocused 0x${theme.base03}
          riverctl border-color-urgent 0x${theme.base09}
          riverctl border-width 2

          riverctl attach-mode top

          # Rules
          # Make all views with an app-id that starts with "float" and title "foo" start floating.
          # riverctl rule-add -app-id 'ncmpcpp' float
          # riverctl rule-add -app-id 'ncpamixer' float
          # riverctl rule-add -app-id 'nmtui' float
          # riverctl rule-add -app-id 'steam' tile
          riverctl float-filter-add app-id "ncmpcpp"
          riverctl float-filter-add app-id "ncpamixer"
          riverctl float-filter-add app-id "nmtui"
          riverctl float-filter-add app-id "steam"
          riverctl csd-filter-remove app-id "*"

          # Mappings

          ## General
          riverctl map normal Super O toggle-fullscreen
          riverctl map normal Super I toggle-float
          riverctl map normal Super+Shift Return zoom
          riverctl map normal Super Q close
          # riverctl map normal Super+Shift Q exit
          riverctl map normal Super+Shift R spawn "${config.xdg.configHome}/river/init"

          ## Tags
          for i in $(seq 1 9)
          do
              tags=$((1 << ($i - 1)))
              riverctl map normal Super $i set-focused-tags $tags
              riverctl map normal Super+Shift $i set-view-tags $tags
              riverctl map normal Super F$i set-view-tags $tags
              riverctl map normal Super+Control $i toggle-focused-tags $tags
              riverctl map normal Super+Shift+Control $i toggle-view-tags $tags
              riverctl map normal Super+Control F$i toggle-view-tags $tags
          done

          all_tags=$(((1 << 32) - 1))
          riverctl map normal Super 0 set-focused-tags $all_tags
          riverctl map normal Super+Shift 0 set-view-tags $all_tags

          ## Focus
          riverctl map normal Super J focus-view next
          riverctl map normal Super K focus-view previous
          riverctl map normal Super Period focus-output next
          riverctl map normal Super Comma focus-output previous

          ## Tiled
          ### Swap
          riverctl map normal Super+Shift J swap next
          riverctl map normal Super+Shift K swap previous
          riverctl map normal Super+Shift Period send-to-output next
          riverctl map normal Super+Shift Comma send-to-output previous

          ### Location
          # Super+{Up,Right,Down,Left} to change layout orientation
          riverctl map normal Super Up send-layout-cmd rivercarro "main-location top"
          riverctl map normal Super Right send-layout-cmd rivercarro "main-location right"
          riverctl map normal Super Down send-layout-cmd rivercarro "main-location bottom"
          riverctl map normal Super Left send-layout-cmd rivercarro "main-location left"
          riverctl map normal Super+Shift M send-layout-cmd rivercarro "main-location monocle"

          ### Count
          riverctl map normal Super H send-layout-cmd rivercarro "main-count +1"
          riverctl map normal Super L send-layout-cmd rivercarro "main-count -1"

          ### Ratio
          riverctl map normal Super+Shift H send-layout-cmd rivercarro "main-ratio -0.05"
          riverctl map normal Super+Shift L send-layout-cmd rivercarro "main-ratio +0.05"

          ## Floating
          riverctl map-pointer normal Super BTN_LEFT move-view
          riverctl map-pointer normal Super BTN_RIGHT resize-view
          riverctl map-pointer normal Super BTN_MIDDLE toggle-float

          ## Spawn
          riverctl map normal Super Return spawn ${terminal}
          riverctl map normal Super A spawn "rofi -show drun"
          riverctl map normal Super+Shift A spawn "${terminal} -a ncmpcpp -T ncmpcpp -e ncmpcpp"
          riverctl map normal Super B spawn "${toggle-gammastep}"
          riverctl map normal Super+Shift B spawn blueman-manager
          riverctl map normal Super C spawn "hyprpicker -a -f hex"
          riverctl map normal Super E spawn "${terminal} -a ${terminal-editor} -T ${terminal-editor} -e ${terminal-editor}"
          riverctl map normal Super+Shift E spawn ${graphical-editor}
          riverctl map normal Super F spawn "${terminal} -a newsboat -T newsboat -e newsboat"
          riverctl map normal Super G spawn steam
          riverctl map normal Super M spawn "${terminal} -a aerc -T aerc -e aerc"
          riverctl map normal Super+Shift Q spawn "rofi -show power-menu"
          riverctl map normal Super S spawn "gopass ls --flat | rofi -dmenu | xargs --no-run-if-empty gopass show -c"
          riverctl map normal Super T spawn "${terminal} -e tmux-sessioniser"
          riverctl map normal Super V spawn "${terminal} -a ncpamixer -T ncpamixer -e ncpamixer"
          riverctl map normal Super+Shift V spawn mullvad-vpn
          riverctl map normal Super W spawn $BROWSER
          riverctl map normal Super+Shift W spawn "${terminal} -a nmtui -T nmtui -e nmtui"
          riverctl map normal Super X spawn swaylock
          riverctl map normal Super Y spawn ${browser2mpv}
          riverctl map normal None Print spawn ${screenshot}
          riverctl map normal Super Z spawn "grim - | zbarimg --quiet - | wl-copy"

          # Modes
          ## Locked
          for mode in normal locked
          do
              riverctl map -repeat $mode None XF86AudioRaiseVolume spawn "pamixer -i 5"
              riverctl map -repeat $mode None XF86AudioLowerVolume spawn "pamixer -d 5"
              riverctl map $mode None XF86AudioMute spawn "pamixer --toggle-mute"
              riverctl map $mode None XF86AudioMedia spawn "playerctl play-pause"
              riverctl map $mode None XF86AudioPlay spawn "playerctl play-pause"
              riverctl map $mode None XF86AudioPrev spawn "playerctl previous"
              riverctl map $mode None XF86AudioNext spawn "playerctl next"
              riverctl map -repeat $mode None XF86MonBrightnessUp spawn "brightnessctl set +5%"
              riverctl map -repeat $mode None XF86MonBrightnessDown spawn "brightnessctl set 5%-"
          done

          # Layouts
          ## Rivercarro
          riverctl default-layout rivercarro
          rivercarro -inner-gaps 0 -outer-gaps 0 &

          # Systemd
          riverctl spawn "${pkgs.dbus}/bin/dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=river"
          riverctl spawn "${pkgs.systemd}/bin/systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=river"

          # Autostart
          ${pkgs.kanshi}/bin/kanshi &
          ${pkgs.waybar}/bin/waybar &
          ${pkgs.gammastep}/bin/gammastep &
          ${random-wallpaper} &
          ${terminal} -e tmux new -s newsboat -c newsboat &
          ${terminal} -e tmux-sessioniser &
        '';
      };
    };
  };
}
