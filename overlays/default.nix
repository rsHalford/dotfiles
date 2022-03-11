{ pkgs, neovim-nightly, system, lib }:

{
  overlays = [
    neovim-nightly.overlay
  ];
}
