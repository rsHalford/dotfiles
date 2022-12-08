{ pkgs, config, lib, ... }:

{
  imports = [
    ./mail.nix
    ./office.nix
    ./tex.nix
  ];
}
