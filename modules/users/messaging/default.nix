{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.richard.messaging;
in {
  options.richard.messaging = {
    enable = mkOption {
      description = "Enable a set of commonly used messaging clients";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      element-desktop
    ];
  };
}
