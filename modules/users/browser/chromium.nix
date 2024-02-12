{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.richard.browser.http;
in {
  options.richard.browser.http = {
    brave.enable = mkOption {
      description = "Enable brave";
      type = types.bool;
      default = false;
    };

    chrome.enable = mkOption {
      description = "Enable chrome";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.brave.enable || cfg.chrome.enable) {
    home.packages = with pkgs; [
      (mkIf (cfg.brave.enable) brave)
      (mkIf (cfg.chrome.enable) google-chrome)
    ];
    programs = {
      browserpass = {
        enable = true;
        browsers = [
          (mkIf (cfg.brave.enable) "brave")
          (mkIf (cfg.chrome.enable) "chrome")
        ];
      };
    };
  };
}
