{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.richard.git;
in
{
  options.richard.git = {
    enable = mkOption {
      description = "Enable git";
      type = types.bool;
      default = false;
    };

    userName = mkOption {
      description = "Name for git";
      type = types.str;
      default = "Richard Halford";
    };

    userEmail = mkOption {
      description = "Email for git";
      type = types.str;
      default = "richard@xhalford.com";
    };

    signByDefault = mkOption {
      description = "GPG signing key for git";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      git
      scripts.worktreeTools
    ];
    programs.git = {
      enable = true;
      userName = cfg.userName;
      userEmail = cfg.userEmail;
      # aliases = { };
      # attributes = [ ];
      # delta = {
      #   enable = false;
      #   options = { };
      # };
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = true;
        fetch.prune = true;
        diff.colorMoved = "zebra";
      };
      ignores = [
        ".direnv"
        ".env"
        ".envrc"
      ];
      # includes = [ ];
      signing = {
        key = null;
        signByDefault = cfg.signByDefault;
      };
    };
  };
}
