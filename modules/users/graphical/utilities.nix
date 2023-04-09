{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.richard.graphical.utilities;
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
    home.packages = with pkgs; [
      autotiling
      grim
      qt6.qtwayland
      slurp
      swww
      tag
      waybar
      wl-clipboard
    ];
    programs = {
      swaylock.settings = {
        show-failed-attempts = true;
        color = regular0;
        font = "JetBrainsMono Nerd Font";
        font-size = 24;
        indicator-idle-visible = false;
      };
      waybar = {
        enable = true;
        settings = [
          {
            position = "bottom";
            height = 20;
            spacing = 0;
            fixed-center = false;
            ipc = true;
            modules-left = ["sway/workspaces" "sway/mode"];
            "sway/workspaces" = {
              disable-scroll = true;
            };
            "sway/mode" = {
              format = "<span style=\"italic\">{}</span>";
            };
            modules-center = ["sway/window"];
            "sway/window" = {
              format = {};
            };
            modules-right = [
              "mpd"
              "cpu"
              "temperature"
              "memory"
              "disk"
              "pulseaudio"
              "network"
              "battery"
              "tray"
              "custom/weather"
              "clock"
            ];
            "battery" = {
              format = "{icon}";
              format-charging = "{icon}";
              format-time = "{H}:{M}";
              format-icons = {
                default = [
                  "<span font='12' color='#${regular1}'></span>"
                  "<span font='12' color='#${regular1}'></span>"
                  "<span font='12' color='#${regular1}'></span>"
                  "<span font='12' color='#${regular6}'></span>"
                  "<span font='12' color='#${regular6}'></span>"
                  "<span font='12' color='#${regular3}'></span>"
                  "<span font='12' color='#${regular3}'></span>"
                  "<span font='12' color='#${regular4}'></span>"
                  "<span font='12' color='#${regular4}'></span>"
                  "<span font='12' color='#${regular4}'></span>"
                  "<span font='12' color='#${regular4}'></span>"
                ];
                charging = [
                  "<span font='12' color='#${regular5}'> </span>"
                  "<span font='12' color='#${regular5}'> </span>"
                  "<span font='12' color='#${regular5}'> </span>"
                  "<span font='12' color='#${regular5}'> </span>"
                  "<span font='12' color='#${regular5}'> </span>"
                  "<span font='12' color='#${regular5}'> </span>"
                  "<span font='12' color='#${regular5}'> </span>"
                ];
              };
              # on-click = ""; # tlp powersave
              tooltip-format = "{capacity}%";
            };
            "clock" = {
              format = "<span font='12' color='#${regular3}'></span> {:%H:%M}";
              # on-click = "${terminal} -e khal";
              today-format = "<span color='#${regular5}'><b>{}</b></span>";
              tooltip-format = "<big>{:%B <span color='#${regular1}'>%Y}</span></big>\n<tt><small>{calendar}</small></tt>";
            };
            "cpu" = {
              format = "<span font='12' color='#${regular4}'>﬙</span> {usage}%";
            };
            "custom/weather" = {
              exec = "curl -sf wttr.in/Halifax?format=%c%t";
              interval = 3600;
            };
            "disk" = {
              path = "/";
              format = "<span font='12' color='#${regular3}'></span> {percentage_used}%";
              tooltip-format = "{used} / {total}";
            };
            "memory" = {
              format = "<span font='12' color='#${regular5}'></span> {percentage}%";
              tooltip-format = "{used:0.1f}GiB / {total:0.1f}GiB";
            };
            "mpd" = {
              format = "{stateIcon} <span color='#${regular7}'>{title}</span> by <span color='#${regular6}'>{artist}</span>";
              format-stopped = "Stopped";
              format-disconnected = "Disconnected";
              tooltip-format = "Volume: {volume}% [{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}]\n{elapsedTime:%M:%S}/{totalTime:%M:%S}";
              rotate = "1";
              max-length = "24";
              on-click = "mpc toggle";
              on-click-middle = "${terminal} -e ncmpcpp";
              on-click-right = "mpc next";
              state-icons = {
                "playing" = "<span color='#${regular2}'>⏵</span>";
                "paused" = "⏸";
              };
              consume-icons = {"on" = "c";};
              random-icons = {"on" = "z";};
              repeat-icons = {"on" = "r";};
              single-icons = {"on" = "s";};
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
                wifi = "<span font='12' color='#${regular4}'>直</span>";
                ethernet = "<span font='12' color='#${regular5}'></span>";
                linked = "<span font='12' color='#${regular6}'></span>";
                disconnected = "<span font='12' color='#${regular6}'></span>";
                disabled = "<span font='12' color='#${regular1}'>睊</span>";
              };
              on-click = "${terminal} -e nmtui";
            };
            "pulseaudio" = {
              format = "{icon}";
              format-muted = "<span font='12' color='#${regular1}'>ﱝ</span>";
              format-bluetooth = "<span font='12' color='#${regular4}'></span>";
              format-bluetooth-muted = "<span font='12' color='#${regular1}'></span>";
              format-source = "<span font='12' color='#${regular7}'></span>";
              format-source-muted = "<span font='12' color='#${regular1}'></span>";
              format-icons = {
                default = [
                  "<span font='12' color='#${regular1}'>婢</span>"
                  "<span font='12' color='#${regular7}'>奄</span>"
                  "<span font='12' color='#${regular7}'>奄</span>"
                  "<span font='12' color='#${regular7}'>奄</span>"
                  "<span font='12' color='#${regular7}'>奄</span>"
                  "<span font='12' color='#${regular7}'>奔</span>"
                  "<span font='12' color='#${regular7}'>奔</span>"
                  "<span font='12' color='#${regular7}'>奔</span>"
                  "<span font='12' color='#${regular7}'>奔</span>"
                  "<span font='12' color='#${regular7}'>奔</span>"
                  "<span font='12' color='#${regular7}'>奔</span>"
                  "<span font='12' color='#${regular7}'>奔</span>"
                  "<span font='12' color='#${regular7}'>墳</span>"
                  "<span font='12' color='#${regular7}'>墳</span>"
                  "<span font='12' color='#${regular7}'>墳</span>"
                  "<span font='12' color='#${regular7}'>墳</span>"
                  "<span font='12' color='#${regular7}'>墳</span>"
                  "<span font='12' color='#${regular7}'>墳</span>"
                  "<span font='12' color='#${regular7}'>墳</span>"
                  "<span font='12' color='#${regular7}'>墳</span>"
                ];
                headset = "";
                # hifi = "蓼";
                # hmdi = "﴿";
                # speaker = "蓼";
              };
              on-click = "${terminal} -e pulsemixer";
              scroll-step = 1.0;
              tooltip-format = "{desc}: {volume}%";
            };
            "temperature" = {
              hwmon-path = "/sys/class/hwmon/hwmon7/temp1_input";
              critical-threshold = 100;
              format = "{icon} {temperatureC}°C";
              format-icons = [
                "<span font='12' color='#${regular5}'>﨎</span>"
                "<span font='12' color='#${regular4}'>﨎</span>"
                "<span font='12' color='#${regular4}'>﨎</span>"
                "<span font='12' color='#${regular3}'>﨏</span>"
                "<span font='12' color='#${regular6}'>﨏</span>"
                "<span font='12' color='#${regular1}'>﨏</span>"
              ];
            };
            "tray" = {
              icon-size = 16;
              show-passive-items = true;
              spacing = 18;
            };
          }
        ];
        style = ''
          * {
            font-family: JetBrainsMono Nerd Font;
            font-size: 11.5pt;
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
            padding: 0px;
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

          #workspaces button.focused {
            background-color: #${regular4};
            color: #${background};
          }

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
          #custom-weather,
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

          #mpd {
            padding: 0 8pt;
            border-radius: 0;
            background: #${regular0};
          }

          #mpd.disconnected {
            color: #${foreground};
          }

          #mpd.playing {
            color: #${regular4};
          }

          #mpd.paused {
            color: #${regular3};
          }

          #mpd.stopped {
            color: #${regular6};
          }

          tooltip {
            background-color: #${background};
            color: #${regular7};
            border: 2px solid #${regular4};
            border-radius: 2px;
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
        package = with pkgs; (nerdfonts.override {fonts = ["JetBrainsMono"];});
        name = "JetBrainsMono Nerd Font";
        size = 11;
      };
      gtk2 = {
        configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
        extraConfig = "";
      };
      gtk3 = {
        extraConfig = {};
        extraCss = ''
          menu {
            border-radius: 2px;
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
