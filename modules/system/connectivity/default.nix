{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.richard.connectivity;
in
{
  options.richard.connectivity = {
    bluetooth.enable = mkOption {
      description = "Enable bluetooth with default options";
      type = types.bool;
      default = false;
    };

    printing.enable = mkOption {
      description = "Enable printing with default options";
      type = types.bool;
      default = false;
    };

    sound.enable = mkOption {
      description = "Enable sound with default options";
      type = types.bool;
      default = false;
    };

    vpn.enable = mkOption {
      description = "Enable vpn using mullvad and wireguard";
      type = types.bool;
      default = false;
    };
  };

  config = {
    hardware.bluetooth.enable = cfg.bluetooth.enable;
    services.blueman.enable = cfg.bluetooth.enable;

    services.printing = {
      enable = cfg.printing.enable;
      # drivers = cfg.printing.drivers; # with pkgs; [ ];
      # browsing = cfg.printing.browsing; # false;
      # defaultShared = cfg.printing.shared; # false;
    };

    security.rtkit.enable = cfg.sound.enable;
    services.pipewire = {
      enable = cfg.sound.enable;
      alsa.enable = cfg.sound.enable;
      alsa.support32Bit = cfg.sound.enable;
      pulse.enable = cfg.sound.enable;
    };

    networking.wireguard.enable = cfg.vpn.enable;
    services.mullvad-vpn.enable = cfg.vpn.enable;
  };
}
