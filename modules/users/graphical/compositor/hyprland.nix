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
                  bind = SUPER_SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}
                ''
              )
              10)}
            # resizing
            submap=resize
            binde=,right,resizeactive,10 0
            binde=,L,resizeactive,10 0
            binde=,left,resizeactive,-10 0
            binde=,H,resizeactive,-10 0
            binde=,up,resizeactive,0 -10
            binde=,K,resizeactive,0 -10
            binde=,down,resizeactive,0 10
            binde=,J,resizeactive,0 10
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
              border_size = 2;
              no_border_on_floating = true;
              gaps_in = 5;
              gaps_out = 5;
              # gaps_workspaces = 0;
              "col.inactive_border" = "rgb(${background})";
              "col.active_border" = "rgb(${regular4})";
              "col.nogroup_border" = "rgb(${regular3})";
              cursor_inactive_timeout = 5;
              layout = "dwindle";
              no_cursor_warps = false;
              no_focus_fallback = true;
              resize_on_border = true;
              extend_border_grab_area = true;
              hover_icon_on_border = true;
            };
            decoration = {
              rounding = 0;
              active_opacity = "0.9";
              inactive_opacity = "0.6";
              fullscreen_opacity = "1.0";
              drop_shadow = true;
              shadow_range = 8;
              shadow_render_power = 3;
              shadow_ignore_window = true;
              "col.shadow" = "0xee1a1a1a";
              # "col.shadow_inactive" = null;
              shadow_offset = "[0, 0]";
              shadow_scale = "1.0";
              dim_inactive = false;
              dim_strength = "0.5";
              dim_special = "0.2";
              dim_around = "0.4";
              blur = {
                enabled = true;
                size = 8;
                passes = 1;
                ignore_opacity = false;
                new_optimizations = true;
                xray = false;
                noise = "0.0117";
                contrast = "0.8916";
                brightness = "0.8172";
                vibrancy = "0.1696";
                vibrancy_darkness = "0.0";
                special = false;
              };
            };
            animations = {
              enabled = true;
              # first_launch_animation = true;
            };
            input = {
              kb_model = "pc105";
              kb_layout = "gb";
              kb_options = "caps:escape_shifted_capslock";
              accel_profile = "flat";
              scroll_method = "2fg";
              natural_scroll = false;
              follow_mouse = 1;
              mouse_refocus = true;
              float_switch_override_focus = 2;
              touchpad = {
                disable_while_typing = true;
                natural_scroll = true;
                scroll_factor = "1.0";
                middle_button_emulation = false;
                tap_button_map = "lrm";
                clickfinger_behavior = false;
                tap-to-click = true;
                drag_lock = true;
                tap-and-drag = true;
              };
            };
            "device:foostan-corne" = {
              kb_layout = "us";
            };
            gestures = {
              workspace_swipe = true;
              workspace_swipe_fingers = 3;
              workspace_swipe_distance = 300;
              workspace_swipe_invert = true;
              workspace_swipe_min_speed_to_force = 30;
              workspace_swipe_cancel_ratio = "0.5";
              workspace_swipe_create_new = true;
              workspace_swipe_direction_lock = true;
              workspace_swipe_direction_lock_threshold = 10;
              workspace_swipe_forever = false;
              workspace_swipe_numbered = false;
              workspace_swipe_use_r = false;
            };
            misc = {
              disable_hyprland_logo = true;
              disable_splash_rendering = false;
              force_default_wallpaper = "-1";
              vrr = 1;
              animate_manual_resizes = true;
              animate_mouse_windowdragging = true;
              focus_on_activate = false;
              no_direct_scanout = true;
              hide_cursor_on_touch = true;
              mouse_move_focuses_monitor = true;
              new_window_takes_over_fullscreen = 2;
            };
            xwayland = {
              force_zero_scaling = true;
            };
            exec-once = [
              "${random-wallpaper}"
              "[workspace 1 silent] ${terminal} -e tmux"
              "[workspace 2 silent] ${browser}"
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
              workspace_center_on = 1;
              focus_preferred_method = 0;
            };
            bind = [
              "SUPER, O, fullscreen"
              "SUPER_SHIFT, O, fakefullscreen"
              "SUPER, I, togglefloating"
              "SUPER_SHIFT, I, toggleopaque"
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
              "SUPER, E, exec, ${terminal} -a ${terminal-editor} -T ${terminal-editor} -e ${terminal-editor}"
              "SUPER_SHIFT, E, exec, ${graphical-editor}"
              "SUPER, F, exec, ${terminal} -a newsboat -T newsboat -e newsboat"
              "SUPER, G, exec, steam"
              "SUPER_SHIFT, Q, exec, rofi -show power-menu"
              "SUPER, R, exec, retroarch"
              "SUPER_SHIFT, S, exec, gopass ls --flat | rofi -dmenu | xargs --no-run-if-empty gopass show -c"
              "SUPER, V, exec, ${terminal} -a ncpamixer -T ncpamixer -e ncpamixer"
              "SUPER_SHIFT, V, exec, mullvad-vpn"
              "SUPER, W, exec, $BROWSER"
              "SUPER_SHIFT, W, exec, ${terminal} -a nmtui -T nmtui -e nmtui"
              "SUPER, X, exec, swaylock"
              "SUPER, Y, exec, ${browser2mpv}"
              ", Print, exec, ${screenshot}"
              ", XF86AudioMute, exec, pamixer --toggle-mute"
              ", XF86AudioMicMute, exec, amixer set Capture toggle"
              ", XF86AudioPlay, exec, playerctl play-pause"
              ", XF86AudioStop, exec, playerctl stop"
              ", XF86AudioNext, exec, playerctl next"
              ", XF86AudioPrev, exec, playerctl previous"
              "SUPER, U, submap, resize"
              "SUPER, F1, movetoworkspace, 1"
              "SUPER, F2, movetoworkspace, 2"
              "SUPER, F3, movetoworkspace, 3"
              "SUPER, F4, movetoworkspace, 4"
              "SUPER, F5, movetoworkspace, 5"
              "SUPER, F6, movetoworkspace, 6"
              "SUPER, F7, movetoworkspace, 7"
              "SUPER, F8, movetoworkspace, 8"
              "SUPER, F9, movetoworkspace, 9"
              "SUPER, F10, movetoworkspace, 0"
            ];
            binde = [
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
