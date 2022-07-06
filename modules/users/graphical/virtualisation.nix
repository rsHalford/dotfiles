{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.richard.graphical.virtualisation;
in
{
  options.richard.graphical.virtualisation = {
    enable = mkOption {
      description = "Enable virt-manager";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      virt-manager
    ];
  };
}
