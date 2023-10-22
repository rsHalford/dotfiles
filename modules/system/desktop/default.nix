{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.richard.desktop;
in {
  options.richard.desktop = {
    enable = mkOption {
      description = "Enable desktop options";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    fileSystems."/games" = {
      device = "/dev/disk/by-label/games";
      fsType = "ext4";
    };

    hardware = {
      opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
      };
      nvidia = {
        modesetting.enable = true;
        nvidiaSettings = true;
        open = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
      };
    };

    programs = {
      gamemode = {
        enable = true;
        settings = {
          custom = {
            start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
            end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
          };
        };
      };
      steam = {
        enable = true;
        dedicatedServer.openFirewall = true;
        remotePlay.openFirewall = true;
      };
      sway = {
        extraOptions = [
          "--unsupported-gpu"
        ];
      };
    };
  };
}
