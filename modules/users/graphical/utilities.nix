{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.richard.graphical.utilities;
  terminal = config.richard.terminal.emulator.program;
  background = "#232136";
  foreground = "#e0def4";
  black = "#393552"; # black base
  red = "#eb6f92"; # red love
  green = "#3e8fb0"; # green pine
  yellow = "#f6c177"; # yellow gold
  blue = "#9ccfd8"; # blue foam
  magenta = "#c4a7e7"; # magenta iris
  cyan = "#ea9a97"; # cyan rose
  white = "#e0def4"; # white text
  inactive = "#908caa";
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
      mako
      qt6.qtwayland
      slurp
      tag
      waybar
      wl-clipboard
    ];
    programs = {
      mako = {
        enable = true;
        actions = true;
        anchor = "bottom-right";
        backgroundColor = background;
        borderColor = green;
        borderRadius = 2;
        borderSize = 2;
        defaultTimeout = 10000;
        extraConfig = "";
        font = "JetBrainsMono Nerd Font";
        format = ''<b>%s</b>\n%b'';
        groupBy = null;
        height = 100;
        iconPath = null;
        icons = true;
        ignoreTimeout = false;
        layer = "overlay";
        margin = "10,10,5";
        markup = true;
        maxIconSize = 32;
        maxVisible = 5;
        output = null;
        padding = "0,10,20";
        progressColor = "over ${inactive}";
        sort = "-time";
        textColor = white;
        width = 300;
      };
      swaylock.settings = {
        show-failed-attempts = true;
        color = "191724";
        font = "JetBrainsMono Nerd Font";
        font-size = 24;
        indicator-idle-visible = false;
      };
      waybar = {
        enable = true;
        settings = [
          {
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
                  "<span font='12' color='${red}'></span>"
                  "<span font='12' color='${red}'></span>"
                  "<span font='12' color='${red}'></span>"
                  "<span font='12' color='${cyan}'></span>"
                  "<span font='12' color='${cyan}'></span>"
                  "<span font='12' color='${yellow}'></span>"
                  "<span font='12' color='${yellow}'></span>"
                  "<span font='12' color='${blue}'></span>"
                  "<span font='12' color='${blue}'></span>"
                  "<span font='12' color='${green}'></span>"
                  "<span font='12' color='${green}'></span>"
                ];
                charging = [
                  "<span font='12' color='${magenta}'> </span>"
                  "<span font='12' color='${magenta}'> </span>"
                  "<span font='12' color='${magenta}'> </span>"
                  "<span font='12' color='${magenta}'> </span>"
                  "<span font='12' color='${magenta}'> </span>"
                  "<span font='12' color='${magenta}'> </span>"
                  "<span font='12' color='${magenta}'> </span>"
                ];
              };
              # on-click = ""; # tlp powersave
              tooltip-format = "{capacity}%";
            };
            "clock" = {
              format = "<span font='12' color='${yellow}'></span> {:%H:%M}";
              # on-click = "${terminal} -e khal";
              today-format = "<span color='${magenta}'><b>{}</b></span>";
              tooltip-format = "<big>{:%B <span color='${red}'>%Y}</span></big>\n<tt><small>{calendar}</small></tt>";
            };
            "cpu" = {
              format = "<span font='12' color='${green}'>﬙</span> {usage}%";
            };
            "custom/weather" = {
              exec = "curl -sf wttr.in/Halifax?format=%c%t";
              interval = 3600;
            };
            "disk" = {
              path = "/";
              format = "<span font='12' color='${yellow}'></span> {percentage_used}%";
              tooltip-format = "{used} / {total}";
            };
            "memory" = {
              format = "<span font='12' color='${magenta}'></span> {percentage}%";
              tooltip-format = "{used:0.1f}GiB / {total:0.1f}GiB";
            };
            "mpd" = {
              format = "{stateIcon} \"{title}\" by {artist}";
              format-stopped = "Stopped";
              format-disconnected = "Disconnected";
              tooltip-format = "Volume: {volume}% [{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}]\n{elapsedTime:%M:%S}/{totalTime:%M:%S}";
              rotate = "1";
              max-length = "24";
              on-click = "mpc toggle";
              on-click-middle = "${terminal} -e ncmpcpp";
              on-click-right = "mpc next";
              state-icons = {
                "playing" = "⏵";
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
                wifi = "<span font='12' color='${blue}'>直</span>";
                ethernet = "<span font='12' color='${magenta}'></span>";
                linked = "<span font='12' color='${cyan}'></span>";
                disconnected = "<span font='12' color='${cyan}'></span>";
                disabled = "<span font='12' color='${red}'>睊</span>";
              };
              on-click = "${terminal} -e nmtui";
            };
            "pulseaudio" = {
              format = "{icon}";
              format-muted = "<span font='12' color='${red}'>ﱝ</span>";
              format-bluetooth = "<span font='12' color='${green}'></span>";
              format-bluetooth-muted = "<span font='12' color='${red}'></span>";
              format-source = "<span font='12' color='${white}'></span>";
              format-source-muted = "<span font='12' color='${red}'></span>";
              format-icons = {
                default = [
                  "<span font='12' color='${red}'>婢</span>"
                  "<span font='12' color='${white}'>奄</span>"
                  "<span font='12' color='${white}'>奄</span>"
                  "<span font='12' color='${white}'>奄</span>"
                  "<span font='12' color='${white}'>奄</span>"
                  "<span font='12' color='${white}'>奔</span>"
                  "<span font='12' color='${white}'>奔</span>"
                  "<span font='12' color='${white}'>奔</span>"
                  "<span font='12' color='${white}'>奔</span>"
                  "<span font='12' color='${white}'>奔</span>"
                  "<span font='12' color='${white}'>奔</span>"
                  "<span font='12' color='${white}'>奔</span>"
                  "<span font='12' color='${white}'>墳</span>"
                  "<span font='12' color='${white}'>墳</span>"
                  "<span font='12' color='${white}'>墳</span>"
                  "<span font='12' color='${white}'>墳</span>"
                  "<span font='12' color='${white}'>墳</span>"
                  "<span font='12' color='${white}'>墳</span>"
                  "<span font='12' color='${white}'>墳</span>"
                  "<span font='12' color='${white}'>墳</span>"
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
                "<span font='12' color='${magenta}'>﨎</span>"
                "<span font='12' color='${green}'>﨎</span>"
                "<span font='12' color='${blue}'>﨎</span>"
                "<span font='12' color='${yellow}'>﨏</span>"
                "<span font='12' color='${cyan}'>﨏</span>"
                "<span font='12' color='${red}'>﨏</span>"
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
            background-color: ${background};
            color: ${white};
          }

          #window,
          #workspaces {
            margin: 0 4px;
          }

          .modules-left > widget:first-child > #workspaces {
            margin-left: 0;
          }

          #workspaces button {
            padding: 0 5px;
            background-color: ${background};
            color: ${inactive};
            border: none;
            border-radius: 0;
            box-shadow: none;
            text-shadow: none;
          }

          #workspaces button:hover {
            box-shadow: inset 0 3px ${blue};
            transition-property: box-shadow;
            transition-duration: 250ms;
          }

          #workspaces button.focused {
            background-color: ${blue};
            color: #fbf1c7;
          }

          #workspaces button.urgent {
            background-color: ${cyan};
          }

          #mode {
            background: ${background};
            border-top: 3px solid ${white};
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
            background: ${background};
            color: ${inactive};
          }

          #mpd {
            padding: 0 8pt;
            border-radius: 0;
            background: ${black};
          }

          #mpd.disconnected {
            color: ${inactive};
          }

          #mpd.playing {
            color: ${green};
          }

          #mpd.paused {
            color: ${yellow};
          }

          #mpd.stopped {
            color: ${cyan};
          }

          tooltip {
            background-color: ${background};
            color: ${white};
            border: 2px solid ${green};
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
            border: 2px solid ${magenta};
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
        package = pkgs.rose-pine-gtk-theme;
        name = "rose-pine-moon";
      };
    };
  };
}
