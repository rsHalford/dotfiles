{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.richard.suite.office;
in
{
  options.richard.suite.office = {
    enable = mkOption {
      description = "Enable office suite";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      godo
      inkscape
      khal
      khard
      libreoffice-fresh
      protonmail-bridge
      thunderbird
      vdirsyncer
    ];
    systemd.user = {
      services = {
        protonmail-bridge = {
          Install = {
            WantedBy = [ "default.target" ];
          };
          Service = {
            Restart = "always";
            ExecStart = "${pkgs.protonmail-bridge}/bin/protonmail-bridge --no-window --log-level info --noninteractive";
          };
          Unit = {
            Description = "Proton Mail Bridge";
            After = [ "network-target" ];
          };
        };
        vdirsyncer = {
          Service = {
            ExecStart = "${pkgs.vdirsyncer}/bin/vdirsyncer sync";
            Restart = "on-failure";
            RuntimeMaxSec = "3m";
          };
          Unit = {
            Description = "Synchronize calendars and contacts";
            Documentation = "https://vdirsyncer.readthedocs.org/";
          };
        };
      };
      timers = {
        vdirsyncer = {
          Install = {
            WantedBy = [ "timers.target" ];
          };
          Timer = {
            AccuracySec = "5m";
            OnBootSec = "5m";
            OnUnitActiveSec = "15m";
          };
          Unit = {
            Description = "Synchronize vdirs";
          };
        };
      };
    };
  };
}
