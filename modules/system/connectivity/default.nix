{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.richard.connectivity;
in {
  options.richard.connectivity = {
    bluetooth.enable = mkOption {
      description = "Enable bluetooth with default options";
      type = types.bool;
      default = false;
    };

    kde-connect.enable = mkOption {
      description = "Enable KDE connect with default options";
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

    virtualisation.enable = mkOption {
      description = "Enable virtualisation for system users";
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

    programs.kdeconnect.enable = cfg.kde-connect.enable;

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

    services.udisks2.enable = true;

    networking.wireguard.enable = cfg.vpn.enable;
    services.mullvad-vpn = {
      enable = cfg.vpn.enable;
      package = pkgs.mullvad-vpn;
    };

    environment.systemPackages = with pkgs; mkIf (cfg.virtualisation.enable) [
      virt-manager
      virt-viewer
      spice
      spice-gtk
      win-virtio
      win-spice
      gnome.adwaita-icon-theme
    ];

    virtualisation = {
      libvirtd =  mkIf (cfg.virtualisation.enable) {
        enable = true;
        qemu = {
          swtpm.enable = true;
          ovmf.enable = true;
          ovmf.packages = [ pkgs.OVMFFull.fd ];
        };
      };
      spiceUSBRedirection.enable = true;
    };
    services.spice-vdagentd.enable = cfg.virtualisation.enable;
  };
}
