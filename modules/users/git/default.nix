{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.richard.git;
  terminal-editor = config.richard.terminal.utilities.editor;
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
      delta.enable = true;
      extraConfig = {
        core.editor = "${terminal-editor}";
        delta = {
          line-numbers = true;
          navigate = true;
          side-by-side = true;
          syntax-theme = "gruvbox-dark";
        };
        diff.colorMoved = "zebra";
        fetch.prune = true;
        init.defaultBranch = "main";
        merge.conflictStyle = "diff3";
        pull.rebase = true;
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
