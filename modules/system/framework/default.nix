{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.richard.framework;
in {
  options.richard.framework = {
    enable = mkOption {
      description = "Whether to enable framework settings. Also tags framework for user settings";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    environment.systemPackages = with pkgs; [
      acpid
      brightnessctl
    ];

    /*
       fileSystems."/games" = {
      device = "/dev/disk/by-label/games";
      fsType = "ext4";
    };
    */

    hardware = {
      cpu.amd.updateMicrocode = true;
      opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
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
      gamescope.enable = true;
      steam = {
        enable = true;
        gamescopeSession.enable = true;
        dedicatedServer.openFirewall = true;
        remotePlay.openFirewall = true;
      };
    };
    services = {
      fprintd.enable = true;
      fwupd.enable = true;
      power-profiles-daemon.enable = true;
    };
  };
}
