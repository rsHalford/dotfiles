{ pkgs, config, lib, ... }:
{
  imports = [
    ./boot
    ./connectivity
    ./core
    ./desktop
    ./laptop
  ];
}
