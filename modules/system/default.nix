{ pkgs, config, lib, ... }:
{
  imports = [
    ./boot
    ./connectivity
    ./core
    ./laptop
  ];
}
