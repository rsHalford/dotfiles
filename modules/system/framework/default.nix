{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.richard.framework;
in {
  options.richard.framework = {
    enable = mkOption {
      description = "Whether to enable framework settings. Also tags framework for user settings";
      type = types.bool;
      default = false;
    };

    fprint = {
      enable = mkOption {
        description = "Enable fingerprint";
        type = types.bool;
        default = true;
      };
    };
  };

  config = mkIf (cfg.enable) (mkMerge [
    {
      environment.systemPackages = with pkgs; [
        acpid
        brightnessctl
      ];
    }
    (mkIf cfg.fprint.enable {
      services.fprintd.enable = true;
    })
  ]);
}

