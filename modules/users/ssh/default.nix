{ pkgs, config, lib, ...}:
with lib;

let
  cfg = config.richard.ssh;
in
{
  options.richard.ssh = {
    enable = mkOption {
      description = "Enable client-side SSH";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    # programs.ssh = {
    # enable = true;
    # };
  };
}
