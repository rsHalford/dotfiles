{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.richard.graphical.utilities;
  compositor = config.richard.graphical.compositor;
  monospace = config.richard.fonts.monospace;
  terminal = config.richard.terminal.emulator.program;
  theme = config.richard.theme;
  github-notify = with pkgs;
    writeScriptBin "github-notify" ''
      #!${runtimeShell}
        token="$(cat ${config.xdg.dataHome}/github/notifications.token)"
        count="$(curl -su rsHalford:"$token" https://api.github.com/notifications | jq '. | length')"
        tooltip="$count notifications"
        if [ "$count" != "0" ]; then alt="new"; else alt="none"; fi
        printf '{"alt":"%s","tooltip":"%s"}\n' "$alt" "$tooltip"
    '';
  mail-notify = with pkgs;
    writeScriptBin "mail-notify" ''
      #!${runtimeShell}
      new="$(fd . "${config.xdg.dataHome}/mail/richard@rshalford.com/Inbox/new" --type f | wc -l 2>/dev/null)"
      cur="$(fd . "${config.xdg.dataHome}/mail/richard@rshalford.com/Inbox/cur" --type f | wc -l 2>/dev/null)"
      tooltip="$new/$cur new emails"
      if [ "$new" != 0 ] && [ "$cur" == 0 ]; then
        alt="new-single"
      elif [ "$new" != 0 ] && [ "$cur" != 0 ]; then
        alt="new-multi"
      elif [ "$new" == 0 ] && [ "$cur" -gt 1  ]; then
        alt="read-multi"
      elif [ "$new" == 0 ] && [ "$cur" == 1 ]; then
        alt="read-single"
      else
        alt="empty"
      fi
      printf '{"alt":"%s","tooltip":"%s"}\n' "$alt" "$tooltip"
    '';
in {
  imports = [~/.dotfiles/secrets/security];

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
        github-notify
        grim
        hyprpicker
        mail-notify
        qt6.qtwayland
        scripts.gammaTools
        scripts.wallpaperTools
        slurp
        swww
        wl-clipboard
        zbar
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
      swaylock = {
        enable = true;
        settings = {
          show-failed-attempts = true;
          color = theme.colors.base01;
          font = "${monospace.name} Nerd Font";
          font-size = 24;
          indicator-idle-visible = false;
        };
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
              (mkIf (compositor.river.enable) "river/tags")
              (mkIf (compositor.hyprland.enable) "hyprland/workspaces")
              (mkIf (compositor.sway.enable) "sway/workspaces")
              (mkIf (compositor.hyprland.enable) "hyprland/submap")
              (mkIf (compositor.sway.enable) "sway/mode")
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
            modules-center = [
              (mkIf (compositor.river.enable) "river/window")
              (mkIf (compositor.hyprland.enable) "hyprland/window")
              (mkIf (compositor.sway.enable) "sway/window")
            ];
            "river/window" = {
              max-length = 30;
            };
            modules-right = [
              "mpris"
              "custom/maildir"
              "custom/github"
              "tray"
              "network"
              "pulseaudio"
              # "cpu"
              # "memory"
              "disk"
              "temperature"
              "battery"
              "clock"
            ];
            "battery" = {
              format = "{icon}";
              format-charging = "{icon}";
              format-time = "{H}:{M}";
              format-icons = {
                default = [
                  "<span font='14' color='#${theme.colors.base08}'>󰂎</span>"
                  "<span font='14' color='#${theme.colors.base08}'>󰁺</span>"
                  "<span font='14' color='#${theme.colors.base09}'>󰁻</span>"
                  "<span font='14' color='#${theme.colors.base09}'>󰁼</span>"
                  "<span font='14' color='#${theme.colors.base0A}'>󰁽</span>"
                  "<span font='14' color='#${theme.colors.base0A}'>󰁾</span>"
                  "<span font='14' color='#${theme.colors.base0C}'>󰁿</span>"
                  "<span font='14' color='#${theme.colors.base0C}'>󰂀</span>"
                  "<span font='14' color='#${theme.colors.base0D}'>󰂁</span>"
                  "<span font='14' color='#${theme.colors.base0D}'>󰂂</span>"
                  "<span font='14' color='#${theme.colors.base0E}'>󰁹</span>"
                ];
                charging = [
                  "<span font='14' color='#${theme.colors.base0B}'>󰂆</span>"
                  "<span font='14' color='#${theme.colors.base0B}'>󰂇</span>"
                  "<span font='14' color='#${theme.colors.base0B}'>󰂈</span>"
                  "<span font='14' color='#${theme.colors.base0B}'>󰂉</span>"
                  "<span font='14' color='#${theme.colors.base0B}'>󰂊</span>"
                  "<span font='14' color='#${theme.colors.base0B}'>󰂋</span>"
                  "<span font='14' color='#${theme.colors.base0B}'>󰂅</span>"
                ];
              };
              # on-click = ""; # tlp powersave
              tooltip-format = "{capacity}%";
            };
            "clock" = {
              format = "{:%H:%M}";
              tooltip-format = "<tt><small>{calendar}</small></tt>";
              # on-click = "${terminal} -e khal";
              calendar = {
                mode = "month";
                weeks-pos = "right";
                on-scroll = 1;
                format = {
                  weeks = "<span color='#${theme.colors.base0C}'><b>W{}</b></span>";
                  weekdays = "<span color='#${theme.colors.base0D}'><b>{}</b></span>";
                  today = "<span color='#${theme.colors.base09}'><b>{}</b></span>";
                };
              };
            };
            "cpu" = {
              format = "<span font='14' color='#${theme.colors.base0D}'>󰍛</span> {usage}%";
              on-click = "btm";
            };
            "custom/github" = {
              format = "{icon}";
              format-icons = {
                "none" = "<span font='14' color='#${theme.colors.base05}'>󰊤</span>";
                "new" = "<span font='14' color='#${theme.colors.base0E}'>󰊤</span>";
              };
              return-type = "json";
              interval = 360;
              exec = "${github-notify}/bin/github-notify";
              on-click = "xdg-open https://github.com/notifications";
            };
            "custom/maildir" = {
              format = "{icon}";
              format-icons = {
                "empty" = "<span font='14' color='#${theme.colors.base05}'>󰗯</span>";
                "read-single" = "<span font='14' color='#${theme.colors.base0D}'>󰇯</span>";
                "read-multi" = "<span font='14' color='#${theme.colors.base0D}'>󰻩</span>";
                "new-single" = "<span font='14' color='#${theme.colors.base08}'>󰇮</span>";
                "new-multi" = "<span font='14' color='#${theme.colors.base08}'>󰮒</span>";
              };
              return-type = "json";
              interval = 180;
              exec = "${mail-notify}/bin/mail-notify";
              on-click = "${terminal} -e ${config.richard.suite.mail.client}";
            };
            "disk" = {
              path = "/";
              format = "<span font='14' color='#${theme.colors.base0A}'>󰉉</span>";
              tooltip-format = "{used} / {total}";
              on-click = "btm";
            };
            "memory" = {
              format = "<span font='14' color='#${theme.colors.base0E}'>󰘚</span> {percentage}%";
              tooltip-format = "{used:0.1f}GiB / {total:0.1f}GiB";
              on-click = "btm";
            };
            "mpris" = {
              format = "{player_icon} <span color='#${theme.colors.base0A}'>\"{title}\"</span> <span color='#${theme.colors.base0E}'>{artist}</span>";
              format-paused = "{status_icon} \"{title}\" - {artist}";
              player-icons = {
                "default" = "<span color='#${theme.colors.base0B}'>⏵</span>";
                "mpv" = "<span color='#${theme.colors.base0B}'>⏵</span>";
                "mpd" = "<span color='#${theme.colors.base0C}'>⏵</span>";
              };
              status-icons = {
                "paused" = "<span color='#${theme.colors.base09}'>⏸</span>";
              };
              title-len = 20;
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
                wifi = "<span font='14' color='#${theme.colors.base0B}'>󰖩</span>";
                ethernet = "<span font='14' color='#${theme.colors.base0E}'>󰈀</span>";
                linked = "<span font='14' color='#${theme.colors.base0C}'>󰌹</span>";
                disconnected = "<span font='14' color='#${theme.colors.base09}'>󱚵</span>";
                disabled = "<span font='14' color='#${theme.colors.base08}'>󰖪</span>";
              };
              on-click = "nmtui";
            };
            "pulseaudio" = {
              format = "{icon}";
              format-muted = "<span font='14' color='#${theme.colors.base08}'>󰝟</span>";
              format-bluetooth = "<span font='14' color='#${theme.colors.base0D}'>󰂰</span>";
              format-bluetooth-muted = "<span font='14' color='#${theme.colors.base08}'>󰂲</span>";
              format-source = "<span font='14' color='#${theme.colors.base05}'></span>";
              format-source-muted = "<span font='14' color='#${theme.colors.base08}'></span>";
              format-icons = {
                default = [
                  "<span font='14' color='#${theme.colors.base08}'>󰖁</span>"
                  "<span font='14' color='#${theme.colors.base05}'>󰕿</span>"
                  "<span font='14' color='#${theme.colors.base05}'>󰕿</span>"
                  "<span font='14' color='#${theme.colors.base05}'>󰕿</span>"
                  "<span font='14' color='#${theme.colors.base05}'>󰕿</span>"
                  "<span font='14' color='#${theme.colors.base06}'>󰖀</span>"
                  "<span font='14' color='#${theme.colors.base06}'>󰖀</span>"
                  "<span font='14' color='#${theme.colors.base06}'>󰖀</span>"
                  "<span font='14' color='#${theme.colors.base06}'>󰖀</span>"
                  "<span font='14' color='#${theme.colors.base06}'>󰖀</span>"
                  "<span font='14' color='#${theme.colors.base06}'>󰖀</span>"
                  "<span font='14' color='#${theme.colors.base06}'>󰖀</span>"
                  "<span font='14' color='#${theme.colors.base07}'>󰕾</span>"
                  "<span font='14' color='#${theme.colors.base07}'>󰕾</span>"
                  "<span font='14' color='#${theme.colors.base07}'>󰕾</span>"
                  "<span font='14' color='#${theme.colors.base07}'>󰕾</span>"
                  "<span font='14' color='#${theme.colors.base07}'>󰕾</span>"
                  "<span font='14' color='#${theme.colors.base07}'>󰕾</span>"
                  "<span font='14' color='#${theme.colors.base07}'>󰕾</span>"
                  "<span font='14' color='#${theme.colors.base07}'>󰕾</span>"
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
              format = "{icon}";
              format-icons = [
                "<span font='12' color='#${theme.colors.base0C}'></span>"
                "<span font='12' color='#${theme.colors.base0B}'></span>"
                "<span font='12' color='#${theme.colors.base0A}'></span>"
                "<span font='12' color='#${theme.colors.base09}'></span>"
                "<span font='12' color='#${theme.colors.base08}'></span>"
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
            background-color: #${theme.colors.base00};
            color: #${theme.colors.base06};
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
            background-color: #${theme.colors.base00};
            color: #${theme.colors.base06};
            border: none;
            border-radius: 0;
            box-shadow: none;
            text-shadow: none;
          }

          #tags button:hover,
          #workspaces button:hover {
            background-color: #${theme.colors.base0D};
            color: #${theme.colors.base00};
          }

          #tags button.focused,
          #workspaces button.active,
          #workspaces button.focused {
            background-color: #${theme.colors.base0C};
            color: #${theme.colors.base00};
          }

          #tags button.focused:hover,
          #workspaces button.active:hover,
          #workspaces button.focused:hover {
            background-color: #${theme.colors.base0D};
            color: #${theme.colors.base00};
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
            background-color: #${theme.colors.base09};
            color: #${theme.colors.base00};
          }

          #tags button.urgent:hover,
          #workspaces button.urgent:hover {
            background-color: #${theme.colors.base0A};
            color: #${theme.colors.base00};
          }

          #mode {
            font-size: 14pt;
            background: #${theme.colors.base00};
            border-top: 3px solid #${theme.colors.base07};
          }

          #battery,
          #clock,
          #cpu,
          #custom-github,
          #custom-maildir,
          #disk,
          #memory,
          #network,
          #pulseaudio,
          #temperature,
          #tray {
            font-size: 14pt;
            padding: 0 8pt;
            background: #${theme.colors.base00};
            color: #${theme.colors.base06};
          }

          #mpris {
            font-size: 14pt;
            padding: 0 8pt;
            border-radius: 0;
            color: #${theme.colors.base06};
            background: #${theme.colors.base01};
          }

          tooltip {
            font-size: 14pt;
            background-color: #${theme.colors.base00};
            color: #${theme.colors.base05};
            border: 2px solid #${theme.colors.base0D};
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
            border: 2px solid #${theme.colors.base0E};
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
        package = pkgs.gnome.gnome-themes-extra;
        name = "Adwaita-dark";
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
