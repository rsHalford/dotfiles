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
        golangci-lint
        gopls
        pre-commit
      ];
    };
    programs = {
      go = {
        enable = cfg.go.enable;
      };
    };
  };
}
