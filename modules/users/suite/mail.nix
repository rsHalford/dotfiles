{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.richard.suite.mail;
  editor = config.richard.terminal.utilities.editor;
in {
  options.richard.suite.mail = {
    enable = mkOption {
      description = "Set up user email accounts";
      type = types.bool;
      default = false;
    };

    client = mkOption {
      description = "Choose email client. Default is neomutt.";
      type = types.enum ["aerc" "neomutt" "thunderbird"];
      default = "aerc";
    };
  };

  imports = [~/.dotfiles/secrets/suite];

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      (mkIf (cfg.client == "thunderbird") thunderbird)
      khal
      khard
      vdirsyncer
    ];
    programs = mkIf (cfg.enable) {
      mbsync.enable = true;
      msmtp.enable = true;
      notmuch.enable = true;

      aerc = mkIf (cfg.client == "aerc") {
        enable = true;
        extraBinds = {
          global = {
            "<C-p>" = ":prev-tab<Enter>";
            "<C-PgUp>" = ":prev-tab<Enter>";
            "<C-n>" = ":next-tab<Enter>";
            "<C-PgDn>" = ":next-tab<Enter>";
            "<C-t>" = ":term<Enter>";
            "?" = ":help keys<Enter>";
            "<C-c>" = ":quit<Enter>";
            "<C-q>" = ":quit<Enter>";
          };

          messages = {
            q = ":quit<Enter>";
            j = ":next<Enter>";
            "<Down>" = ":next<Enter>";
            "<C-d>" = ":next 50%<Enter>";
            "<C-f>" = ":next 100%<Enter>";
            "<PgDn>" = ":next 100%<Enter>";
            k = ":prev<Enter>";
            "<Up>" = ":prev<Enter>";
            "<C-u>" = ":prev 50%<Enter>";
            "<C-b>" = ":prev 100%<Enter>";
            "<PgUp>" = ":prev 100%<Enter>";
            g = ":select 0<Enter>";
            G = ":select -1<Enter>";
            J = ":next-folder<Enter>";
            "<C-Down>" = ":next-folder<Enter>";
            "<A-j>" = ":next-folder<Enter>";
            K = ":prev-folder<Enter>";
            "<C-Up>" = ":prev-folder<Enter>";
            "<A-k>" = ":prev-folder<Enter>";
            H = ":collapse-folder<Enter>";
            "<C-Left>" = ":collapse-folder<Enter>";
            "<A-h>" = ":collapse-folder<Enter>";
            L = ":expand-folder<Enter>";
            "<C-Right>" = ":expand-folder<Enter>";
            "<A-l>" = ":expand-folder<Enter>";
            v = ":mark -t<Enter>";
            "<Space>" = ":mark -t<Enter>:next<Enter>";
            V = ":mark -v<Enter>";
            T = ":toggle-threads<Enter>";
            "zc" = ":fold<Enter>";
            "zo" = ":unfold<Enter>";
            "<Enter>" = ":view<Enter>";
            l = ":view<Enter>";
            u = ":read -t<enter>";
            d = ":move Trash<Enter>";
            D = ":prompt 'Really delete this message?' 'delete-message'<Enter>";
            a = ":archive flat<Enter>";
            A = ":unmark -a<Enter>:mark -T<Enter>:archive flat<Enter>";
            C = ":compose<Enter>";
            m = ":compose<Enter>";
            "rr" = ":reply -a<Enter>";
            "rq" = ":reply -aq<Enter>";
            "Rr" = ":reply<Enter>";
            "Rq" = ":reply -q<Enter>";
            c = ":cf<space>";
            "$" = ":term<space>";
            "!" = ":term<space>";
            "|" = ":pipe<space>";
            "/" = ":search<space>";
            "\\" = ":filter<space>";
            n = ":next-result<Enter>";
            N = ":prev-result<Enter>";
            "<Esc>" = ":clear<Enter>";
            s = ":split<Enter>";
            S = ":vsplit<Enter>";
          };

          "messages:folder=Drafts" = {
            "<Enter>" = ":recall<Enter>";
          };

          "view" = {
            "/" = ":toggle-key-passthrough<Enter>/";
            q = ":close<Enter>";
            h = ":close<Enter>";
            O = ":open<Enter>";
            o = ":open<Enter>";
            S = ":save<space>";
            "|" = ":pipe<space>";
            D = ":delete<Enter>";
            A = ":archive flat<Enter>";
            "<C-l>" = ":open-link <space>";
            f = ":forward<Enter>";
            "rr" = ":reply -a<Enter>";
            "rq" = ":reply -aq<Enter>";
            "Rr" = ":reply<Enter>";
            "Rq" = ":reply -q<Enter>";
            H = ":toggle-headers<Enter>";
            "<C-k>" = ":prev-part<Enter>";
            "<A-k>" = ":prev-part<Enter>";
            "<C-Up>" = ":prev-part<Enter>";
            "<C-j>" = ":next-part<Enter>";
            "<A-j>" = ":next-part<Enter>";
            "<C-Down>" = ":next-part<Enter>";
            J = ":next<Enter>";
            "<C-Right>" = ":next<Enter>";
            K = ":prev<Enter>";
            "<C-Left>" = ":prev<Enter>";
          };

          "view::passthrough" = {
            "$noinherit" = true;
            "$ex" = "<C-x>";
            "<Esc>" = ":toggle-key-passthrough<Enter>";
          };

          "compose" = {
            "$noinherit" = true;
            "$ex" = "<C-x>";
            "<C-k>" = ":prev-field<Enter>";
            "<A-k>" = ":prev-field<Enter>";
            "<C-Up>" = ":prev-field<Enter>";
            "<C-j>" = ":next-field<Enter>";
            "<A-j>" = ":next-field<Enter>";
            "<C-Down>" = ":next-field<Enter>";
            "<A-p>" = ":switch-account -p<Enter>";
            "<C-Left>" = ":switch-account -p<Enter>";
            "<A-n>" = ":switch-account -n<Enter>";
            "<C-Right>" = ":switch-account -n<Enter>";
            "<tab>" = ":next-field<Enter>";
            "<backtab>" = ":prev-field<Enter>";
            "<C-p>" = ":prev-tab<Enter>";
            "<C-PgUp>" = ":prev-tab<Enter>";
            "<C-n>" = ":next-tab<Enter>";
            "<C-PgDn>" = ":next-tab<Enter>";
          };

          "compose::editor" = {
            "$noinherit" = true;
            "$ex" = "<C-x>";
            "<C-k>" = ":prev-field<Enter>";
            "<A-k>" = ":prev-field<Enter>";
            "<C-Up>" = ":prev-field<Enter>";
            "<C-j>" = ":next-field<Enter>";
            "<A-j>" = ":next-field<Enter>";
            "<C-Down>" = ":next-field<Enter>";
            "<C-p>" = ":prev-tab<Enter>";
            "<C-PgUp>" = ":prev-tab<Enter>";
            "<C-n>" = ":next-tab<Enter>";
            "<C-PgDn>" = ":next-tab<Enter>";
          };

          "compose::review" = {
            y = ":send<Enter>";
            n = ":abort<Enter>";
            v = ":preview<Enter>";
            p = ":postpone<Enter>";
            q = ":choose -o d discard abort -o p postpone postpone<Enter>";
            e = ":edit<Enter>";
            a = ":attach<space>";
            d = ":detach<space>";
          };

          terminal = {
            "$noinherit" = true;
            "$ex" = "<C-x>";
            "<C-p>" = ":prev-tab<Enter>";
            "<C-n>" = ":next-tab<Enter>";
            "<C-PgUp>" = ":prev-tab<Enter>";
            "<C-PgDn>" = ":next-tab<Enter>";
          };
        };

        extraConfig = {
          general = {
            unsafe-accounts-conf = true;
            enable-osc8 = true;
            log-file = "${config.xdg.cacheHome}/aerc/aerc.log";
            log-level = "error";
          };
          ui = {
            index-columns = "date<10,name<17,flags>4,subject<*";
            this-day-time-format = ''" .  15:04"'';
            this-week-time-format = "Mon 15:04";
            this-year-time-format = ''"Jan 02 AM"'';
            timestamp-format = "06 Jan 01";
            message-view-this-day-format = "Today 15:04";
            message-view-this-week-format = "Monday 15:04";
            message-view-this-year-format = "Jan 02 15:04";
            message-view-timestamp-format = "2006 Jan 01 15:04";
            sidebar-width = 20;
            mouse-enabled = false;
            new-message-bell = false;
            tab-title-account = ''{{.Account}} {{if .Exists "Inbox"}}({{if .Unread "Inbox"}}{{.Unread "Inbox"}}{{end}}/{{.Exists "Inbox"}}){{end}}'';
            tab-title-composer = ''To:{{(.To | initials) | join ","}}{{ if .Cc }}|Cc:{{(.Cc | initials) | join ","}}{{end}}|{{.Subject}}'';
            spinner = "◜,◠,◝,◞,◡,◟";
            sort = "-r arrival";
            dirlist-tree = true;
            dirlist-collapse = 1;
            next-message-on-delete = false;
            auto-mark-read = true;
            completion-popovers = true;
            completion-delay = "250ms";
            completion-min-chars = 1;
            icon-encrypted = ''"󰌆 "'';
            icon-signed = ''"󰳈 "'';
            icon-signed-encrypted = ''"󰯅 "'';
            icon-unknown = ''"󰒙 "'';
            icon-invalid = ''"󰻍 "'';
            icon-attachment = ''"󰁦 "'';
            icon-new = "";
            icon-old = "";
            icon-replied = ''"󰑚 "'';
            icon-flagged = ''"󰓎 "'';
            icon-deleted = ''"󰩺 "'';
            fuzzy-complete = true;
            threading-enabled = true;
          };

          "ui:folder=Archive" = {
            threading-enabled = false;
          };

          statusline = {
            display-mode = "text";
          };

          viewer = {
            pager = "less -Rc";
            header-layout = "From,To,Cc,Bcc,Date,Subject,Labels";
            always-show-mime = true;
          };

          compose = {
            # editor = "vim --cmd 'let g:lightweight=1'";
            header-layout = "From,To,CC,Subject";
            # address-book-cmd = "khard email --remove-first-line --parsable %s";
            file-picker-cmd = "fzf --multi --query=%s";
            # file-picker-cmd = "fd %s --type f | fzf --multi";
            reply-to-self = false;
            empty-subject-warning = true;
            no-attachment-warning = "^[^>]*attach(ed|ment)";
          };

          filters = {
            "text/plain" = "colorize";
            "text/html" = "html | colorize";
            # "text/html" = "html | bat -fPl md --style=auto";
            # "text/html" = "w3m -T text/html -cols $(tput cols) -dump -o display_image=false -o display_link_number=true";
            "text/calendar" = "calendar";
            # "text/*" = ''bat -fP --file-name="$AERC_FILENAME"'';
            "message/delivery-status" = "colorize";
            "message/rfc822" = "colorize";
            "application/pdf" = "zathura";
          };

          /*
             multipart-openers = {
            "text/html" = "pandoc -f markdown -t html --standalone";
          };
          */

          openers = {
            "application/x-pdf" = "zathura";
            "application/pdf" = "zathura";
            "application/octet-stream" = "zathura";
            "image/*" = "imv";
            "image/png" = "imv";
            "image/jpg" = "imv";
            "video/*" = "mpv";
            "audio/*" = "mpv --no-video";
            "text/*" = "${editor}";
            # "text/html" = "qutebrowser";
            "x-scheme-handler/http*" = "${pkgs.xdg-utils}/bin/xdg-open";
            # "x-scheme-handler/irc" = "hexchat";
          };
        };

        stylesets = {
          # TODO: submit patch for missing warning information in aerc-stylesets manpage
          default = ''
            title.bold=true
            header.bold=true
            border.fg=black
            border.reverse=true
            *error.bold=true
            *error.fg=red
            *warning.fg=yellow
            *success.fg=green
            statusline*.default=true
            statusline_default.bg=white
            statusline_default.fg=black
            statusline_error.fg=red
            statusline_warning.fg=yellow
            statusline_success.fg=green
            msglist_unread.bold=true
            msglist_answered.fg=blue
            msglist_flagged.fg=purple
            msglist_deleted.fg=gray
            msglist_result.fg=green
            msglist_marked.fg=yellow
            msglist_pill.reverse=true
            part_mimetype.dim=true
            part_mimetype.selected.dim=false
            part_filename.selected.bold=true
            completion_pill.reverse=true
            selector_focused.reverse=true
            selector_chooser.bold=true
          '';
        };
      };

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
        extraConfig = "";
        /*
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
        */
        settings = {};
        sidebar = {
          enable = true;
          format = "%D%?F? [%F]?%* %?N?%N/? %?S?%S?"; # "%D%?F? [%F]?%* %?N?%N/?%S"
          shortPath = true;
          width = 20;
        };
        sort = "threads";
        # vimKeys = true;
      };
    };
  };
}
