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
  toggle-gammastep = "${pkgs.scripts.gammaTools}/bin/toggle-gammastep";
  terminal = config.richard.terminal.emulator.program;
  terminal-editor = config.richard.terminal.utilities.editor;
  graphical-editor = config.richard.graphical.utilities.editor;
  random-wallpaper = "${pkgs.scripts.wallpaperTools}/bin/random-wallpaper";
  theme = config.richard.theme;
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
              background = theme.colors.base00;
              focused = {
                background = theme.colors.base0D;
                border = theme.colors.base0D;
                childBorder = theme.colors.base0D;
                indicator = theme.colors.base0E;
                text = theme.colors.base05;
              };
              focusedInactive = {
                background = theme.colors.base03;
                border = theme.colors.base03;
                childBorder = theme.colors.base03;
                indicator = theme.colors.base03;
                text = theme.colors.base05;
              };
              unfocused = {
                background = theme.colors.base00;
                border = theme.colors.base00;
                childBorder = theme.colors.base00;
                indicator = theme.colors.base00;
                text = theme.colors.base05;
              };
              urgent = {
                background = theme.colors.base0A;
                border = theme.colors.base0A;
                childBorder = theme.colors.base0A;
                indicator = theme.colors.base0A;
                text = theme.colors.base05;
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
            keybindings = let
              mod = config.wayland.windowManager.sway.config.modifier;
            in {
              "${mod}+space" = "focus mode_toggle";
              "${mod}+Semicolon" = "splith";
              "${mod}+Return" = "exec ${terminal}";
              "${mod}+Shift+Return" = "focus parent";
              "${mod}+question" = "reload";

              "${mod}+a" = "exec rofi -show drun";
              "${mod}+Shift+a" = "exec ${terminal} -a ncmpcpp -T ncmpcpp -e ncmpcpp";
              "${mod}+b" = "exec ${toggle-gammastep}";
              "${mod}+Shift+b" = "exec blueman-manager";
              "${mod}+c" = "hyprpicker -a -f hex";
              "${mod}+e" = "exec ${terminal} -a ${terminal-editor} -T ${terminal-editor} -e ${terminal-editor}";
              "${mod}+Shift+e" = "exec ${graphical-editor}";
              "${mod}+f" = "exec ${terminal} -a newsboat -T newsboat -e newsboat";
              "${mod}+g" = "exec steam";
              "${mod}+h" = "focus left";
              "${mod}+Shift+h" = "move left";
              "${mod}+i" = "floating toggle";
              "${mod}+j" = "focus down";
              "${mod}+Shift+j" = "move down";
              "${mod}+k" = "focus up";
              "${mod}+Shift+k" = "move up";
              "${mod}+l" = "focus right";
              "${mod}+Shift+l" = "move right";
              "${mod}+m" = "layout toggle split";
              "${mod}+n" = "splitv";
              "${mod}+o" = "fullscreen";
              "${mod}+p" = "exec swaymsg bar hidden_state toggle";
              "${mod}+q" = "kill";
              "${mod}+Shift+q" = "exec rofi -show power-menu";
              "${mod}+Shift+r" = "reload";
              "${mod}+s" = "exec gopass ls --flat | rofi -dmenu | xargs --no-run-if-empty gopass show -c";
              "${mod}+t" = "exec ${terminal} -e tmux-sessioniser";
              "${mod}+u" = "mode resize";
              "${mod}+v" = "exec ${terminal} -a ncpamixer -T ncpamixer -e ncpamixer";
              "${mod}+Shift+v" = "exec mullvad-vpn";
              "${mod}+w" = "exec $BROWSER";
              "${mod}+Shift+w" = "exec ${terminal} -a nmtui -T nmtui -e nmtui";
              "${mod}+x" = "exec swaylock";
              "${mod}+y" = "exec ${browser2mpv}";

              "${mod}+Up" = "focus up";
              "${mod}+Right" = "focus right";
              "${mod}+Down" = "focus down";
              "${mod}+Left" = "focus left";
              "${mod}+Shift+Up" = "move up";
              "${mod}+Shift+Right" = "move right";
              "${mod}+Shift+Down" = "move down";
              "${mod}+Shift+Left" = "move left";

              "${mod}+1" = "workspace number 1";
              "${mod}+2" = "workspace number 2";
              "${mod}+3" = "workspace number 3";
              "${mod}+4" = "workspace number 4";
              "${mod}+5" = "workspace number 5";
              "${mod}+6" = "workspace number 6";
              "${mod}+7" = "workspace number 7";
              "${mod}+8" = "workspace number 8";
              "${mod}+9" = "workspace number 9";
              "${mod}+0" = "workspace number 10";
              "${mod}+Shift+1" = "move container to workspace number 1";
              "${mod}+Shift+2" = "move container to workspace number 2";
              "${mod}+Shift+3" = "move container to workspace number 3";
              "${mod}+Shift+4" = "move container to workspace number 4";
              "${mod}+Shift+5" = "move container to workspace number 5";
              "${mod}+Shift+6" = "move container to workspace number 6";
              "${mod}+Shift+7" = "move container to workspace number 7";
              "${mod}+Shift+8" = "move container to workspace number 8";
              "${mod}+Shift+9" = "move container to workspace number 9";
              "${mod}+Shift+0" = "move container to workspace number 10";
              "${mod}+F1" = "move container to workspace number 1";
              "${mod}+F2" = "move container to workspace number 2";
              "${mod}+F3" = "move container to workspace number 3";
              "${mod}+F4" = "move container to workspace number 4";
              "${mod}+F5" = "move container to workspace number 5";
              "${mod}+F6" = "move container to workspace number 6";
              "${mod}+F7" = "move container to workspace number 7";
              "${mod}+F8" = "move container to workspace number 8";
              "${mod}+F9" = "move container to workspace number 9";
              "${mod}+F10" = "move container to workspace number 10";

              "${mod}+Shift+minus" = "move scratchpad";
              "${mod}+minus" = "scratchpad show";

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
