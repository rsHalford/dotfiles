{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.richard.boot;
in
{
  options.richard.boot = mkOption {
    description = "Type of boot. Default encrypted-efi";
    type = types.enum [ "encrypted-efi" ];
    default = null;
  };

  config = mkIf (cfg == "encrypted-efi") {
    boot = {
      loader = {
        efi.canTouchEfiVariables = true;
        systemd-boot.enable = true;
        timeout = 3;
      };
      plymouth = {
        enable = true;
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
      { device = "/dev/disk/by-label/SWAP"; }
    ];
  };
}
