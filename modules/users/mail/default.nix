{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.richard.mail;

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
  options.richard.mail = {
    enable = mkOption {
      description = "Enable mail";
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
    programs = {
      mbsync.enable = true;
      msmtp.enable = true;
      mu.enable = true;
    };
  };
}
