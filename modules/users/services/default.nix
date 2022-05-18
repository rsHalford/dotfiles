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

    mpd.enable = mkOption {
      description = "Enable mpd";
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
          undocked = {
            outputs = [{
              criteria = "eDP-1";
              position = "0,0";
              status = "enable";
            }];
          };
          docked = {
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
        musicDirectory = "~/Media/Music";
        network = {
        #   listenAddress = "127.0.0.1";
        #   port = "9001";
          startWhenNeeded = true;
        };
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
          Service = {
            ExecStart = "${pkgs.scripts.wallpaperTools}/bin/bing-wp";
          };
          Unit = {
            Description = "Daily Bing wallpaper service";
          };
        };
      };
      timers = {
        bing-wp = {
          Install = {
            WantedBy = [ "timers.target" ];
          };
          Timer = {
            OnBootSec = "10s";
            OnUnitActiveSec = "1d";
          };
          Unit = {
            Description = "Daily Bing wallpaper timer";
          };
        };
      };
    };
  };
}
