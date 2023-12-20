{
  pkgs,
  nixvim,
  nur,
  # emacs-unstable,
  godo-flake,
  tag-flake,
  templ-flake,
  scripts,
  system,
  lib,
}: {
  overlays = [
    nur.overlay
    # emacs-unstable.overlay
    scripts.overlay
    (self: super: {
      inherit nixvim;
      tmux = super.tmux.overrideAttrs (old: {
        configureFlags = old.configureFlags ++ ["--enable-sixel"];
        src = super.fetchFromGitHub {
          owner = "tmux";
          repo = "tmux";
          rev = "bdf8e614af34ba1eaa8243d3a818c8546cb21812";
          hash = "sha256-ZMlpSOmZTykJPR/eqeJ1wr1sCvgj6UwfAXdpavy4hvQ=";
        };
        patches = [];
      });
    })
    (final: prev: {
      godo = godo-flake.packages.${system}.godo;
      tag = tag-flake.packages.${system}.tag;
      templ = templ-flake.packages.${system}.templ;
    })
  ];
}
