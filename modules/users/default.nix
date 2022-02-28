{ pkgs, config, lib, ... }:

{
  imports = [
    ./core
    ./direnv
    ./git
    ./gpg
    ./graphical
    ./ssh
    ./terminal
  ];
}
