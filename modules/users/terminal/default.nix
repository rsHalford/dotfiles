{ pkgs, config, lib, ... }:

{
  imports = [
    ./emulator
    ./shell.nix
    ./utilities.nix
  ];
}
