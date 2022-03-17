{ pkgs, emacs-unstable, neovim-nightly, scripts, system, lib }:

{
  overlays = [
    emacs-unstable.overlay
    neovim-nightly.overlay
    scripts.overlay
  ];
}
