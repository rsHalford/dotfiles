{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.richard.development.emacs;
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
    home.packages = with pkgs; [
      emacsPgtkGcc
      # (emacsWithPackagesFromUsePackage {
      #   package = pkgs.emacsPgtkGcc;
      #   config = ./emacs.el;
      #   alwaysEnsure = false;
      #   alwaysTangle = false;
      #   extraEmacsPackages = epkgs: [ ];
      #   override = epkgs: epkgs // { };
      # })
    ];
    # programs = {
    #   emacs = {
    #     enable = true;
    #     package = pkgs.emacsPgtkGcc;
    #     extraConfig = "";
    #     extraPackages = with pkgs; [ ];
    #     overrides = "self: super: { }";
    #   };
    # };
    # services = {
    #   emacs = {
    #     enable = true;
    #     package = if config.programs.emacs.enable then config.programs.emacs.finalPackage else pkgs.emacs;
    #     client = {
    #       enable = false;
    #       arguments = [ "-c" ];
    #     };
    #     defaultEditor = false;
    #     extraOptions = [ ];
    #     socketActivation.enable = false;
    #   };
    # };
  };
}
