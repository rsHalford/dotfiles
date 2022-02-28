{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.richard.gpg;
in
{
  options.richard.gpg = {
    enable = mkOption {
      description = "Enable gpg";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      pinentry-qt
    ];

    programs.gpg = {
      enable = true;
      homedir = "${config.xdg.dataHome}/gnupg";
    };

    services.gpg-agent = {
      enable = true;
      pinentryFlavor = "qt";
      enableExtraSocket = true;
      enableScDaemon = false;
    };
  };
}
