{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.richard.suite.tex;
  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-basic
      collection-latexextra
      collection-fontsrecommended;
  });
in
{
  options.richard.suite.tex = {
    enable = mkOption {
      description = "Enable TeX Live";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      tex
    ];
  };
}
