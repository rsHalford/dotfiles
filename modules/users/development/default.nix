{ pkgs, config, lib, ... }:

{
  imports = [
    ./emacs.nix
    ./neovim.nix
  ];
}
