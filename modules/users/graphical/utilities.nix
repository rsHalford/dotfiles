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
  theme = config.richard.theme;
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
        wl-clipboard
      ];
      pointerCursor = {
        gtk.enable = true;
        x11.enable = true;
        package = pkgs.quintom-cursor-theme;
        name = "Quintom_Ink";
        size = 24;
      };
    };
    programs = {
      swaylock.settings = {
        show-failed-attempts = true;
        color = theme.regular0;
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
                  "<span font='14' color='#${theme.regular1}'>󰂎</span>"
                  "<span font='14' color='#${theme.color17}'>󰁺</span>"
                  "<span font='14' color='#${theme.color17}'>󰁻</span>"
                  "<span font='14' color='#${theme.color16}'>󰁼</span>"
                  "<span font='14' color='#${theme.color16}'>󰁽</span>"
                  "<span font='14' color='#${theme.regular3}'>󰁾</span>"
                  "<span font='14' color='#${theme.regular6}'>󰁿</span>"
                  "<span font='14' color='#${theme.regular4}'>󰂀</span>"
                  "<span font='14' color='#${theme.regular5}'>󰂁</span>"
                  "<span font='14' color='#${theme.regular5}'>󰂂</span>"
                  "<span font='14' color='#${theme.regular5}'>󰁹</span>"
                ];
                charging = [
                  "<span font='14' color='#${theme.regular2}'>󰂆 </span>"
                  "<span font='14' color='#${theme.regular2}'>󰂇 </span>"
                  "<span font='14' color='#${theme.regular2}'>󰂈 </span>"
                  "<span font='14' color='#${theme.regular2}'>󰂉 </span>"
                  "<span font='14' color='#${theme.regular2}'>󰂊 </span>"
                  "<span font='14' color='#${theme.regular2}'>󰂋 </span>"
                  "<span font='14' color='#${theme.regular2}'>󰂅 </span>"
                ];
              };
              # on-click = ""; # tlp powersave
              tooltip-format = "{capacity}%";
            };
            "clock" = {
              format = "<span font='14' color='#${theme.regular3}'>󰃰</span> {:%H:%M}";
              tooltip-format = "<tt><small>{calendar}</small></tt>";
              # on-click = "${terminal} -e khal";
              calendar = {
                mode = "month";
                weeks-pos = "right";
                on-scroll = 1;
                format = {
                  weeks = "<span color='#${theme.regular6}'><b>W{}</b></span>";
                  weekdays = "<span color='#${theme.regular4}'><b>{}</b></span>";
                  today = "<span color='#${theme.color16}'><b>{}</b></span>";
                };
              };
            };
            "cpu" = {
              format = "<span font='14' color='#${theme.regular4}'>󰍛</span> {usage}%";
              on-click = "btm";
            };
            "disk" = {
              path = "/";
              format = "<span font='14' color='#${theme.regular3}'>󰉉</span> {percentage_used}%";
              tooltip-format = "{used} / {total}";
              on-click = "btm";
            };
            "memory" = {
              format = "<span font='14' color='#${theme.regular5}'>󰘚</span> {percentage}%";
              tooltip-format = "{used:0.1f}GiB / {total:0.1f}GiB";
              on-click = "btm";
            };
            "mpris" = {
              format = "{player_icon} <span color='#${theme.regular3}'>\"{title}\"</span> - <span color='#${theme.regular5}'>{artist}</span>";
              format-paused = "{status_icon} \"{title}\" - {artist}";
              player-icons = {
                "default" = "<span color='#${theme.regular2}'>⏵</span>";
                "mpv" = "<span color='#${theme.regular2}'>⏵</span>";
                "mpd" = "<span color='#${theme.regular6}'>⏵</span>";
              };
              status-icons = {
                "paused" = "<span color='#${theme.color16}'>⏸</span>";
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
                wifi = "<span font='14' color='#${theme.regular2}'>󰖩</span>";
                ethernet = "<span font='14' color='#${theme.regular5}'>󰈀</span>";
                linked = "<span font='14' color='#${theme.regular6}'>󰌹</span>";
                disconnected = "<span font='14' color='#${theme.color16}'>󱚵</span>";
                disabled = "<span font='14' color='#${theme.regular1}'>󰖪</span>";
              };
              on-click = "nmtui";
            };
            "pulseaudio" = {
              format = "{icon}";
              format-muted = "<span font='14' color='#${theme.regular1}'>󰝟</span>";
              format-bluetooth = "<span font='14' color='#${theme.regular4}'>󰂰</span>";
              format-bluetooth-muted = "<span font='14' color='#${theme.regular1}'>󰂲</span>";
              format-source = "<span font='14' color='#${theme.regular7}'></span>";
              format-source-muted = "<span font='14' color='#${theme.regular1}'></span>";
              format-icons = {
                default = [
                  "<span font='14' color='#${theme.regular1}'>󰖁</span>"
                  "<span font='14' color='#${theme.regular7}'>󰕿</span>"
                  "<span font='14' color='#${theme.regular7}'>󰕿</span>"
                  "<span font='14' color='#${theme.regular7}'>󰕿</span>"
                  "<span font='14' color='#${theme.regular7}'>󰕿</span>"
                  "<span font='14' color='#${theme.regular7}'>󰖀</span>"
                  "<span font='14' color='#${theme.regular7}'>󰖀</span>"
                  "<span font='14' color='#${theme.regular7}'>󰖀</span>"
                  "<span font='14' color='#${theme.regular7}'>󰖀</span>"
                  "<span font='14' color='#${theme.regular7}'>󰖀</span>"
                  "<span font='14' color='#${theme.regular7}'>󰖀</span>"
                  "<span font='14' color='#${theme.regular7}'>󰖀</span>"
                  "<span font='14' color='#${theme.regular7}'>󰕾</span>"
                  "<span font='14' color='#${theme.regular7}'>󰕾</span>"
                  "<span font='14' color='#${theme.regular7}'>󰕾</span>"
                  "<span font='14' color='#${theme.regular7}'>󰕾</span>"
                  "<span font='14' color='#${theme.regular7}'>󰕾</span>"
                  "<span font='14' color='#${theme.regular7}'>󰕾</span>"
                  "<span font='14' color='#${theme.regular7}'>󰕾</span>"
                  "<span font='14' color='#${theme.regular7}'>󰕾</span>"
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
                "<span font='12' color='#${theme.regular2}'></span>"
                "<span font='12' color='#${theme.regular3}'></span>"
                "<span font='12' color='#${theme.color16}'></span>"
                "<span font='12' color='#${theme.color17}'></span>"
                "<span font='12' color='#${theme.regular1}'></span>"
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
          }

          window#waybar {
            background-color: #${theme.background};
            color: #${theme.bright7};
          }

          #window,
          #workspaces {
            margin: 0 4px;
            font-size: 14pt;
          }

          .modules-left > widget:first-child > #workspaces {
            margin-left: 0;
          }

          #tags button,
          #workspaces button {
            all: initial;
            padding: 0 8px;
            background-color: #${theme.background};
            color: #${theme.foreground};
            border: none;
            border-radius: 0;
            box-shadow: none;
            text-shadow: none;
          }

          #tags button:hover,
          #workspaces button:hover {
            background-color: #${theme.foreground};
            color: #${theme.background};
          }

          #tags button.focused,
          #workspaces button.active,
          #workspaces button.focused {
            background-color: #${theme.regular4};
            color: #${theme.background};
          }

          #tags button.focused:hover,
          #workspaces button.active:hover,
          #workspaces button.focused:hover {
            background-color: #${theme.regular4};
            color: #${theme.bright7};
          }

          #tags button:not(.occupied):not(.focused) {
	          font-size: 0;
	          min-width: 0;
	          min-height: 0;
	          padding: 0 0;
	          border: 0;
          }

          #tags button.urgent,
          #workspaces button.urgent {
            background-color: #${theme.color16};
            color: #${theme.background};
          }

          #tags button.urgent:hover,
          #workspaces button.urgent:hover {
            background-color: #${theme.color17};
            color: #${theme.background};
          }

          #mode {
            font-size: 14pt;
            background: #${theme.background};
            border-top: 3px solid #${theme.bright7};
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
            font-size: 14pt;
            padding: 0 8pt;
            background: #${theme.background};
            color: #${theme.foreground};
          }

          #mpris {
            font-size: 14pt;
            padding: 0 8pt;
            border-radius: 0;
            color: #${theme.regular7};
            background: #${theme.regular0};
          }

          tooltip {
            font-size: 14pt;
            background-color: #${theme.background};
            color: #${theme.regular7};
            border: 2px solid #${theme.regular4};
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
        size = 24;
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
            border: 2px solid #${theme.regular5};
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
        package = theme.gtk;
        name = "Tokyonight-Dark-BL";
      };
    };
    qt = {
      enable = true;
      platformTheme = "gnome";
      style = {
        package = pkgs.adwaita-qt;
        name = "adwaita-dark";
      };
    };
  };
}
