{ pkgs, config, lib, ... }:

{
  imports = [
    ./office.nix
    ./mail.nix
  ];
}
