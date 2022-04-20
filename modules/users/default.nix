{ pkgs, config, lib, ... }:

{
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
}
