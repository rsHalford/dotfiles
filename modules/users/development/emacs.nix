{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.richard.development.emacs;
  emacsPkg = (pkgs.emacsWithPackagesFromUsePackage {
    package = pkgs.emacsPgtkNativeComp;
    config = ./emacs/init.org;
    alwaysEnsure = true;
  });
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
        "${config.xdg.configHome}/emacs/init.el".source = pkgs.runCommand "init.el" { } ''
          cp ${./emacs/init.org} init.org
          ${pkgs.emacs}/bin/emacs -Q --batch ./init.org -f org-babel-tangle
          mv init.el $out
        '';
      };
      packages = with pkgs; [
        emacsPkg
        emacs-all-the-icons-fonts
        hunspell
        hunspellDicts.en-gb-large
        mu
      ];
    };
    services.emacs = {
      enable = true;
      package = emacsPkg;
      client.enable = true;
      socketActivation.enable = true;
    };
  };
}
