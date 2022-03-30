{ pkgs, config, lib, ... }:

{
  imports = [
    ./browser
    ./core
    ./development
    ./direnv
    ./git
    ./graphical
    ./mail
    ./media
    ./messaging
    ./security
    ./services
    ./terminal
  ];
}
