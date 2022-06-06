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
        gcc
        git-chglog
        golangci-lint
        gopls
        nodejs
        nodePackages.typescript
        pre-commit
        python310Packages.markdown2

        # Language Server
        nodePackages.bash-language-server
        nodePackages.svelte-language-server
        nodePackages.typescript-language-server
        nodePackages.vim-language-server
        nodePackages.vscode-langservers-extracted
        nodePackages.yaml-language-server
        rnix-lsp
        shellcheck
        stylua

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
