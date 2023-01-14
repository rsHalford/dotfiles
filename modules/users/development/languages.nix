{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.richard.development.languages;
in
{
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
        android-tools
        dart
        flutter
        gcc
        git-chglog
        golangci-lint
        gopls
        jdk
        marksman
        nodejs
        nodePackages.typescript
        poetry
        pre-commit
        python310Packages.markdown2
        python3Full

        # Language Server
        nil
        nodePackages.bash-language-server
        nodePackages.svelte-language-server
        nodePackages.typescript-language-server
        nodePackages.vim-language-server
        nodePackages.vscode-langservers-extracted
        nodePackages.yaml-language-server
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
