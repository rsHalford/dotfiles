{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.richard.suite.office;
in {
  options.richard.suite.office = {
    enable = mkOption {
      description = "Enable office suite";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      imagemagick
      inkscape
      krita
      libreoffice-fresh
      qbittorrent
      typst
    ];
  };
}
