{lib, ...}:
with lib; {
  imports = [
    ./amfora.nix
    ./chromium.nix
    ./firefox.nix
    ./qutebrowser.nix
    ./w3m.nix
  ];

  options.richard.browser = {
    http.preferred = mkOption {
      description = "Choose preferred http GUI browser. Default is firefox.";
      type = types.enum ["brave" "firefox" "qutebrowser"];
      default = "firefox";
    };
  };
}
