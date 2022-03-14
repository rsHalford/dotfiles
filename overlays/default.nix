{ pkgs, neovim-nightly, scripts, system, lib }:

{
  overlays = [
    neovim-nightly.overlay
    scripts.overlay
  ];
}
