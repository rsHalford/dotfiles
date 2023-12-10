{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.richard.graphical.compositor;
  monospace = config.richard.fonts.monospace.name;
  screenshot = "${pkgs.scripts.screenshotTools}/bin/screenshot";
  browser2mpv = "${pkgs.scripts.mpvTools}/bin/browser2mpv";
  terminal = config.richard.terminal.emulator.program;
  terminal-editor = config.richard.terminal.utilities.editor;
  graphical-editor = config.richard.graphical.utilities.editor;
  random-wallpaper = "${pkgs.scripts.wallpaperTools}/bin/random-wallpaper";
  foreground = "c0caf5"; # white
  background = "1a1b26"; # black
  regular0 = "15161e"; # black
  regular1 = "f7768e"; # red
  regular2 = "9ece6a"; # green
  regular3 = "e0af68"; # yellow
  regular4 = "7aa2f7"; # blue
  regular5 = "bb9af7"; # magenta
  regular6 = "7dcfff"; # cyan
  regular7 = "a9b1d6"; # white
  bright0 = "414868"; # black
  bright7 = "c0caf5"; # white
  color16 = "ff9e64"; # orange
  color17 = "db4b4b"; # orange
in {
  options.richard.graphical.compositor = {
    sway.enable = mkOption {
      description = "Enable sway compositor";
      type = types.bool;
      default = false;
    };
  };

  config = {
    wayland = {
      windowManager = {
        sway = {
          enable = true;
          config = {
            assigns = {
              "1" = [{app_id = "mpv";}];
            };
            bars = [
              {
                command = "\${pkgs.waybar}/bin/waybar";
                hiddenState = "show";
                mode = "dock";
                position = "bottom";
              }
            ];
            colors = {
              background = background;
              focused = {
                background = regular4;
                border = regular4;
                childBorder = regular4;
                indicator = regular5;
                text = bright7;
              };
              focusedInactive = {
                background = bright0;
                border = bright0;
                childBorder = bright0;
                indicator = bright0;
                text = bright7;
              };
              unfocused = {
                background = background;
                border = background;
                childBorder = background;
                indicator = background;
                text = bright7;
              };
              urgent = {
                background = regular3;
                border = regular3;
                childBorder = regular3;
                indicator = regular3;
                text = bright7;
              };
            };
            defaultWorkspace = "workspace number 1";
            floating = {
              border = 3;
              criteria = [
                {app_id = "ncpamixer";}
                {app_id = "nmtui";}
                {class = "steam";}
              ];
            };
            focus = {
              followMouse = "always";
              wrapping = "yes";
              mouseWarping = true;
            };
            fonts = {
              names = ["${monospace} Nerd Font"];
              style = "Bold";
              size = 12.0;
            };
            gaps = {
              bottom = 5;
              horizontal = 5;
              inner = 5;
              left = 5;
              outer = 5;
              right = 5;
              smartBorders = "on";
              smartGaps = true;
              top = 5;
              vertical = 5;
            };
            input = {
              "1:1:AT_Translated_Set_2_keyboard" = {
                xkb_layout = "gb";
                xkb_model = "pc105";
                xkb_options = "caps:escape_shifted_capslock";
              };
              "2362:628:PIXA3854:00_093A:0274_Touchpad" = {
                accel_profile = "flat";
                dwt = "enabled";
                natural_scroll = "enabled";
                pointer_accel = "0.5";
                tap = "enabled";
              };
              "1267:29:Elan_Touchpad" = {
                accel_profile = "flat";
                dwt = "enabled";
                natural_scroll = "enabled";
                pointer_accel = "0.5";
                tap = "enabled";
              };
              "9494:32:CM_Storm_Quickfire_Rapid_i" = {
                xkb_options = "caps:escape_shifted_capslock";
              };
            };
            modifier = "Mod4";
            keybindings = {
              "Mod4+space" = "focus mode_toggle";
              "Mod4+Semicolon" = "splith";
              "Mod4+Return" = "exec ${terminal}";
              "Mod4+Shift+Return" = "focus parent";
              "Mod4+question" = "reload";

              "Mod4+a" = "exec rofi -show drun";
              "Mod4+Shift+a" = "exec ${terminal} -e ncmpcpp";
              "Mod4+b" = "exec ${terminal} -e pkill -USR1 gammastep";
              "Mod4+Shift+b" = "exec blueman-manager";
              "Mod4+c" = "exec element-desktop --enable-features=UseOzonePlatform --ozone-platform=wayland";
              # "Mod4+c" = "wyrd";
              # "Mod4+Shift+c" = "clipmenu";
              # "Mod4+d" = "discord";
              "Mod4+e" = "exec ${terminal} -e ${terminal-editor}";
              "Mod4+Shift+e" = "exec ${graphical-editor}";
              "Mod4+f" = "exec ${terminal} -e newsboat";
              "Mod4+g" = "exec steam";
              "Mod4+h" = "focus left";
              "Mod4+Shift+h" = "move left";
              "Mod4+i" = "floating toggle";
              "Mod4+j" = "focus down";
              "Mod4+Shift+j" = "move down";
              "Mod4+k" = "focus up";
              "Mod4+Shift+k" = "move up";
              "Mod4+l" = "focus right";
              "Mod4+Shift+l" = "move right";
              "Mod4+m" = "layout toggle split";
              "Mod4+n" = "splitv";
              "Mod4+o" = "fullscreen";
              "Mod4+p" = "exec swaymsg bar hidden_state toggle";
              "Mod4+q" = "kill";
              "Mod4+Shift+q" = "exec rofi -show power-menu";
              "Mod4+r" = "exec retroarch";
              # "Mod4+Shift+r" = "newsboat";
              # "Mod4+s" = "exec signal-desktop --enable-features=UseOzonePlatform --ozone-platform=wayland";
              "Mod4+Shift+s" = "exec gopass ls --flat | rofi -dmenu | xargs --no-run-if-empty gopass show -c";
              "Mod4+t" = "exec thunderbird";
              # "Mod4+Shift+t" = "qBittorent";
              "Mod4+u" = "mode resize";
              "Mod4+v" = "exec ${terminal} -e ncpamixer";
              "Mod4+Shift+v" = "exec mullvad-vpn";
              "Mod4+w" = "exec $BROWSER";
              "Mod4+Shift+w" = "exec ${terminal} -e nmtui";
              "Mod4+x" = "exec swaylock";
              # "Mod4+Shift+x" = "exec ledger-live-desktop";
              "Mod4+y" = "exec ${browser2mpv}";

              "Mod4+Up" = "focus up";
              "Mod4+Right" = "focus right";
              "Mod4+Down" = "focus down";
              "Mod4+Left" = "focus left";
              "Mod4+Shift+Up" = "move up";
              "Mod4+Shift+Right" = "move right";
              "Mod4+Shift+Down" = "move down";
              "Mod4+Shift+Left" = "move left";

              "Mod4+1" = "workspace number 1";
              "Mod4+2" = "workspace number 2";
              "Mod4+3" = "workspace number 3";
              "Mod4+4" = "workspace number 4";
              "Mod4+5" = "workspace number 5";
              "Mod4+6" = "workspace number 6";
              "Mod4+7" = "workspace number 7";
              "Mod4+8" = "workspace number 8";
              "Mod4+9" = "workspace number 9";
              "Mod4+0" = "workspace number 10";
              "Mod4+Shift+1" = "move container to workspace number 1";
              "Mod4+Shift+2" = "move container to workspace number 2";
              "Mod4+Shift+3" = "move container to workspace number 3";
              "Mod4+Shift+4" = "move container to workspace number 4";
              "Mod4+Shift+5" = "move container to workspace number 5";
              "Mod4+Shift+6" = "move container to workspace number 6";
              "Mod4+Shift+7" = "move container to workspace number 7";
              "Mod4+Shift+8" = "move container to workspace number 8";
              "Mod4+Shift+9" = "move container to workspace number 9";
              "Mod4+Shift+0" = "move container to workspace number 10";
              "Mod4+F1" = "move container to workspace number 1";
              "Mod4+F2" = "move container to workspace number 2";
              "Mod4+F3" = "move container to workspace number 3";
              "Mod4+F4" = "move container to workspace number 4";
              "Mod4+F5" = "move container to workspace number 5";
              "Mod4+F6" = "move container to workspace number 6";
              "Mod4+F7" = "move container to workspace number 7";
              "Mod4+F8" = "move container to workspace number 8";
              "Mod4+F9" = "move container to workspace number 9";
              "Mod4+F10" = "move container to workspace number 10";

              "Mod4+Shift+minus" = "move scratchpad";
              "Mod4+minus" = "scratchpad show";

              "Print" = "exec ${screenshot}";
              "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
              "XF86MonBrightnessUp" = "exec brightnessctl set +5%";
              "XF86AudioMute" = "exec pamixer --toggle-mute";
              "XF86AudioRaiseVolume" = "exec pamixer --increase 5";
              "XF86AudioLowerVolume" = "exec pamixer --decrease 5";
              "XF86AudioMicMute" = "exec amixer set Capture toggle";
              "XF86AudioPlay" = "exec playerctl play-pause";
              "XF86AudioStop" = "exec playerctl stop";
              "XF86AudioNext" = "exec playerctl next";
              "XF86AudioPrev" = "exec playerctl previous";
            };
            menu = "rofi -show drun";
            modes = {
              resize = {
                "h" = "resize shrink width 10px";
                "j" = "resize grow height 10px";
                "k" = "resize shrink height 10px";
                "l" = "resize grow width 10px";
                "Left" = "resize shrink width 10px";
                "Down" = "resize grow height 10px";
                "Up" = "resize shrink height 10px";
                "Right" = "resize grow width 10px";
                "Return" = "mode default";
                "Escape" = "mode default";
              };
            };
            output = {
              "*" = {
                # bg = "${random-wallpaper} fill";
              };
            };
            seat = {
              "*" = {
                hide_cursor = "5000";
                xcursor_theme = "Quintom_Ink";
              };
            };
            startup = [
              {
                command = "${random-wallpaper}";
                always = true;
              }
            ]; # startup commands { command = ""; always = bool; }
            terminal = "${terminal}";
            window = {
              border = 2;
              hideEdgeBorders = "smart";
              titlebar = false;
            };
            workspaceAutoBackAndForth = true;
          };
          extraConfig = ''
            exec_always autotiling
          '';
          # extraOptions = ""; # CLI arguments pass when sway launches
          extraSessionCommands = ''
            export SDL_VIDEODRIVER=wayland,x11
            export QT_QPA_PLATFORM=wayland
            export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
            export _JAVA_AWT_WM_NONREPARENTING=1
            export WLR_NO_HARDWARE_CURSORS=1
          '';
          swaynag = {
            enable = true;
            # settings = { }; # swaynag(5)
          };
          systemd.enable = true;
          wrapperFeatures = {
            gtk = true;
          };
          xwayland = true;
        };
      };
    };
  };
}
