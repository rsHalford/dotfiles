{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.richard.development.emacs;
  emacsPkg = pkgs.callPackage
    (
      { emacsWithPackagesFromUsePackage }:
      (emacsWithPackagesFromUsePackage {
        package = pkgs.emacsPgtkGcc;
        config = ./init.el;
        alwaysEnsure = true;
      })
    )
    { };
in
{
  options.richard.development.emacs = {
    enable = mkOption {
      description = "Enable development with emacs";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    home = {
      file = {
        ".emacs.d/init.el".source = ./init.el;
      };
      packages = with pkgs; [
        emacsPkg
        emacs-all-the-icons-fonts
      ];
    };
  };
}
