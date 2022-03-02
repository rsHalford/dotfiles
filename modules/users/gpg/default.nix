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
      gnupg
      pinentry-qt
    ];

    programs.gpg = {
      enable = true;
    };

    services.gpg-agent = {
      enable = true;
      # enableExtraSocket = false;
      # enableScDaemon = false;
      enableSshSupport = true;
      defaultCacheTtl = 28800;
      # defaultCacheTtlSsh = null;
      # extraConfig = "";
      maxCacheTtl = 86400;
      # maxCacheTtlSsh = null;
      pinentryFlavor = "qt";
      # sshKeys = null;
    };
  };
}
