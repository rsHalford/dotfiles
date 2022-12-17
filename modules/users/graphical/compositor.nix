{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.richard.graphical.compositor;
  screenshot = "${pkgs.scripts.screenshotTools}/bin/screenshot";
  terminal = config.richard.terminal.emulator.program;
  terminal-editor = config.richard.terminal.utilities.editor;
  graphical-editor = config.richard.graphical.utilities.editor;
  background = "232136";
  foreground = "e0def4";
  black = "393552"; # black base
  red = "eb6f92"; # red love
  green = "3e8fb0"; # green pine
  yellow = "f6c177"; # yellow gold
  blue = "9ccfd8"; # blue foam
  magenta = "c4a7e7"; # magenta iris
  cyan = "ea9a97"; # cyan rose
  white = "e0def4"; # white text
  inactive = "908caa";
in
{
  options.richard.graphical.compositor = {
    enable = mkOption {
      description = "Enable compositor";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    wayland = {
      windowManager = {
        sway = {
          enable = true;
          config = {
            bars = [{
              command = "\${pkgs.waybar}/bin/waybar";
              hiddenState = "show";
              mode = "hide";
            }];
            colors = {
              background = background;
              focused = {
                background = green;
                border = green;
                childBorder = green;
                indicator = magenta;
                text = white;
              };
              focusedInactive = {
                background = inactive;
                border = inactive;
                childBorder = inactive;
                indicator = inactive;
                text = white;
              };
              unfocused = {
                background = background;
                border = background;
                childBorder = background;
                indicator = background;
                text = white;
              };
              urgent = {
                background = yellow;
                border = yellow;
                childBorder = yellow;
                indicator = yellow;
                text = white;
              };
            };
            defaultWorkspace = "workspace number 1";
            floating = {
              border = 3;
              criteria = [
                { app_id = "pulsemixer"; }
                { app_id = "nmtui"; }
              ];
            };
            focus = {
              followMouse = "always";
              forceWrapping = true;
              mouseWarping = true;
            };
            fonts = {
              names = [ "JetBrainsMono Nerd Font" ];
              style = "Bold";
              size = 10.0;
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
              "Mod4+ShifT+e" = "exec ${graphical-editor}";
              "Mod4+f" = "exec ${terminal} -e newsboat";
              # "Mod4+g" = "steam";
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
              "Mod4+Shift+q" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' 'swaymsg exit'";
              "Mod4+r" = "exec retroarch";
              # "Mod4+Shift+r" = "newsboat";
              # "Mod4+s" = "exec signal-desktop --enable-features=UseOzonePlatform --ozone-platform=wayland";
              # "Mod4+Shift+s" = "passmenu";
              "Mod4+t" = "exec thunderbird";
              # "Mod4+Shift+t" = "qBittorent";
              "Mod4+u" = "mode resize";
              "Mod4+v" = "exec ${terminal} -e pulsemixer";
              "Mod4+Shift+v" = "exec mullvad-vpn";
              "Mod4+w" = "exec $BROWSER";
              "Mod4+Shift+w" = "exec ${terminal} -e nmtui";
              # "Mod4+Shift+x" = "exec ledger-live-desktop";

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

              "Mod4+Shift+minus" = "move scratchpad";
              "Mod4+minus" = "scratchpad show";

              "Print" = "exec ${screenshot}";
              "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
              "XF86MonBrightnessUp" = "exec brightnessctl set +5%";
              "XF86AudioMute" = "exec pulsemixer --toggle-mute";
              "XF86AudioRaiseVolume" = "exec pulsemixer --change-volume +5";
              "XF86AudioLowerVolume" = "exec pulsemixer --change-volume -5";
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
                bg = "~/Media/Pictures/Wallpapers/gruvbox-dark-rainbow.png fill";
              };
            };
            seat = {
              "*" = {
                hide_cursor = "5000";
                xcursor_theme = "Quintom_Ink";
              };
            };
            # startup = [ ]; # startup commands { command = ""; always = bool; }
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
            export SDL_VIDEODRIVER=wayland
            export QT_QPA_PLATFORM=wayland
            export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
            export _JAVA_AWT_WM_NONREPARENTING=1
          '';
          swaynag = {
            enable = true;
            # settings = { }; # swaynag(5)
          };
          systemdIntegration = true;
          wrapperFeatures = {
            gtk = true;
          };
          xwayland = true;
        };
      };
    };
  };
}
