{ pkgs, config, lib, ... }:
with lib;

{
  imports = [
    ./firefox.nix
    ./qutebrowser.nix
  ];

  options.richard.browser = {
    http.preferred = mkOption {
      description = "Choose preferred http GUI browser. Default is firefox.";
      type = types.enum [ "firefox" "qutebrowser" ];
      default = "firefox";
    };
  };
}
