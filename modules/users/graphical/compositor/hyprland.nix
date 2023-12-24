{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  screenshot = "${pkgs.scripts.screenshotTools}/bin/screenshot";
  browser2mpv = "${pkgs.scripts.mpvTools}/bin/browser2mpv";
  browser = config.richard.browser.http.preferred;
  browser-class =
    if browser == "brave"
    then "brave-browser"
    else browser;
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
    hyprland.enable = mkOption {
      description = "Enable hyprland compositor";
      type = types.bool;
      default = false;
    };
  };

  config = {
    wayland = {
      windowManager = {
        hyprland = {
          enable = true;
          extraConfig = ''
            # workspaces
            ${builtins.concatStringsSep "\n" (builtins.genList (
                x: let
                  ws = let
                    c = (x + 1) / 10;
                  in
                    builtins.toString (x + 1 - (c * 10));
                in ''
                  bind = SUPER, ${ws}, workspace, ${toString (x + 1)}
                  bind = SUPER_SHIFT, ${ws}, movetoworkspacesilent, ${toString (x + 1)}
                ''
              )
              10)}
            # resizing
            submap=resize
            binde=,right,resizeactive,20 0
            binde=,L,resizeactive,20 0
            binde=,left,resizeactive,-20 0
            binde=,H,resizeactive,-20 0
            binde=,up,resizeactive,0 -20
            binde=,K,resizeactive,0 -20
            binde=,down,resizeactive,0 20
            binde=,J,resizeactive,0 20
            binde=,escape,submap,reset
            submap=reset

            # windorules
            windowrulev2=opaque,class:(${browser-class})
            windowrulev2=opaque,class:(mpv)
            windowrulev2=opaque,class:(steam)
            windowrulev2=opaque,class:(virt-manager)
            windowrulev2=float,class:(ncmpcpp)
            windowrulev2=float,class:(ncpamixer)
            windowrulev2=float,class:(nmtui)
            windowrulev2=tile,class:(steam)
            windowrulev2=stayfocused,class:(steam)
            windowrulev2=stayfocused,class:(virt-manager)
            windowrulev2=workspace 1,class:(mpv)
          '';
          plugins = [];
          settings = {
            general = {
              no_border_on_floating = true;
              gaps_in = 5;
              gaps_out = 10;
              "col.active_border" = "rgb(${regular4}) rgb(${regular5}) 180deg";
              "col.inactive_border" = "rgb(${background})";
              cursor_inactive_timeout = 5;
              layout = "dwindle";
              no_focus_fallback = true;
              resize_on_border = true;
              extend_border_grab_area = 30;
              hover_icon_on_border = true;
            };
            dwindle = {
              no_gaps_when_only = 1;
            };
            decoration = {
              rounding = 10;
              active_opacity = "0.9";
              inactive_opacity = "0.6";
              fullscreen_opacity = "1.0";
              drop_shadow = true;
              shadow_range = 8;
              shadow_render_power = 2;
              "col.shadow" = "rgba(00000044)";
              blur = {
                enabled = true;
                size = 8;
                passes = 1;
              };
            };
            animations = {
              bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
              animation = [
                "windows, 1, 5, myBezier"
                "windowsOut, 1, 7, default, popin 80%"
                "border, 1, 10, default"
                "fade, 1, 7, default"
                "workspaces, 1, 6, default"
              ];
            };
            input = {
              kb_model = "pc105";
              kb_layout = "gb";
              kb_options = "caps:escape_shifted_capslock";
              accel_profile = "flat";
              scroll_method = "2fg";
              float_switch_override_focus = 2;
              touchpad = {
                natural_scroll = true;
                tap_button_map = "lrm";
                drag_lock = true;
                tap-and-drag = true;
              };
            };
            "device:foostan-corne" = {
              kb_layout = "us";
            };
            gestures = {
              workspace_swipe = true;
              workspace_swipe_direction_lock = false;
              workspace_swipe_forever = true;
              workspace_swipe_numbered = true;
            };
            misc = {
              disable_hyprland_logo = true;
              disable_splash_rendering = true;
              force_default_wallpaper = 0;
              vrr = 1;
            };
            xwayland = {
              force_zero_scaling = true;
            };
            exec-once = [
              "kanshi"
              "${random-wallpaper}"
              "[workspace 1 silent] ${terminal} -e tmux"
            ];
            env = [
              "SDL_VIDEODRIVER,wayland,x11"
              "QT_QPA_PLATFORM,wayland"
              "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
              "_JAVA_AWT_WM_NONREPARENTING,1"
              "WLR_NO_HARDWARE_CURSORS,1"
              "XCURSOR_THEME,Quintom_Ink"
            ];
            binds = {
              workspace_back_and_forth = true;
              allow_workspace_cycles = true;
            };
            bind = [
              "SUPER, O, fullscreen, 0"
              "SUPER_SHIFT, O, fullscreen, 1"
              "SUPER, I, togglefloating"
              "SUPER_SHIFT, I, fakefullscreen"
              "SUPER_SHIFT, U, toggleopaque"
              "SUPER, Q, killactive"
              "SUPER, H, movefocus, l"
              "SUPER, L, movefocus, r"
              "SUPER, J, movefocus, d"
              "SUPER, K, movefocus, u"
              "SUPER_SHIFT, H, movewindow, l"
              "SUPER_SHIFT, L, movewindow, r"
              "SUPER_SHIFT, J, movewindow, d"
              "SUPER_SHIFT, K, movewindow, u"
              "SUPER, Return, exec, ${terminal}"
              "SUPER, A, exec, rofi -show drun"
              "SUPER_SHIFT, A, exec, ${terminal} -a ncmpcpp -T ncmpcpp -e ncmpcpp"
              "SUPER, B, exec, ${terminal} -e pkill -USR1 gammastep"
              "SUPER_SHIFT, B, exec, blueman-manager"
              "SUPER, C, exec, hyprpicker -a -f hex"
              "SUPER, E, exec, ${terminal} -a ${terminal-editor} -T ${terminal-editor} -e ${terminal-editor}"
              "SUPER_SHIFT, E, exec, ${graphical-editor}"
              "SUPER, F, exec, ${terminal} -a newsboat -T newsboat -e newsboat"
              "SUPER, G, exec, steam"
              "SUPER_SHIFT, Q, exec, rofi -show power-menu"
              "SUPER_SHIFT, R, exec, hyprctl reload"
              "SUPER, S, exec, gopass ls --flat | rofi -dmenu | xargs --no-run-if-empty gopass show -c"
              "SUPER, T, exec, ${terminal} -e tmux-sessioniser"
              "SUPER, V, exec, ${terminal} -a ncpamixer -T ncpamixer -e ncpamixer"
              "SUPER_SHIFT, V, exec, mullvad-vpn"
              "SUPER, W, exec, $BROWSER"
              "SUPER_SHIFT, W, exec, ${terminal} -a nmtui -T nmtui -e nmtui"
              "SUPER, X, exec, swaylock"
              "SUPER, Y, exec, ${browser2mpv}"
              ", Print, exec, ${screenshot}"
              ", XF86AudioPlay, exec, playerctl play-pause"
              ", XF86AudioStop, exec, playerctl stop"
              ", XF86AudioNext, exec, playerctl next"
              ", XF86AudioPrev, exec, playerctl previous"
              "SUPER, U, submap, resize"
              "SUPER, F1, movetoworkspacesilent, 1"
              "SUPER, F2, movetoworkspacesilent, 2"
              "SUPER, F3, movetoworkspacesilent, 3"
              "SUPER, F4, movetoworkspacesilent, 4"
              "SUPER, F5, movetoworkspacesilent, 5"
              "SUPER, F6, movetoworkspacesilent, 6"
              "SUPER, F7, movetoworkspacesilent, 7"
              "SUPER, F8, movetoworkspacesilent, 8"
              "SUPER, F9, movetoworkspacesilent, 9"
              "SUPER, F10, movetoworkspacesilent, 10"
              "ALT, Tab, focuscurrentorlast"
            ];
            bindl = [
              ", XF86AudioMute, exec, pamixer --toggle-mute"
              ", XF86AudioMicMute, exec, amixer set Capture toggle"
            ];
            bindle = [
              ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
              ", XF86MonBrightnessUp, exec, brightnessctl set +5%"
              ", XF86AudioRaiseVolume, exec, pamixer --increase 5"
              ", XF86AudioLowerVolume, exec, pamixer --decrease 5"
            ];
            bindm = [
              "SUPER, mouse:272, movewindow"
              "SUPER, mouse:273, resizewindow"
            ];
          };
          xwayland.enable = true;
        };
      };
    };
  };
}
