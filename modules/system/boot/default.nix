{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.richard.boot;
in {
  options.richard.boot = mkOption {
    description = "Type of boot. Default systemd-boot";
    type = types.enum ["systemd-boot"];
    default = null;
  };

  config = mkIf (cfg == "systemd-boot") {
    boot = {
      loader = {
        efi.canTouchEfiVariables = true;
        systemd-boot.enable = true;
      };
    };

    fileSystems."/" = {
      device = "/dev/disk/by-label/NIXROOT";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
    };

    swapDevices = [
      {device = "/dev/disk/by-label/SWAP";}
    ];
  };
}
