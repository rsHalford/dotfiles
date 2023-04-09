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
        branch.autoSetupRebase = "always";
        core.editor = "${terminal-editor}";
        delta = {
          line-numbers = true;
          navigate = true;
          side-by-side = true;
          minus-style = ''syntax "#37222c"'';
          minus-non-emph-style = ''syntax "#37222c"'';
          minus-emph-style = ''syntax "#713137"'';
          minus-empty-line-marker-style = ''syntax "#37222c"'';
          line-numbers-minus-style = ''"#c25d64"'';
          plus-style = ''syntax "#20303b"'';
          plus-non-emph-style = ''syntax "#20303b"'';
          plus-emph-style = ''syntax "#2c5a66"'';
          plus-empty-line-marker-style = ''syntax "#20303b"'';
          line-numbers-plus-style = ''"#399a96"'';
          line-numbers-zero-style = ''"#3b4261"'';
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
      # includes = [ ];
      signing = {
        key = "908E7F42";
        signByDefault = cfg.signByDefault;
      };
    };
  };
}
