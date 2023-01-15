{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.richard.development.languages;
in {
  options.richard.development.languages = {
    go.enable = mkOption {
      description = "Enable Go language and tools for development";
      type = types.bool;
      default = false;
    };
  };

  config = {
    home = {
      packages = with pkgs; [
        alejandra
        android-tools
        dart
        flutter
        git-chglog
        golangci-lint
        gopls
        jdk
        marksman
        nil
        nodePackages."@astrojs/language-server"
        nodePackages.bash-language-server
        nodePackages.svelte-language-server
        nodePackages.typescript
        nodePackages.typescript-language-server
        nodePackages.vim-language-server
        nodePackages.vscode-langservers-extracted
        nodePackages.yaml-language-server
        nodejs
        poetry
        pre-commit
        python310Packages.markdown2
        python3Full
        selene
        shellcheck
        stylua
        sumneko-lua-language-server

        # Tree-sitter
        tree-sitter
        gcc
      ];
    };
    programs = {
      go = {
        enable = cfg.go.enable;
        goPath = ".local/share/go";
      };
    };
  };
}
