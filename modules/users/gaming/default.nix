{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.richard.gaming;
in {
  options.richard.gaming = {
    enable = mkOption {
      description = "Enable gaming";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      retroarchFull
    ];
  };
}
