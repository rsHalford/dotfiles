{ pkgs, config, lib, ... }:

{
  imports = [
    ./browser
    ./core
    ./direnv
    ./git
    ./graphical
    ./messaging
    ./security
    ./terminal
  ];
}
