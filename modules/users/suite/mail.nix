{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.richard.suite.mail;

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
in {
  options.richard.suite.mail = {
    enable = mkOption {
      description = "Set up user email accounts";
      type = types.bool;
      default = false;
    };

    client = mkOption {
      description = "Choose email client. Default is neomutt.";
      type = types.enum ["neomutt" "thunderbird"];
      default = "neomutt";
    };
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      (
        if cfg.client == "thunderbird"
        then thunderbird
        else neomutt
      )
    ];
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
      neomutt = mkIf (cfg.client == "neomutt") {
        enable = true;
        binds = [
          {
            key = "i";
            map = ["index" "pager"];
            action = "noop";
          }
          {
            key = "g";
            map = ["index" "pager"];
            action = "noop";
          }
          {
            key = "M";
            map = ["index" "pager"];
            action = "noop";
          }
          {
            key = "C";
            map = ["index" "pager"];
            action = "noop";
          }
          {
            key = ''\cf'';
            map = ["index"];
            action = "noop";
          }
          {
            key = "h";
            map = ["index"];
            action = "noop";
          }
          {
            key = "<space>";
            map = ["editor"];
            action = "noop";
          }
          {
            key = "d";
            map = ["index" "pager" "browser"];
            action = "half-down";
          }
          {
            key = "u";
            map = ["index" "pager" "browser"];
            action = "half-up";
          }
          {
            key = ''\ek'';
            map = ["index" "pager"];
            action = "sidebar-prev";
          }
          {
            key = ''\ej'';
            map = ["index" "pager"];
            action = "sidebar-next";
          }
          {
            key = ''\eo'';
            map = ["index" "pager"];
            action = "sidebar-open";
          }
          {
            key = ''\ep'';
            map = ["index" "pager"];
            action = "sidebar-prev-new";
          }
          {
            key = ''\en'';
            map = ["index" "pager"];
            action = "sidebar-next-new";
          }
          {
            key = "B";
            map = ["index" "pager"];
            action = "sidebar-toggle-visible";
          }
          {
            key = "H";
            map = ["index" "pager"];
            action = "view-raw-message";
          }
          {
            key = "S";
            map = ["index" "pager"];
            action = "sync-mailbox";
          }
          {
            key = "R";
            map = ["index" "pager"];
            action = "group-reply";
          }
          {
            key = "<space>";
            map = ["index" "query"];
            action = "tag-entry";
          }
          {
            key = "h";
            map = ["attach" "pager"];
            action = "exit";
          }
          {
            key = "gg";
            map = ["index"];
            action = "first-entry";
          }
          {
            key = "j";
            map = ["index"];
            action = "next-entry";
          }
          {
            key = "k";
            map = ["index"];
            action = "previous-entry";
          }
          {
            key = "G";
            map = ["index"];
            action = "last-entry";
          }
          {
            key = "D";
            map = ["index"];
            action = "delete-message";
          }
          {
            key = "U";
            map = ["index"];
            action = "undelete-message";
          }
          {
            key = "L";
            map = ["index"];
            action = "limit";
          }
          {
            key = "l";
            map = ["index"];
            action = "display-message";
          }
          {
            key = ''\031''; # mouse wheel
            map = ["index"];
            action = "previous-undeleted";
          }
          {
            key = ''\005''; # mouse wheel
            map = ["index"];
            action = "next-undeleted";
          }
          {
            key = "<return>";
            map = ["attach"];
            action = "view-mailcap";
          }
          {
            key = "l";
            map = ["attach"];
            action = "view-mailcap";
          }
          {
            key = "<Tab>";
            map = ["editor"];
            action = "complete-query";
          }
          {
            key = "j";
            map = ["pager"];
            action = "next-line";
          }
          {
            key = "k";
            map = ["pager"];
            action = "previous-line";
          }
          {
            key = "l";
            map = ["pager"];
            action = "view-attachments";
          }
          {
            key = "gg";
            map = ["pager"];
            action = "top";
          }
          {
            key = "G";
            map = ["pager"];
            action = "bottom";
          }
          {
            key = ''\031''; # mouse wheel
            map = ["pager"];
            action = "previous-line";
          }
          {
            key = ''\005''; # mouse wheel
            map = ["pager"];
            action = "next-line";
          }
          {
            key = "gg";
            map = ["browser"];
            action = "top-page";
          }
          {
            key = "G";
            map = ["browser"];
            action = "bottom-page";
          }
          {
            key = "l";
            map = ["browser"];
            action = "select-entry";
          }
        ];
        changeFolderWhenSourcingAccount = true;
        checkStatsInterval = null;
        editor = "$EDITOR";
        extraConfig = "";
        macros = [
          {
            key = "gi";
            map = ["index" "pager"];
            action = ''"<change-folder>=Inbox<enter>" "Go to inbox"'';
          }
          {
            key = "Mi";
            map = ["index" "pager"];
            action = ''"<save-message>=Inbox<enter>" "Move mail to inbox"'';
          }
          {
            key = "Ci";
            map = ["index" "pager"];
            action = ''"<copy-message>=Inbox<enter>" "Copy mail to inbox"'';
          }
          {
            key = "gd";
            map = ["index" "pager"];
            action = ''"<change-folder>=Draft<enter>" "Go to draft"'';
          }
          {
            key = "Md";
            map = ["index" "pager"];
            action = ''"<save-message>=Draft<enter>" "Move mail to draft"'';
          }
          {
            key = "Cd";
            map = ["index" "pager"];
            action = ''"<copy-message>=Draft<enter>" "Copy mail to draft"'';
          }
          {
            key = "gs";
            map = ["index" "pager"];
            action = ''"<change-folder>=Sent<enter>" "Go to sent"'';
          }
          {
            key = "Ms";
            map = ["index" "pager"];
            action = ''"<save-message>=Sent<enter>" "Move mail to sent"'';
          }
          {
            key = "Cs";
            map = ["index" "pager"];
            action = ''"<copy-message>=Sent<enter>" "Copy mail to sent"'';
          }
          {
            key = "ga";
            map = ["index" "pager"];
            action = ''"<change-folder>=Archive<enter>" "Go to archive"'';
          }
          {
            key = "Ma";
            map = ["index" "pager"];
            action = ''"<save-message>=Archive<enter>" "Move mail to archive"'';
          }
          {
            key = "Ca";
            map = ["index" "pager"];
            action = ''"<copy-message>=Archive<enter>" "Copy mail to archive"'';
          }
          {
            key = "gS";
            map = ["index" "pager"];
            action = ''"<change-folder>=Spam<enter>" "Go to spam"'';
          }
          {
            key = "MS";
            map = ["index" "pager"];
            action = ''"<save-message>=Spam<enter>" "Move mail to spam"'';
          }
          {
            key = "CS";
            map = ["index" "pager"];
            action = ''"<copy-message>=Spam<enter>" "Copy mail to spam"'';
          }
          {
            key = "gt";
            map = ["index" "pager"];
            action = ''"<change-folder>=Trash<enter>" "Go to trash"'';
          }
          {
            key = "Mt";
            map = ["index" "pager"];
            action = ''"<save-message>=Trash<enter>" "Move mail to trash"'';
          }
          {
            key = "Ct";
            map = ["index" "pager"];
            action = ''"<copy-message>=Trash<enter>" "Copy mail to trash"'';
          }

          {
            key = "h";
            map = ["browser"];
            action = ''"<change-dir><kill-line>..<enter>" "Go to parent folder"'';
          }
        ];
        settings = {};
        sidebar = {
          enable = true;
          format = "%D%?F? [%F]?%* %?N?%N/? %?S?%S?"; # "%D%?F? [%F]?%* %?N?%N/?%S"
          shortPath = true;
          width = 20;
          sort = "threads";
          vimKeys = false;
        };
      };
    };
  };
}
