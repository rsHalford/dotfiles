{ pkgs, config, lib, ... }:

{
  imports = [
    ./qutebrowser.nix
    ./firefox.nix
  ];
}
