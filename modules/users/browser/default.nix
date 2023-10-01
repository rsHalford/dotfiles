{
  lib,
  ...
}:
with lib; {
  imports = [
    ./amfora.nix
    ./brave.nix
    ./firefox.nix
    ./qutebrowser.nix
  ];

  options.richard.browser = {
    http.preferred = mkOption {
      description = "Choose preferred http GUI browser. Default is firefox.";
      type = types.enum ["brave" "firefox" "qutebrowser"];
      default = "firefox";
    };
  };
}
