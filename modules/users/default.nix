{ pkgs, config, lib, ... }:

{
  imports = [
    ./core
    ./direnv
    ./git
    ./graphical
    ./security
    ./terminal
  ];
}
