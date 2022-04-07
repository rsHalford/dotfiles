{ pkgs, config, lib, ... }:

{
  imports = [
    ./emacs.nix
    ./languages.nix
    ./neovim.nix
  ];
}
