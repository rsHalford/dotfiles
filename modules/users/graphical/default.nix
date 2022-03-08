{ pkgs, config, lib, ... }:

{
  imports = [
    ./compositor.nix
    ./utilities.nix
  ];
}
