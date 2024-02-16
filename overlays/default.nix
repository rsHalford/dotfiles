{
  pkgs,
  nixvim,
  nix-colors,
  nur,
  scripts,
  system,
  lib,
}: {
  overlays = [
    nur.overlay
    scripts.overlay
    (self: super: {
      inherit nixvim nix-colors;
    })
  ];
}
