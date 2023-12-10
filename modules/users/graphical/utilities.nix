{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.richard.graphical.utilities;
  monospace = config.richard.fonts.monospace;
  terminal = config.richard.terminal.emulator.program;
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
  options.richard.graphical.utilities = {
    enable = mkOption {
      description = "Enable graphical utilities";
      type = types.bool;
      default = false;
    };

    editor = mkOption {
      description = "Choose your preferred graphical editor";
      type = types.enum ["emacs" "emacsclient -c"];
      default = "emacs";
    };
  };

  config = mkIf (cfg.enable) {
    home = {
      packages = with pkgs; [
        autotiling
        grim
        hyprpicker
        qt6.qtwayland
        scripts.wallpaperTools
        slurp
        swww
        tag
        waybar
        wl-clipboard
      ];
      pointerCursor = {
        gtk.enable = true;
        x11.enable = true;
        package = pkgs.quintom-cursor-theme;
        name = "Quintom_Ink";
        size = 16;
      };
    };
    programs = {
      swaylock.settings = {
        show-failed-attempts = true;
        color = regular0;
        font = "${monospace.name} Nerd Font";
        font-size = 24;
        indicator-idle-visible = false;
      };
      waybar = {
        enable = true;
        settings = [
          {
            layer = "top";
            position = "bottom";
            height = 20;
            spacing = 0;
            fixed-center = false;
            ipc = true;
            modules-left = [
              "hyprland/workspaces"
              "sway/workspaces"
              "hyprland/submap"
              "sway/mode"
            ];
            "sway/workspaces" = {
              disable-scroll = true;
            };
            "hyprland/submap" = {
              format = "<span style=\"italic\">{}</span>";
            };
            "sway/mode" = {
              format = "<span style=\"italic\">{}</span>";
            };
            modules-center = ["hyprland/window" "sway/window"];
            modules-right = [
              "mpris"
              "temperature"
              "cpu"
              "memory"
              "disk"
              "pulseaudio"
              "network"
              "battery"
              "tray"
              "clock"
            ];
            "battery" = {
              format = "{icon}";
              format-charging = "{icon}";
              format-time = "{H}:{M}";
              format-icons = {
                default = [
                  "<span font='14' color='#${regular1}'>󰂎</span>"
                  "<span font='14' color='#${color17}'>󰁺</span>"
                  "<span font='14' color='#${color17}'>󰁻</span>"
                  "<span font='14' color='#${color16}'>󰁼</span>"
                  "<span font='14' color='#${color16}'>󰁽</span>"
                  "<span font='14' color='#${regular3}'>󰁾</span>"
                  "<span font='14' color='#${regular6}'>󰁿</span>"
                  "<span font='14' color='#${regular4}'>󰂀</span>"
                  "<span font='14' color='#${regular5}'>󰂁</span>"
                  "<span font='14' color='#${regular5}'>󰂂</span>"
                  "<span font='14' color='#${regular5}'>󰁹</span>"
                ];
                charging = [
                  "<span font='14' color='#${regular2}'>󰂆 </span>"
                  "<span font='14' color='#${regular2}'>󰂇 </span>"
                  "<span font='14' color='#${regular2}'>󰂈 </span>"
                  "<span font='14' color='#${regular2}'>󰂉 </span>"
                  "<span font='14' color='#${regular2}'>󰂊 </span>"
                  "<span font='14' color='#${regular2}'>󰂋 </span>"
                  "<span font='14' color='#${regular2}'>󰂅 </span>"
                ];
              };
              # on-click = ""; # tlp powersave
              tooltip-format = "{capacity}%";
            };
            "clock" = {
              format = "<span font='14' color='#${regular3}'>󰃰</span> {:%H:%M}";
              tooltip-format = "<tt><small>{calendar}</small></tt>";
              # on-click = "${terminal} -e khal";
              calendar = {
                mode = "month";
                weeks-pos = "right";
                on-scroll = 1;
                format = {
                  weeks = "<span color='#${regular6}'><b>W{}</b></span>";
                  weekdays = "<span color='#${regular4}'><b>{}</b></span>";
                  today = "<span color='#${color16}'><b>{}</b></span>";
                };
              };
            };
            "cpu" = {
              format = "<span font='14' color='#${regular4}'>󰍛</span> {usage}%";
              on-click = "btm";
            };
            "disk" = {
              path = "/";
              format = "<span font='14' color='#${regular3}'>󰉉</span> {percentage_used}%";
              tooltip-format = "{used} / {total}";
              on-click = "btm";
            };
            "memory" = {
              format = "<span font='14' color='#${regular5}'>󰘚</span> {percentage}%";
              tooltip-format = "{used:0.1f}GiB / {total:0.1f}GiB";
              on-click = "btm";
            };
            "mpris" = {
              format = "{player_icon} <span color='#${regular3}'>\"{title}\"</span> by <span color='#${regular5}'>{artist}</span>";
              format-paused = "{status_icon} \"{title}\" by {artist}";
              player-icons = {
                "default" = "<span color='#${regular2}'>⏵</span>";
                "mpv" = "<span color='#${regular2}'>⏵</span>";
                "mpd" = "<span color='#${regular6}'>⏵</span>";
              };
              status-icons = {
                "paused" = "<span color='#${color16}'>⏸</span>";
              };
              title-len = 25;
            };
            "network" = {
              format-wifi = "{icon}";
              tooltip-format-wifi = "{essid} {signalStrength}%\n{ipaddr}/{cidr}";
              format-ethernet = "{icon}";
              tooltip-format-ethernet = "{essid}\n{ipaddr}/{cidr}";
              format-disconnected = "{icon}";
              format-linked = "{icon}";
              format-disabled = "{icon}";
              format-icons = {
                wifi = "<span font='14' color='#${regular2}'>󰖩</span>";
                ethernet = "<span font='14' color='#${regular5}'>󰈀</span>";
                linked = "<span font='14' color='#${regular6}'>󰌹</span>";
                disconnected = "<span font='14' color='#${color16}'>󱚵</span>";
                disabled = "<span font='14' color='#${regular1}'>󰖪</span>";
              };
              on-click = "nmtui";
            };
            "pulseaudio" = {
              format = "{icon}";
              format-muted = "<span font='14' color='#${regular1}'>󰝟</span>";
              format-bluetooth = "<span font='14' color='#${regular4}'>󰂰</span>";
              format-bluetooth-muted = "<span font='14' color='#${regular1}'>󰂲</span>";
              format-source = "<span font='14' color='#${regular7}'></span>";
              format-source-muted = "<span font='14' color='#${regular1}'></span>";
              format-icons = {
                default = [
                  "<span font='14' color='#${regular1}'>󰖁</span>"
                  "<span font='14' color='#${regular7}'>󰕿</span>"
                  "<span font='14' color='#${regular7}'>󰕿</span>"
                  "<span font='14' color='#${regular7}'>󰕿</span>"
                  "<span font='14' color='#${regular7}'>󰕿</span>"
                  "<span font='14' color='#${regular7}'>󰖀</span>"
                  "<span font='14' color='#${regular7}'>󰖀</span>"
                  "<span font='14' color='#${regular7}'>󰖀</span>"
                  "<span font='14' color='#${regular7}'>󰖀</span>"
                  "<span font='14' color='#${regular7}'>󰖀</span>"
                  "<span font='14' color='#${regular7}'>󰖀</span>"
                  "<span font='14' color='#${regular7}'>󰖀</span>"
                  "<span font='14' color='#${regular7}'>󰕾</span>"
                  "<span font='14' color='#${regular7}'>󰕾</span>"
                  "<span font='14' color='#${regular7}'>󰕾</span>"
                  "<span font='14' color='#${regular7}'>󰕾</span>"
                  "<span font='14' color='#${regular7}'>󰕾</span>"
                  "<span font='14' color='#${regular7}'>󰕾</span>"
                  "<span font='14' color='#${regular7}'>󰕾</span>"
                  "<span font='14' color='#${regular7}'>󰕾</span>"
                ];
                headset = "󰋎";
                # hifi = "󰓃";
                # hmdi = "󰡁";
                # speaker = "󰓃";
              };
              on-click = "ncpamixer";
              scroll-step = 1.0;
              tooltip-format = "{desc}: {volume}%";
            };
            "temperature" = {
              hwmon-path-abs = "/sys/devices/pci0000:00/0000:00:18.3/hwmon";
              input-filename = "temp1_input";
              critical-threshold = 100;
              format = "{icon} {temperatureC}°C";
              format-icons = [
                "<span font='12' color='#${regular2}'></span>"
                "<span font='12' color='#${regular3}'></span>"
                "<span font='12' color='#${color16}'></span>"
                "<span font='12' color='#${color17}'></span>"
                "<span font='12' color='#${regular1}'></span>"
              ];
            };
            "tray" = {
              icon-size = 16;
              show-passive-items = false;
              spacing = 18;
            };
          }
        ];
        style = ''
          * {
            font-family: ${monospace.name} Nerd Font;
            font-size: 14pt;
          }

          window#waybar {
            background-color: #${background};
            color: #${bright7};
          }

          #window,
          #workspaces {
            margin: 0 4px;
          }

          .modules-left > widget:first-child > #workspaces {
            margin-left: 0;
          }

          #workspaces button {
            all: initial;
            padding: 0 8px;
            background-color: #${background};
            color: #${foreground};
            border: none;
            border-radius: 0;
            box-shadow: none;
            text-shadow: none;
          }

          #workspaces button:hover {
            background-color: #${foreground};
            color: #${background};
          }

          #workspaces button.active,
          #workspaces button.focused {
            background-color: #${regular4};
            color: #${background};
          }

          #workspaces button.active:hover,
          #workspaces button.focused:hover {
            background-color: #${regular4};
            color: #${bright7};
          }

          #workspaces button.urgent {
            background-color: #${color16};
            color: #${background};
          }

          #workspaces button.urgent:hover {
            background-color: #${color17};
            color: #${background};
          }

          #mode {
            background: #${background};
            border-top: 3px solid #${bright7};
          }

          #battery,
          #clock,
          #cpu,
          #disk,
          #memory,
          #network,
          #pulseaudio,
          #temperature,
          #tray {
            padding: 0 8pt;
            background: #${background};
            color: #${foreground};
          }

          #mpris {
            padding: 0 8pt;
            border-radius: 0;
            color: #${regular7};
            background: #${regular0};
          }

          tooltip {
            background-color: #${background};
            color: #${regular7};
            border: 2px solid #${regular4};
            border-radius: 3px;
          }
        '';
        systemd.enable = true;
      };
    };
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
    gtk = {
      enable = true;
      cursorTheme = {
        package = pkgs.quintom-cursor-theme;
        name = "Quintom_Ink";
        size = 16;
      };
      font = {
        package = with pkgs; (nerdfonts.override {fonts = ["${monospace.pkg}"];});
        name = "${monospace.name} Nerd Font";
        size = 13;
      };
      gtk2 = {
        configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
        extraConfig = "";
      };
      gtk3 = {
        extraConfig = {};
        extraCss = ''
          menu {
            border-radius: 10px;
            border: 2px solid #${regular5};
          }
        '';
      };
      gtk4 = {
        extraConfig = {};
      };
      iconTheme = {
        package = pkgs.papirus-icon-theme;
        name = "Papirus Dark";
      };
      theme = {
        package = pkgs.tokyo-night-gtk;
        name = "Tokyonight-Dark-BL";
      };
    };
  };
}
