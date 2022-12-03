{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.richard.services;
in
{
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

    syncthing.enable = mkOption {
      description = "Enable syncthing";
      type = types.bool;
      default = false;
    };
  };

  config = {
    home.packages = with pkgs; [
      gammastep
      kanshi
      mpd
      mpdris2
      playerctl
      scripts.wallpaperTools
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
                criteria = "BenQ Corporation BenQ EX2510 9BL02077019";
                mode = "1920x1080@144Hz";
                position = "0,275";
                scale = 1.0;
                status = "enable";
              }
            ];
          };
          laptop_undocked = {
            outputs = [{
              criteria = "eDP-1";
              position = "0,0";
              status = "enable";
            }];
          };
          laptop_docked = {
            outputs = [
              {
                criteria = "eDP-1";
                status = "disable";
              }
              {
                criteria = "Dell Inc. DELL U2515H 9X2VY5CA0QTL";
                position = "0,0";
                scale = 1.0;
                status = "enable";
              }
            ];
          };
        };
      };
      kdeconnect = {
        enable = cfg.kde-connect.enable;
        indicator = true;
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
        musicDirectory = ~/Media/Music;
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
    };
    systemd.user = {
      services = {
        bing-wp = {
          Install = {
            WantedBy = [ "multi-user.target" ];
          };
          Service = {
            Type = "simple";
            ExecStart = "${pkgs.scripts.wallpaperTools}/bin/bing-wp";
          };
          Unit = {
            Description = "Daily Bing wallpaper service";
            After = [ "network-online.target" ];
            Wants = [ "network-online.target" ];
          };
        };
        newsboat = {
          Install = {
            WantedBy = [ "multi-user.target" ];
          };
          Service = {
            ExecStart = "${pkgs.newsboat}/bin/newsboat -x reload";
          };
          Unit = {
            Description = "Newsboat automatic reload service";
            After = [ "network-online.target" ];
            Wants = [ "network-online.target" ];
          };
        };
      };
      timers = {
        bing-wp = {
          Install = {
            WantedBy = [ "graphical-session.target" ];
          };
          Timer = {
            OnCalendar = "*-*-* 01:00:00";
            Persistent = true;
          };
          Unit = {
            Description = "Daily Bing wallpaper timer";
          };
        };
        newsboat = {
          Install = {
            WantedBy = [ "timers.target" ];
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
