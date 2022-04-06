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
      syncthing = {
        enable = cfg.syncthing.enable;
        tray = {
          enable = true;
          command = "syncthingtray --wait";
        };
      };
    };
  };
}
