{lib, ...}:
with lib; {
  imports = [
    ./browser
    ./core
    ./development
    ./direnv
    ./gaming
    ./git
    ./graphical
    ./media
    ./messaging
    ./security
    ./services
    ./suite
    ./terminal
  ];

  options.richard.theme = mkOption {
    type = types.attrs;
  };
}
