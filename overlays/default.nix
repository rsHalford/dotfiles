{ pkgs, nur, emacs-unstable, godo-flake, neovim-nightly, scripts, system, lib }:

{
  overlays = [
    nur.overlay
    emacs-unstable.overlay
    neovim-nightly.overlay
    scripts.overlay
    (final: prev: {
      godo = godo-flake.packages.${system}.godo;
    })
  ];
}
