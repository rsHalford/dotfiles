{
  pkgs,
  nur,
  # emacs-unstable,
  godo-flake,
  tag-flake,
  scripts,
  system,
  lib,
}: {
  overlays = [
    nur.overlay
    # emacs-unstable.overlay
    scripts.overlay
    (final: prev: {
      godo = godo-flake.packages.${system}.godo;
      tag = tag-flake.packages.${system}.tag;
    })
  ];
}
