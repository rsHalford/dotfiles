{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.richard.suite.mail;
  editor = config.richard.terminal.utilities.editor;
  theme = config.richard.theme;
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
      notmuch = {
        enable = true;
        hooks.postNew = ''notmuch tag --input=${config.xdg.configHome}/notmuch/tagmail.notmuch'';
      };

      aerc = mkIf (cfg.client == "aerc") {
        enable = true;
        extraBinds = {
          global = {
            "?" = ":help keys<Enter>";
            "<C-c>" = ":quit<Enter>";
            "<C-q>" = ":quit<Enter>";

            "<C-n>" = ":next-tab<Enter>";
            "<C-PgDn>" = ":next-tab<Enter>";

            "<C-p>" = ":prev-tab<Enter>";
            "<C-PgUp>" = ":prev-tab<Enter>";

            "<C-t>" = ":term<Enter>";
          };

          messages = {
            q = ":quit<Enter>";

            j = ":next<Enter>";
            k = ":prev<Enter>";
            "<Down>" = ":next<Enter>";
            "<Up>" = ":prev<Enter>";

            "gg" = ":select 0<Enter>";
            G = ":select -1<Enter>";

            "<C-d>" = ":next 50%<Enter>";
            "<C-u>" = ":prev 50%<Enter>";
            "<C-b>" = ":prev 100%<Enter>";
            "<C-f>" = ":next 100%<Enter>";
            "<PgUp>" = ":prev 100%<Enter>";
            "<PgDn>" = ":next 100%<Enter>";

            J = ":next-folder<Enter>";
            K = ":prev-folder<Enter>";
            H = ":collapse-folder<Enter>";
            L = ":expand-folder<Enter>";
            "<A-j>" = ":next-folder<Enter>";
            "<A-k>" = ":prev-folder<Enter>";
            "<A-h>" = ":collapse-folder<Enter>";
            "<A-l>" = ":expand-folder<Enter>";

            "cc" = ":cf<space>";
            "ci" = ":cf Inbox<Enter>";
            "ca" = ":cf Archive<Enter>";
            "cd" = ":cf Drafts<Enter>";
            "cj" = ":cf Junk<Enter>";
            "cs" = ":cf Sent<Enter>";
            "ct" = ":cf Trash<Enter>";

            "<Enter>" = ":view<Enter>";
            l = ":view<Enter>";

            m = ":compose<Enter>";
            "rr" = ":reply -a<Enter>";
            "rq" = ":reply -aq<Enter>";
            "Rr" = ":reply<Enter>";
            "Rq" = ":reply -q<Enter>";
            f = ":forward -A<Enter>";
            F = ":forward -F<Enter>";

            u = ":read -t<enter>";
            "!" = ":flag -t<Enter>";
            v = ":mark -t<Enter>";
            V = ":mark -v<Enter>";
            "<Space>" = ":mark -t<Enter>:next<Enter>";

            a = ":read<Enter>:modify-labels -inbox<Enter>:archive flat<Enter>";
            A = ":unmark -a<Enter>:mark -T<Enter>:read<Enter>:modify-labels -inbox<Enter>:archive flat<Enter>";
            D = ":delete<Enter>";

            t = ":toggle-threads<Enter>";
            z = ":fold<Enter>";
            Z = ":unfold<Enter>";

            "$" = ":term<space>";
            "|" = ":pipe<space>";
            "/" = ":filter<space>";

            n = ":next-result<Enter>";
            N = ":prev-result<Enter>";

            "<Esc>" = ":clear<Enter>";

            s = ":split<Enter>";
            S = ":vsplit<Enter>";

            "ga" = ":flag<Enter>:pipe -mb git am -3<Enter>";
            "gp" = ":term git push<Enter>";
            "gl" = ":term git log<Enter>";
          };

          "messages:folder=Drafts" = {
            "<Enter>" = ":recall<Enter>";
          };

          "messages:folder=Junk" = {
            a = ":read<Enter>:modify-labels -spam -inbox<Enter>:archive flat<Enter>";
          };

          "view" = {
            h = ":close<Enter>";
            q = ":close<Enter>";

            J = ":next<Enter>";
            K = ":prev<Enter>";
            "<C-Right>" = ":next<Enter>";
            "<C-Left>" = ":prev<Enter>";

            "<A-j>" = ":next-part<Enter>";
            "<A-k>" = ":prev-part<Enter>";
            "<C-Down>" = ":next-part<Enter>";
            "<C-Up>" = ":prev-part<Enter>";

            "rr" = ":reply -a<Enter>";
            "rq" = ":reply -aq<Enter>";
            "Rr" = ":reply<Enter>";
            "Rq" = ":reply -q<Enter>";
            f = ":forward<Enter>";

            a = ":modify-labels -inbox<Enter>:archive flat<Enter>";
            D = ":delete<Enter>";

            S = ":save<space>";
            o = ":open<Enter>";

            H = ":toggle-headers<Enter>";
            "/" = ":toggle-key-passthrough<Enter>/";
            "|" = ":pipe<space>";
            "<C-l>" = ":open-link <space>";

            "ga" = ":pipe -mb git am -3<Enter>";
            "gp" = ":term git push<Enter>";
            "gl" = ":term git log<Enter>";
          };

          "view::passthrough" = {
            "$noinherit" = true;
            "$ex" = "<C-x>";
            "<Esc>" = ":toggle-key-passthrough<Enter>";
          };

          "compose" = {
            "$noinherit" = true;
            "$ex" = "<C-x>";

            "<A-j>" = ":next-field<Enter>";
            "<C-Down>" = ":next-field<Enter>";
            "<tab>" = ":next-field<Enter>";

            "<A-k>" = ":prev-field<Enter>";
            "<C-Up>" = ":prev-field<Enter>";
            "<backtab>" = ":prev-field<Enter>";

            "<A-n>" = ":switch-account -n<Enter>";
            "<A-p>" = ":switch-account -p<Enter>";

            "<C-Right>" = ":switch-account -n<Enter>";
            "<C-Left>" = ":switch-account -p<Enter>";

            "<C-n>" = ":next-tab<Enter>";
            "<C-PgDn>" = ":next-tab<Enter>";

            "<C-p>" = ":prev-tab<Enter>";
            "<C-PgUp>" = ":prev-tab<Enter>";
          };

          "compose::editor" = {
            "$noinherit" = true;
            "$ex" = "<C-x>";

            "<A-j>" = ":next-field<Enter>";
            "<C-Down>" = ":next-field<Enter>";

            "<A-k>" = ":prev-field<Enter>";
            "<C-Up>" = ":prev-field<Enter>";

            "<C-n>" = ":next-tab<Enter>";
            "<C-PgDn>" = ":next-tab<Enter>";

            "<C-p>" = ":prev-tab<Enter>";
            "<C-PgUp>" = ":prev-tab<Enter>";
          };

          "compose::review" = {
            a = ":attach<space>";
            d = ":detach<space>";
            e = ":edit<Enter>";
            n = ":abort<Enter>";
            p = ":postpone<Enter>";
            s = ":sign<Enter>";
            v = ":preview<Enter>";
            y = ":send -a flat<Enter>";
            Y = ":send<Enter>";
            A = ":header -f X-Sourcehut-Patchset-Update APPLIED<Enter>";
            N = ":header -f X-Sourcehut-Patchset-Update NEEDS_REVISION<Enter>";
            R = ":header -f X-Sourcehut-Patchset-Update REJECTED<Enter>";
            S = ":header -f X-Sourcehut-Patchset-Update SUPERSEEDED<Enter>";
          };

          terminal = {
            "$noinherit" = true;
            "$ex" = "<C-x>";

            "<C-n>" = ":next-tab<Enter>";
            "<C-PgDn>" = ":next-tab<Enter>";

            "<C-p>" = ":prev-tab<Enter>";
            "<C-PgUp>" = ":prev-tab<Enter>";
          };
        };

        extraConfig = {
          general = {
            unsafe-accounts-conf = true;
            defaul-download-path = "${config.home.homeDirectory}/downloads";
            enable-osc8 = true;
            log-file = "${config.xdg.cacheHome}/aerc/aerc.log";
            log-level = "error";
          };
          ui = {
            index-columns = "name<15%,reply:1,subject,labels>=,size>=,date>=";
            column-separator = ''" "'';
            column-reply = ''{{if .IsReplied}}󰑚{{end}}'';
            column-subject = ''{{.Style .ThreadPrefix "thread"}}{{ if .ThreadFolded}}{{ \
	            .Style (printf "%d*" .ThreadCount) "thread"}}{{end}}{{ \
	            .StyleSwitch .Subject (case `^(\[[\w-]+\]\s*)?\[(RFC )?PATCH` "patch")}}'';
            column-labels = ''{{.StyleMap .Labels \
	            (exclude .Folder) \
	            (default "thread") \
	            | join " "}}'';
            column-size = ''{{if .HasAttachment}}󰁦 {{end}}'';

            this-day-time-format = ''"15:04  . "'';
            this-week-time-format = "15:04 Mon";
            this-year-time-format = ''"AM 02 Jan"'';
            timestamp-format = "02 Jan 06";

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
            dirlist-left = ''{{switch .Folder \
              (case "Inbox" " 󰚇") \
              (case "Archive" " 󰀼") \
              (case "Drafts" " 󰙏") \
              (case "Junk" " 󱚝") \
              (case "Sent" " 󰑚") \
              (case "Trash" " 󰩺") \
              (default " 󰓼")}} {{.Folder}}
            '';
            dirlist-right = ''{{if .Unread}}{{humanReadable .Unread}}/{{end}}{{if .Exists}}{{humanReadable .Exists}} {{end}}'';

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

            styleset-name = "default";
          };

          "ui:folder=Archive" = {
            threading-enabled = false;
            index-columns = "star:1,name<15%,reply:1,subject,labels>=,size>=,date>=";
            column-separator = ''" "'';
            column-star = ''{{if .IsFlagged}}★{{end}}'';
            column-reply = ''{{if .IsReplied}}󰑚{{end}}'';
            column-subject = ''{{.Style .ThreadPrefix "thread"}}{{ if .ThreadFolded}}{{ \
	            .Style (printf "%d*" .ThreadCount) "thread"}}{{end}}{{ \
	            .StyleSwitch .Subject (case `^(\[[\w-]+\]\s*)?\[(RFC )?PATCH` "patch")}}'';
            column-labels = ''{{.Labels | join " "}}'';
            column-size = ''{{if .HasAttachment}}󰁦 {{end}}'';
          };

          statusline = {
            display-mode = "text";
            status-columns = "left<*,center:=,right>*";
            column-left = "[{{.Account}}] {{.StatusInfo}}";
            column-center = "{{.PendingKeys}}";
            column-right = ''{{.TrayInfo}} | {{.Style cwd "cyan"}}'';
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
            "subject,~^\\[PATCH" = "hldiff";
            "subject,~^\\[RFC" = "hldiff";
            "text/plain" = "colorize";
            "text/calendar" = "calendar";
            "text/html" = "w3m -T text/html -cols $(tput cols) -dump -o display_image=false -o display_link_number=true";
            # "text/*" = "plaintext";
            # "text/html" = "html | colorize";
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
            "application/pdf" = "zathura";
            "application/x-pdf" = "zathura";
            "application/octet-stream" = "zathura";
            "image/*" = "imv";
            "video/*" = "mpv";
            "audio/*" = "mpv --no-video";
            "text/*" = "${editor}";
            "x-scheme-handler/http*" = "${pkgs.xdg-utils}/bin/xdg-open";
            # "x-scheme-handler/irc" = "hexchat";
          };
        };

        stylesets = {
          # TODO: submit patch for missing warning information in aerc-stylesets manpage
          default = ''
            *.default=true
            *.normal=true
            
            border.bg=#${theme.colors.base00}

            title.fg=#${theme.colors.base07}
            title.bg=#${theme.colors.base00}
            title.bold=true
            
            header.fg=#${theme.colors.base07}
            header.fg=#${theme.colors.base00}
            header.bold=true
            
            tab.selected.fg=#${theme.colors.base0D}
            tab.selected.bg=#${theme.colors.base00}
            tab.selected.bold=true

            dirlist*.fg=#${theme.colors.base0D}
            dirlist*.selected.fg=#${theme.colors.base07}
            dirlist*.selected.bg=#${theme.colors.base0D}
            dirlist*.selected.bold=true
            
            *error.bold=true
            *error.fg=#${theme.colors.base08}
            *warning.fg=#${theme.colors.base0A}
            *success.fg=#${theme.colors.base0B}
            
            statusline*.bg=#${theme.colors.base00}
            statusline_default.fg=#${theme.colors.base06}
            statusline_error.fg=#${theme.colors.base08}
            statusline_warning.fg=#${theme.colors.base0A}
            statusline_success.fg=#${theme.colors.base0B}

            msglist_*.selected.fg=#${theme.colors.base07}
            msglist_*.selected.bg=#${theme.colors.base0D}

            msglist_unread.bold=true

            msglist_marked.fg=#${theme.colors.base09}
            msglist_marked.selected.fg=#${theme.colors.base00}
            msglist_marked.selected.bg=#${theme.colors.base09}

            msglist_flagged.fg=#${theme.colors.base0E}
            msglist_flagged.selected.fg=#${theme.colors.base07}
            msglist_flagged.selected.bg=#${theme.colors.base0E}

            msglist_answered.fg=#${theme.colors.base0C}
            msglist_answered.selected.fg=#${theme.colors.base07}
            msglist_answered.selected.bg=#${theme.colors.base0C}

            msglist_deleted.fg=#${theme.colors.base03}
            msglist_deleted.selected.fg=#${theme.colors.base07}
            msglist_deleted.selected.bg=#${theme.colors.base03}

            msglist_pill.bg=#${theme.colors.base0D}
            # msglist_pill.reverse=true

            msglist*.X-Sourcehut-Patchset-Update,APPLIED.fg = #${theme.colors.base0B}
            msglist*.X-Sourcehut-Patchset-Update,APPLIED.selected.fg = #${theme.colors.base07}
            msglist*.X-Sourcehut-Patchset-Update,APPLIED.selected.bg = #${theme.colors.base0B}

            msglist*.X-Sourcehut-Patchset-Update,APPROVED.fg = #${theme.colors.base0B}
            msglist*.X-Sourcehut-Patchset-Update,APPROVED.selected.fg = #${theme.colors.base07}
            msglist*.X-Sourcehut-Patchset-Update,APPROVED.selected.bg = #${theme.colors.base0B}

            msglist*.X-Sourcehut-Patchset-Update,NEEDS_REVISION.fg = #${theme.colors.base0A}
            msglist*.X-Sourcehut-Patchset-Update,NEEDS_REVISION.selected.fg = #${theme.colors.base06}
            msglist*.X-Sourcehut-Patchset-Update,NEEDS_REVISION.selected.bg = #${theme.colors.base0A}

            msglist*.X-Sourcehut-Patchset-Update,SUPERSEDED.fg = #${theme.colors.base0A}
            msglist*.X-Sourcehut-Patchset-Update,SUPERSEDED.selected.fg = #${theme.colors.base06}
            msglist*.X-Sourcehut-Patchset-Update,SUPERSEDED.selected.bg = #${theme.colors.base0A}

            msglist*.X-Sourcehut-Patchset-Update,REJECTED.fg = #${theme.colors.base08}
            msglist*.X-Sourcehut-Patchset-Update,REJECTED.selected.fg = #${theme.colors.base07}
            msglist*.X-Sourcehut-Patchset-Update,REJECTED.selected.bg = #${theme.colors.base08}
            
            part_*.fg=#${theme.colors.base0D}
            part_*.selected.fg=#${theme.colors.base07}
            part_*.selected.bg=#${theme.colors.base0D}
            part_mimetype.dim=true
            part_mimetype.selected.dim=false
            part_filename.selected.bold=true
            
            selector_focused.fg=#${theme.colors.base07}
            selector_focused.bg=#${theme.colors.base0D}
            selector_focused.bold=true

            selector_chooser.fg=#${theme.colors.base07}
            selector_chooser.bg=#${theme.colors.base0D}
            selector_chooser.bold=true

            default.selected.fg=#${theme.colors.base07}
            default.selected.bg=#${theme.colors.base0D}
            default.selected.bold=true
            
            completion_default.fg=#${theme.colors.base09}
            completion_default.selected.bg=#${theme.colors.base07}
            completion_default.selected.bg=#${theme.colors.base09}
            completion_pill.reverse=true
            
            [viewer]
            *.default=true
            *.normal=true
            url.fg=#${theme.colors.base0A}
            url.underline=true
            header.fg=#${theme.colors.base0D}
            header.bold=true
            signature.dim=true

            diff_meta.fg=#${theme.colors.base07}
            diff_meta.bold=true
            diff_chunk.fg=#${theme.colors.base0C}
            diff_chunk_func.fg=#${theme.colors.base0D}
            diff_add.fg=#${theme.colors.base0B}
            diff_del.fg=#${theme.colors.base08}

            quote_1.fg=#${theme.colors.base0E}
            quote_2.fg=#${theme.colors.base0D}
            quote_3.fg=#${theme.colors.base0C}
            quote_4.fg=#${theme.colors.base0B}
            quote_x.fg=#${theme.colors.base0A}
            
            [user]
            cyan.fg=cyan
            thread.fg=#${theme.colors.base08}
            patch.fg=#${theme.colors.base0A}
            dim.fg = #${theme.colors.base05}
          '';
          patch = ''
            *.default=true
            *.normal=true
            
            msglist_read.fg=#${theme.colors.base0A}
            msglist_unread.fg=#${theme.colors.base0A}
            msglist_unread.bold=true

            msglist_*.selected.bg=#${theme.colors.base0A}
            msglist_marked.fg=#${theme.colors.base0A}
            
            [user]
            cyan.fg=#${theme.colors.base0C}
            thread.fg=#${theme.colors.base08}
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
