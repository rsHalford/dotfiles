{ pkgs, config, lib, ... }:

{
  imports = [
    ./browser
    ./core
    ./development
    ./direnv
    ./git
    ./graphical
    ./media
    ./messaging
    ./security
    ./services
    ./terminal
  ];
}
