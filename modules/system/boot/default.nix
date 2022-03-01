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
        efi = {
	  canTouchEfiVariables = true;
	  efiSysMountPoint = "/boot/efi";
	};
	grub = {
	  enable = true;
	  # backgroundColor = "";
	  devices = [ "nodev" ];
	  efiSupport = true;
	  extraEntries = ''
	    menuentry "Reboot" {
              reboot
            }
            menuentry "Shutdown" {
              halt
            }
	  '';
	  # font = "${pkgs.grub2}/share/grub/unicode.pf2";
	  # fontSize = null;
	  # splashImage = null;
	  # splashMode = "stretch";
	  # theme = null;
	  useOSProber = true;
	  version = 2;
	};
        timeout = 3;
      };
      plymouth = {
        enable = false;
      };
    };
    
    fileSystems."/" = {
      device = "/dev/disk/by-label/NIXROOT";
      fsType = "ext4";
    };

    fileSystems."/boot/efi" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
    };

    swapDevices = [
      { device = "/dev/disk/by-label/SWAP"; }
    ];
  };
}
