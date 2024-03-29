{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.richard.services;
  monospace = config.richard.fonts.monospace.name;
  theme = config.richard.theme;
in {
  options.richard.services = {
    blueman.enable = mkOption {
      description = "Enable blueman applet";
      type = types.bool;
      default = false;
    };

    gammastep.enable = mkOption {
      description = "Enable gammastep";
      type = types.bool;
      default = false;
    };

    kanshi.enable = mkOption {
      description = "Enable kanshi";
      type = types.bool;
      default = false;
    };

    kde-connect.enable = mkOption {
      description = "Enable KDE Connect";
      type = types.bool;
      default = false;
    };

    mako.enable = mkOption {
      description = "Enable mako";
      type = types.bool;
      default = false;
    };

    mpd.enable = mkOption {
      description = "Enable mpd";
      type = types.bool;
      default = false;
    };

    mpris.enable = mkOption {
      description = "Enable MPRIS";
      type = types.bool;
      default = false;
    };

    newsboat.enable = mkOption {
      description = "Newsboat feed reloads";
      type = types.bool;
      default = false;
    };

    mail.enable = mkOption {
      description = "Enable mail";
      type = types.bool;
      default = false;
    };

    syncthing.enable = mkOption {
      description = "Enable syncthing";
      type = types.bool;
      default = false;
    };

    udiskie.enable = mkOption {
      description = "Enable udiskie for automounting";
      type = types.bool;
      default = false;
    };
  };

  config = {
    home.packages = with pkgs; [
      gammastep
      inotify-tools
      kanshi
      mako
      mpd
      mpdris2
      playerctl
      scripts.bingTools
      syncthing
    ];

    services = {
      blueman-applet.enable = cfg.blueman.enable;
      gammastep = {
        enable = cfg.gammastep.enable;
        dawnTime = "06:30-08:30";
        duskTime = "20:30-22:00";
        settings = {
          general = {
            fade = 1;
            brightness-day = 1.0;
            brightness-night = 0.4;
            adjustment-method = "wayland";
          };
        };
        temperature = {
          day = 6500;
          night = 2800;
        };
        tray = true;
      };
      imapnotify.enable = cfg.mail.enable;
      mbsync = {
        enable = cfg.mail.enable;
        postExec = "${pkgs.notmuch}/bin/notmuch new";
      };
      kanshi = {
        enable = cfg.kanshi.enable;
        profiles = {
          desktop = {
            outputs = [
              {
                criteria = "Dell Inc. DELL U2515H 9X2VY5CA0QTL";
                mode = "2560x1440@60Hz";
                position = "1920,0";
                transform = "270";
                scale = 1.5;
                status = "enable";
              }
              {
                criteria = "BNQ BenQ EX2510 9BL02077019";
                mode = "1920x1080@144Hz";
                position = "0,275";
                scale = 1.0;
                status = "enable";
              }
            ];
          };
          laptop_undocked = {
            outputs = [
              {
                criteria = "eDP-1";
                position = "0,0";
                scale = 1.75;
                status = "enable";
              }
            ];
          };
          laptop_docked = {
            outputs = [
              {
                criteria = "Dell Inc. DELL U2515H 9X2VY5CA0QTL";
                mode = "2560x1440@60Hz";
                position = "1920,0";
                transform = "270";
                scale = 1.5;
                status = "enable";
              }
              {
                criteria = "BNQ BenQ EX2510 9BL02077019";
                mode = "1920x1080@144Hz";
                position = "0,275";
                scale = 1.0;
                status = "enable";
              }
              {
                criteria = "eDP-1";
                status = "disable";
              }
            ];
          };
        };
      };
      kdeconnect = {
        enable = cfg.kde-connect.enable;
        indicator = true;
      };
      mako = {
        enable = true;
        actions = true;
        anchor = "bottom-right";
        backgroundColor = "#${theme.colors.base00}";
        borderColor = "#${theme.colors.base07}";
        borderRadius = 2;
        borderSize = 2;
        defaultTimeout = 10000;
        extraConfig = "";
        font = "${monospace} Nerd Font";
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
        progressColor = "over #${theme.colors.base0D}";
        sort = "-time";
        textColor = "#${theme.colors.base05}";
        width = 300;
      };
      mpd = {
        enable = cfg.mpd.enable;
        extraConfig = ''
          audio_output {
            type "pipewire"
            name "PipeWire Output"
          }
          audio_output {
            type "fifo"
            name "ncmpcpp visualizer"
            path "/tmp/mpd.fifo"
            format "44100:16:2"
          }
        '';
        musicDirectory = ~/media/music;
        network = {
          #   listenAddress = "127.0.0.1";
          #   port = "9001";
          startWhenNeeded = true;
        };
      };
      mpdris2 = {
        enable = cfg.mpd.enable;
        # mpd = {
        #   host = "127.0.0.1";
        #   port = "9001";
        # };
        # multimediaKeys = false;
        # notifications = false;
      };
      mpris-proxy.enable = cfg.mpris.enable;
      playerctld = {
        enable = cfg.mpris.enable;
      };
      syncthing = {
        enable = cfg.syncthing.enable;
        tray = {
          enable = true;
          command = "syncthingtray --wait";
        };
      };
      udiskie = {
        enable = cfg.udiskie.enable;
      };
    };
    systemd.user = {
      services = {
        bing-wp = {
          Install = {
            WantedBy = ["multi-user.target"];
          };
          Service = {
            Type = "simple";
            ExecStart = "${pkgs.scripts.bingTools}/bin/bing-wp";
          };
          Unit = {
            Description = "Daily Bing wallpaper service";
            After = ["network-online.target"];
            Wants = ["network-online.target"];
          };
        };
        newsboat = mkIf (cfg.newsboat.enable) {
          Install = {
            WantedBy = ["multi-user.target"];
          };
          Service = {
            ExecStart = "${pkgs.newsboat}/bin/newsboat -x reload";
          };
          Unit = {
            Description = "Newsboat automatic reload service";
            After = ["network-online.target"];
            Wants = ["network-online.target"];
          };
        };
      };
      timers = {
        bing-wp = {
          Install = {
            WantedBy = ["graphical-session.target"];
          };
          Timer = {
            OnCalendar = "*-*-* 01:00:00";
            Persistent = true;
          };
          Unit = {
            Description = "Daily Bing wallpaper timer";
          };
        };
        newsboat = mkIf (cfg.newsboat.enable) {
          Install = {
            WantedBy = ["timers.target"];
          };
          Timer = {
            OnStartupSec = "1min";
            OnUnitActiveSec = "1h";
          };
          Unit = {
            Description = "Newsboat automatic reload timer";
          };
        };
      };
    };
  };
}
