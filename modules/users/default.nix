{ pkgs, config, lib, ... }:

{
  imports = [
    ./browser
    ./core
    ./direnv
    ./git
    ./graphical
    ./security
    ./terminal
  ];
}
