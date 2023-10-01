{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.richard.browser.http;
in {
  options.richard.browser.http.brave = {
    enable = mkOption {
      description = "Enable brave";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.brave.enable) {
    home.packages = with pkgs; [
      brave
    ];
    programs = {
      browserpass = {
        enable = true;
        browsers = ["brave"];
      };
    };
  };
}
