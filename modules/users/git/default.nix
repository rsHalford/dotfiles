{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.richard.git;
  terminal-editor = config.richard.terminal.utilities.editor;
in {
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
      default = "dev@rshalford.com";
    };

    signByDefault = mkOption {
      description = "GPG signing key for git";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      scripts.worktreeTools
    ];
    programs.git = {
      enable = true;
      package = pkgs.gitFull;
      userName = cfg.userName;
      userEmail = cfg.userEmail;
      delta.enable = true;
      extraConfig = {
        branch.autoSetupRebase = "always";
        core.editor = "${terminal-editor}";
        delta = {
          line-numbers = true;
          navigate = true;
          side-by-side = false;
        };
        diff.colorMoved = "zebra";
        fetch.prune = true;
        init.defaultBranch = "main";
        merge.conflictStyle = "diff3";
        pull.rebase = true;
        push.autoSetupRemote = true;
      };
      ignores = [
        ".direnv"
        ".env"
        ".envrc"
      ];
      signing = {
        key = "908E7F42";
        signByDefault = cfg.signByDefault;
      };
    };
  };
}
