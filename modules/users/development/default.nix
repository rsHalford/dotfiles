{ pkgs, config, lib, ... }:

{
  imports = [
    ./emacs.nix
    ./helix.nix
    ./languages.nix
    ./neovim.nix
  ];
}
