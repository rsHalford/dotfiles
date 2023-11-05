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
        # Nix
        alejandra
        nil

        # Shell
        nodePackages.bash-language-server
        shellcheck

        # Writing
        vale

        # Front-end
        nodePackages.vscode-langservers-extracted
        nodePackages."@astrojs/language-server"
        nodePackages."@tailwindcss/language-server"

        # Markup
        marksman
        nodePackages.yaml-language-server
        taplo

        # Lua
        lua-language-server
        selene
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
