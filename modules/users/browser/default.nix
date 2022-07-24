{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.richard.browser.preferred;
in
{
  imports = [
    ./qutebrowser.nix
    ./firefox.nix
  ];

  options.richard.browser = {
    preferred = mkOption {
      description = "Choose preferred browser. Default is firefox.";
      type = types.enum [ "firefox" "qutebrowser" ];
      default = "firefox";
    };
  };
}
