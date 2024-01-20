{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.richard.browser.http;
  fonts = config.richard.fonts;
  terminal = config.richard.terminal.emulator.program;
  terminal-editor = config.richard.terminal.utilities.editor;
  theme = config.richard.theme;
in {
  imports = [~/.dotfiles/secrets/qutebrowser];

  options.richard.browser.http.qutebrowser = {
    enable = mkOption {
      description = "Enable qutebrowser";
      type = types.bool;
      default = false;
    };
  };

  config = {
    programs.qutebrowser = {
      enable = cfg.qutebrowser.enable;
      enableDefaultBindings = true;
      aliases = {
        "q" = "close";
        "qa" = "quit";
        "w" = "session-save";
        "wp" = "cmd-set-text :session-save -o -p private";
        "wq" = "quit --save";
        "wqa" = "quit --save";
      };
      # extraConfig = "";
      keyBindings = {
        command = {
          "<Ctrl-J>" = "completion-item-focus next";
          "<Ctrl-K>" = "completion-item-focus prev";
          "<Alt-J>" = "completion-item-focus next";
          "<Alt-K>" = "completion-item-focus prev";
        };
        normal = {
          "gp" = "cmd-set-text -s :open -p";
          ",r" = "spawn --userscript readability";
          ",sd" = "cmd-set-text -s :session-delete";
          ",sl" = "cmd-set-text -s :session-load";
          ",ss" = "cmd-set-text -s :session-save";
          ",sp" = "cmd-set-text -s :session-save -o -p";
          ",S" = "config-cycle statusbar.show in-mode always";
          ",T" = "config-cycle tabs.show switching always;; config-cycle tabs.title.format {index:>2} '{index:>2}{audio} {current_title}';; config-cycle tabs.width 40 '20%'";
          ",tg" = "cmd-set-text -s :tab-give";
          ",tp" = "cmd-set-text -s :tab-pin";
          ",ts" = "cmd-set-text -s :tab-select";
          ",v" = "spawn --userscript view_in_mpv";
          ",V" = "hint links userscript view_in_mpv";
          # ";v" = "hint --rapid links userscript view_in_mpv";
          "zl" = "spawn --userscript qute-pass";
          "zul" = "spawn --userscript qute-pass --username-only";
          "zpl" = "spawn --userscript qute-pass --password-only";
        };
      };
      # keyMappings = { };
      loadAutoconfig = true;
      settings = {
        auto_save.session = true;
        changelog_after_upgrade = "patch";
        completion = {
          height = "33%";
          open_categories = ["searchengines" "quickmarks" "filesystem" "history"];
          scrollbar.padding = 1;
          scrollbar.width = 7;
          shrink = true;
          timestamp_format = "%H:%M %d-%m-%y";
        };
        confirm_quit = ["downloads"];
        content = {
          autoplay = false;
          blocking.adblock.lists = [
            "https://easylist.to/easylist/easylist.txt"
            "https://easylist.to/easylist/easyprivacy.txt"
            "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/filters-2020.txt"
            "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/filters-2021.txt"
            "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/filters-2022.txt"
            "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/filters-2023.txt"
            "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/filters-2024.txt"
          ];
          blocking.method = "both";
          fullscreen.window = true;
          headers.accept_language = "en-GB,en-US;q=0.9,en;q=0.8";
          notifications.enabled = false;
        };
        downloads = {
          location.directory = "${config.home.homeDirectory}/downloads";
          location.suggestion = "both";
          position = "bottom";
          remove_finished = 180000;
        };
        editor.command = ["${terminal}" "-e" "${terminal-editor}" "{}"];
        keyhint.delay = 0;
        scrolling = {
          bar = "never";
          smooth = false;
        };
        session.default_name = "default";
        spellcheck.languages = ["en-GB"];
        statusbar = {
          show = "in-mode";
          widgets = ["keypress" "history" "url" "progress" "scroll" "tabs"];
        };
        tabs = {
          indicator.width = 0;
          new_position.unrelated = "next";
          position = "left";
          last_close = "default-page";
          select_on_remove = "prev";
          show = "switching";
          show_switching_delay = 1500;
          title.format = "{index:>2}";
          title.format_pinned = "{index:>2}";
          width = 40;
        };
        url = {
          default_page = "/home/richard/.dotfiles/modules/users/browser/start/index.html";
          open_base_url = true;
          start_pages = ["/home/richard/.dotfiles/modules/users/browser/start/index.html"];
        };
        window.title_format = "{perc}{audio}{private}{current_title}{title_sep}qutebrowser";
        zoom.levels = [
          "25%"
          "33%"
          "50%"
          "67%"
          "75%"
          "90%"
          "100%"
          "110%"
          "125%"
          "133%"
          "150%"
          "175%"
          "200%"
          "250%"
          "300%"
          "400%"
          "500%"
        ];
        colors = {
          completion = {
            category = {
              bg = "#${theme.background}";
              border = {
                bottom = "#${theme.background}";
                top = "#${theme.background}";
              };
              fg = "#${theme.bright3}";
            };
            even.bg = "#${theme.regular0}";
            fg = ["#${theme.foreground}" "#${theme.bright4}" "#${theme.bright3}"];
            item.selected = {
              bg = "#${theme.bright0}";
              border = {
                bottom = "#${theme.bright0}";
                top = "#${theme.bright0}";
              };
              fg = "#${theme.foreground}";
              match.fg = "#${theme.regular1}";
            };
            match.fg = "#${theme.regular1}";
            odd.bg = "#${theme.regular0}";
            scrollbar = {
              bg = "#${theme.background}";
              fg = "#${theme.regular7}";
            };
          };
          contextmenu = {
            disabled = {
              bg = "#${theme.bright0}";
              fg = "#${theme.bright0}";
            };
            menu = {
              bg = "#${theme.bright0}";
              fg = "#${theme.foreground}";
            };
            selected = {
              bg = "#${theme.bright0}";
              fg = "#${theme.bright7}";
            };
          };
          downloads = {
            bar.bg = "#${theme.regular0}";
            error = {
              bg = "#${theme.regular1}";
              fg = "#${theme.regular0}";
            };
            start = {
              bg = "#${theme.regular3}";
              fg = "#${theme.regular0}";
            };
            stop = {
              bg = "#${theme.regular2}";
              fg = "#${theme.regular0}";
            };
            system = {
              bg = "hsv";
              fg = "hsv";
            };
          };
          hints = {
            bg = "#${theme.bright3}";
            fg = "#${theme.background}";
            match.fg = "#${theme.regular1}";
          };
          keyhint = {
            bg = "#${theme.regular0}";
            fg = "#${theme.foreground}";
            suffix.fg = "#${theme.bright3}";
          };
          messages = {
            error = {
              bg = "#${theme.regular1}";
              border = "#${theme.regular1}";
              fg = "#${theme.bright7}";
            };
            info = {
              bg = "#${theme.regular0}";
              border = "#${theme.regular0}";
              fg = "#${theme.foreground}";
            };
            warning = {
              bg = "#${theme.color17}";
              border = "#${theme.regular3}";
              fg = "#${theme.foreground}";
            };
          };
          prompts = {
            bg = "#${theme.bright0}";
            border = "2px solid #${"#${theme.background}"}";
            fg = "#${theme.foreground}";
            selected = {
              bg = "#${theme.regular0}";
              fg = "#${theme.bright7}";
            };
          };
          statusbar = {
            caret = {
              bg = "#${theme.color17}";
              fg = "#${theme.regular0}";
              selection = {
                bg = "#${theme.color17}";
                fg = "#${theme.regular0}";
              };
            };
            command = {
              bg = "#${theme.regular0}";
              fg = "#${theme.bright2}";
              private = {
                bg = "#${theme.regular0}";
                fg = "#${theme.bright2}";
              };
            };
            insert = {
              bg = "#${theme.bright4}";
              fg = "#${theme.regular0}";
            };
            normal = {
              bg = "#${theme.regular0}";
              fg = "#${theme.foreground}";
            };
            passthrough = {
              bg = "#${theme.bright5}";
              fg = "#${theme.regular0}";
            };
            private = {
              bg = "#${theme.foreground}";
              fg = "#${theme.regular0}";
            };
            progress.bg = "#${theme.foreground}";
            url = {
              error.fg = "#${theme.regular1}";
              fg = "#${theme.foreground}";
              hover.fg = "#${theme.bright4}";
              success = {
                http.fg = "#${theme.regular7}";
                https.fg = "#${theme.bright7}";
              };
              warn.fg = "#${theme.regular3}";
            };
          };
          tabs = {
            bar.bg = "#${theme.regular0}";
            even = {
              bg = "#${theme.regular0}";
              fg = "#${theme.foreground}";
            };
            odd = {
              bg = "#${theme.regular0}";
              fg = "#${theme.foreground}";
            };
            pinned = {
              even = {
                bg = "#${theme.regular2}";
                fg = "#${theme.background}";
              };
              odd = {
                bg = "#${theme.regular2}";
                fg = "#${theme.background}";
              };
              selected = {
                even = {
                  bg = "#${theme.bright2}";
                  fg = "#${theme.background}";
                };
                odd = {
                  bg = "#${theme.bright2}";
                  fg = "#${theme.background}";
                };
              };
            };
            selected = {
              even = {
                bg = "#${theme.bright0}";
                fg = "#${theme.foreground}";
              };
              odd = {
                bg = "#${theme.bright0}";
                fg = "#${theme.foreground}";
              };
            };
          };
          webpage = {
            bg = "#${theme.foreground}";
            darkmode = {
              enabled = true;
              policy.images = "never";
            };
            preferred_color_scheme = "dark";
          };
        };
        hints = {
          border = "2px solid #${theme.color16}";
          # padding = {
          #   top = 0;
          #   bottom = 1;
          #   left = 3;
          #   right = 3;
          # };
          radius = 1;
        };
        keyhint.radius = 1;
        prompt.radius = 2;
        # statusbar.padding = {
        #   top = 1;
        #   bottom = 1;
        #   left = 0;
        #   right = 1;
        # };
        # tabs.padding = {
        #   top = 1;
        #   bottom = 1;
        #   left = 0;
        #   right = 0;
        # };
        fonts = {
          contextmenu = fonts.sans;
          default_family = ["${fonts.monospace.name} Nerd Font"];
          default_size = "14px";
          web.family = {
            sans_serif = fonts.sans;
            serif = fonts.serif;
          };
        };
      };
    };
  };
}
