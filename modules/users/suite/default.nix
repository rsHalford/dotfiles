{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.richard.suite;

  mbsyncConfig = {
    enable = true;
    create = "both";
    expunge = "both";
  };

  "richard@xhalford.com" = {
    primary = true;
    address = "richard@xhalford.com";
    userName = "richard";
    realName = "Richard Halford";
    imap = {
      host = "mail.xhalford.com";
      port = 993;
    };
    smtp = {
      host = "mail.xhalford.com";
      port = 587;
      tls = {
        useStartTls = true;
      };
    };
    mbsync = mbsyncConfig;
    msmtp.enable = true;
    mu.enable = true;
    passwordCommand = "${pkgs.pass}/bin/pass Email/richard@xhalford.com";
  };

  "richardh.1995@googlemail.com" = {
    primary = false;
    address = "richardh.1995@googlemail.com";
    userName = "richardh.1995@googlemail.com";
    realName = "Richard Halford";
    flavor = "gmail.com";
    imap = {
      host = "imap.gmail.com";
      port = 993;
    };
    smtp = {
      host = "smtp.gmail.com";
      port = 587;
      tls = {
        useStartTls = true;
      };
    };
    mbsync = mbsyncConfig;
    msmtp.enable = true;
    mu.enable = true;
    passwordCommand = "${pkgs.pass}/bin/pass Email/richardh.1995@googlemail.com";
  };
in
{
  options.richard.suite = {
    enable = mkOption {
      description = "Enable suite";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    accounts.email = {
      accounts = {
        inherit "richard@xhalford.com";
        inherit "richardh.1995@googlemail.com";
      };
      maildirBasePath = "${config.xdg.dataHome}/mail";
    };
    home.packages = with pkgs; [
      godo
      inkscape
      khal
      khard
      libreoffice-fresh
      vdirsyncer
    ];
    programs = {
      mbsync.enable = true;
      msmtp.enable = true;
      mu.enable = true;
    };
    systemd.user = {
      services = {
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
