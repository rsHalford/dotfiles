{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.richard.browser.http;
in {
  options.richard.browser.http.w3m = {
    enable = mkOption {
      description = "Enable w3m";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.w3m.enable) {
    home = {
      /* file."${config.xdg.configHome}/w3m/config".text = ''
      ''; */
      packages = with pkgs; [
        w3m
      ];
    };
  };
}
