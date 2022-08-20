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
      libreoffice-fresh
      protonmail-bridge
      qbittorrent
      thunderbird
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
      };
    };
  };
}
