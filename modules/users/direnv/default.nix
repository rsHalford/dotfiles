{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.richard.direnv;
in
{
  options.richard.direnv = {
    enable = mkOption {
      description = "Enable direnv";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
      stdlib =
        ''
          declare -A direnv_layout_dirs
          direnv_layout_dir() {
            echo "''${direnv_layout_dirs[$PWD]:=$(
                echo -n ${config.xdg.cacheHome}/direnv/layouts/
                echo -n "$PWD" | shasum | cut -d ' ' -f 1
                )}"
          }
        '';
    };
  };
}
