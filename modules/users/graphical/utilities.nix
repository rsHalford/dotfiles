{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.richard.graphical.utilities;
  terminal = config.richard.terminal.emulator.program;
in
{
  options.richard.graphical.utilities = {
    enable = mkOption {
      description = "Enable graphical utilities";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      grim
      mako
      slurp
      waybar
      wl-clipboard
    ];
    programs = {
      mako = {
        enable = true;
        actions = true;
        anchor = "top-right";
        backgroundColor = "#282828";
        borderColor = "#458588";
        borderRadius = 0;
        borderSize = 3;
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
        progressColor = "over #665c54";
        sort = "-time";
        textColor = "#fbf1c7";
        width = 300;
      };
      waybar = {
        enable = true;
        settings = [
          {
            height = 20;
            spacing = 0;
            fixed-center = false;
            ipc = true;
            modules-left = [ "sway/workspaces" "sway/mode" ];
            "sway/workspaces" = {
              disable-scroll = true;
            };
            "sway/mode" = {
              format = "<span style=\"italic\">{}</span>";
            };
            modules-center = [ "sway/window" ];
            "sway/window" = {
              format = { };
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
                  "<span font='12' color='#cc241d'></span>"
                  "<span font='12' color='#cc241d'></span>"
                  "<span font='12' color='#cc241d'></span>"
                  "<span font='12' color='#d65d0e'></span>"
                  "<span font='12' color='#d65d0e'></span>"
                  "<span font='12' color='#d79921'></span>"
                  "<span font='12' color='#d79921'></span>"
                  "<span font='12' color='#b8bb26'></span>"
                  "<span font='12' color='#b8bb26'></span>"
                  "<span font='12' color='#458588'></span>"
                  "<span font='12' color='#458588'></span>"
                ];
                charging = [
                  "<span font='12' color='#b8bb26'> </span>"
                  "<span font='12' color='#b8bb26'> </span>"
                  "<span font='12' color='#b8bb26'> </span>"
                  "<span font='12' color='#b8bb26'> </span>"
                  "<span font='12' color='#b8bb26'> </span>"
                  "<span font='12' color='#b8bb26'> </span>"
                  "<span font='12' color='#b8bb26'> </span>"
                ];
              };
              # on-click = ""; # tlp powersave
              tooltip-format = "{capacity}%";
            };
            "clock" = {
              format = "<span font='12' color='#fabd2f'></span> {:%H:%M}";
              # on-click = "${terminal} -e khal";
              today-format = "<span color='#b16286'><b>{}</b></span>";
              tooltip-format = "<big>{:%B <span color='#cc241d'>%Y}</span></big>\n<tt><small>{calendar}</small></tt>";
            };
            "cpu" = {
              format = "<span font='12' color='#689d6a'>﬙</span> {usage}%";
            };
            "custom/weather" = {
              exec = "curl -sf wttr.in/Halifax?format=%c%t";
              interval = 3600;
            };
            "disk" = {
              path = "/";
              format = "<span font='12' color='#fabd2f'></span> {percentage_used}%";
              tooltip-format = "{used} / {total}";
            };
            "memory" = {
              format = "<span font='12' color='#b16286'></span> {percentage}%";
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
              consume-icons = { "on" = "c"; };
              random-icons = { "on" = "z"; };
              repeat-icons = { "on" = "r"; };
              single-icons = { "on" = "s"; };
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
                wifi = "<span font='12' color='#689d6a'>直</span>";
                ethernet = "<span font='12' color='#b16286'></span>";
                linked = "<span font='12' color='#d65d0e'></span>";
                disconnected = "<span font='12' color='#d65d0e'></span>";
                disabled = "<span font='12' color='#cc241d'>睊</span>";
              };
              on-click = "${terminal} -e nmtui";
            };
            "pulseaudio" = {
              format = "{icon}";
              format-muted = "<span font='12' color='#cc241d'>ﱝ</span>";
              format-bluetooth = "<span font='12' color='#458588'></span>";
              format-bluetooth-muted = "<span font='12' color='#cc241d'></span>";
              format-source = "<span font='12' color='#fbf1c7'></span>";
              format-source-muted = "<span font='12' color='#cc241d'></span>";
              format-icons = {
                default = [
                  "<span font='12' color='#fb4934'>婢</span>"
                  "<span font='12' color='#fbf1c7'>奄</span>"
                  "<span font='12' color='#fbf1c7'>奄</span>"
                  "<span font='12' color='#fbf1c7'>奄</span>"
                  "<span font='12' color='#fbf1c7'>奄</span>"
                  "<span font='12' color='#fbf1c7'>奔</span>"
                  "<span font='12' color='#fbf1c7'>奔</span>"
                  "<span font='12' color='#fbf1c7'>奔</span>"
                  "<span font='12' color='#fbf1c7'>奔</span>"
                  "<span font='12' color='#fbf1c7'>奔</span>"
                  "<span font='12' color='#fbf1c7'>奔</span>"
                  "<span font='12' color='#fbf1c7'>奔</span>"
                  "<span font='12' color='#fbf1c7'>墳</span>"
                  "<span font='12' color='#fbf1c7'>墳</span>"
                  "<span font='12' color='#fbf1c7'>墳</span>"
                  "<span font='12' color='#fbf1c7'>墳</span>"
                  "<span font='12' color='#fbf1c7'>墳</span>"
                  "<span font='12' color='#fbf1c7'>墳</span>"
                  "<span font='12' color='#fbf1c7'>墳</span>"
                  "<span font='12' color='#fbf1c7'>墳</span>"
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
                "<span font='12' color='#458588'>﨎</span>"
                "<span font='12' color='#689d6a'>﨎</span>"
                "<span font='12' color='#98971a'>﨎</span>"
                "<span font='12' color='#d79921'>﨏</span>"
                "<span font='12' color='#d65d0e'>﨏</span>"
                "<span font='12' color='#cc241d'>﨏</span>"
              ];
            };
            "tray" = {
              icon-size = 16;
              show-passive-items = true;
              spacing = 18;
            };
          }
        ];
        style =
          ''
            * {
              font-family: JetBrainsMono Nerd Font;
              font-size: 11.5pt;
            }

            window#waybar {
              background-color: #282828;
              color: #fbf1c7;
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
              background-color: #282828;
              color: #bdae93;
              border: none;
              border-radius: 0;
              box-shadow: none;
              text-shadow: none;
            }
        
            #workspaces button:hover {
              box-shadow: inset 0 3px #458588;
              transition-property: box-shadow;
              transition-duration: 250ms;
            }
        
            #workspaces button.focused {
              background-color: #458588;
              color: #fbf1c7;
            }
        
            #workspaces button.urgent {
              background-color: #d65d0e;
            }
        
            #mode {
              background: #282828;
              border-top: 3px solid #fbf1c7;
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
              background: #282828;
              color: #bdae93;
            }

            #mpd {
              padding: 0 8pt;
              background: #1d2021;
            }

            #mpd.disconnected {
              color: #bdae93;
            }

            #mpd.playing {
              color: #98971a;
            }

            #mpd.paused {
              color: #d79921;
            }

            #mpd.stopped {
              color: #d65d0e;
            }

            tooltip {
              background-color: #1d2021;
              color: #fbf1c7;
              border: 3px solid #458588;
              border-radius: 0;
            }
          '';
        systemd.enable = true;
      };
    };
    gtk = {
      enable = true;
      font = {
        # package = with pkgs; (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
        name = "JetBrainsMono Nerd Font";
        size = 10;
      };
      gtk2 = {
        configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
        extraConfig = "";
      };
      gtk3 = {
        extraConfig = { gtk-application-prefer-dark-theme = true; };
        extraCss =
          ''
            menu {
              border-radius: 0;
              border: 3px solid #458588;
              background-color: #282828;
              color: #fbf1c7;
            }
            menuitem:hover {
              background-color: #458588;
              color: #fbf1c7;
            }
          '';
      };
      gtk4 = {
        extraConfig = { };
      };
      iconTheme = {
        package = pkgs.papirus-icon-theme;
        name = "Papirus Dark";
      };
    };
  };
}
