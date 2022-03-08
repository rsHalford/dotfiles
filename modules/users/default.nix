{ pkgs, config, lib, ... }:

{
  imports = [
    ./browser
    ./core
    ./direnv
    ./git
    ./graphical
    ./media
    ./messaging
    ./security
    ./terminal
  ];
}
