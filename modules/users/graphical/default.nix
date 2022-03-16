{ pkgs, config, lib, ... }:

{
  imports = [
    ./compositor.nix
    ./menu.nix
    ./utilities.nix
  ];
}
