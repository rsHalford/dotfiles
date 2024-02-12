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
          open_categories = ["history" "quickmarks" "searchengines" "filesystem"];
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
          show = "always";
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
              bg = "#${theme.colors.base00}";
              border = {
                bottom = "#${theme.colors.base00}";
                top = "#${theme.colors.base00}";
              };
              fg = "#${theme.colors.base0A}";
            };
            even.bg = "#${theme.colors.base01}";
            fg = ["#${theme.colors.base05}" "#${theme.colors.base0D}" "#${theme.colors.base0A}"];
            item.selected = {
              bg = "#${theme.colors.base03}";
              border = {
                bottom = "#${theme.colors.base03}";
                top = "#${theme.colors.base03}";
              };
              fg = "#${theme.colors.base05}";
              match.fg = "#${theme.colors.base0A}";
            };
            match.fg = "#${theme.colors.base0A}";
            odd.bg = "#${theme.colors.base01}";
            scrollbar = {
              bg = "#${theme.colors.base00}";
              fg = "#${theme.colors.base05}";
            };
          };
          contextmenu = {
            disabled = {
              bg = "#${theme.colors.base03}";
              fg = "#${theme.colors.base03}";
            };
            menu = {
              bg = "#${theme.colors.base03}";
              fg = "#${theme.colors.base05}";
            };
            selected = {
              bg = "#${theme.colors.base03}";
              fg = "#${theme.colors.base05}";
            };
          };
          downloads = {
            bar.bg = "#${theme.colors.base01}";
            error = {
              bg = "#${theme.colors.base08}";
              fg = "#${theme.colors.base01}";
            };
            start = {
              bg = "#${theme.colors.base0A}";
              fg = "#${theme.colors.base01}";
            };
            stop = {
              bg = "#${theme.colors.base0B}";
              fg = "#${theme.colors.base01}";
            };
            system = {
              bg = "hsv";
              fg = "hsv";
            };
          };
          hints = {
            bg = "#${theme.colors.base0A}";
            fg = "#${theme.colors.base00}";
            match.fg = "#${theme.colors.base08}";
          };
          keyhint = {
            bg = "#${theme.colors.base01}";
            fg = "#${theme.colors.base05}";
            suffix.fg = "#${theme.colors.base0A}";
          };
          messages = {
            error = {
              bg = "#${theme.colors.base08}";
              border = "#${theme.colors.base08}";
              fg = "#${theme.colors.base05}";
            };
            info = {
              bg = "#${theme.colors.base01}";
              border = "#${theme.colors.base01}";
              fg = "#${theme.colors.base05}";
            };
            warning = {
              bg = "#${theme.colors.base09}";
              border = "#${theme.colors.base0A}";
              fg = "#${theme.colors.base05}";
            };
          };
          prompts = {
            bg = "#${theme.colors.base03}";
            border = "2px solid #${"#${theme.colors.base00}"}";
            fg = "#${theme.colors.base05}";
            selected = {
              bg = "#${theme.colors.base01}";
              fg = "#${theme.colors.base05}";
            };
          };
          statusbar = {
            caret = {
              bg = "#${theme.colors.base09}";
              fg = "#${theme.colors.base01}";
              selection = {
                bg = "#${theme.colors.base09}";
                fg = "#${theme.colors.base01}";
              };
            };
            command = {
              bg = "#${theme.colors.base01}";
              fg = "#${theme.colors.base0B}";
              private = {
                bg = "#${theme.colors.base01}";
                fg = "#${theme.colors.base0B}";
              };
            };
            insert = {
              bg = "#${theme.colors.base0D}";
              fg = "#${theme.colors.base01}";
            };
            normal = {
              bg = "#${theme.colors.base01}";
              fg = "#${theme.colors.base05}";
            };
            passthrough = {
              bg = "#${theme.colors.base0E}";
              fg = "#${theme.colors.base01}";
            };
            private = {
              bg = "#${theme.colors.base05}";
              fg = "#${theme.colors.base01}";
            };
            progress.bg = "#${theme.colors.base05}";
            url = {
              error.fg = "#${theme.colors.base08}";
              fg = "#${theme.colors.base05}";
              hover.fg = "#${theme.colors.base0D}";
              success = {
                http.fg = "#${theme.colors.base05}";
                https.fg = "#${theme.colors.base05}";
              };
              warn.fg = "#${theme.colors.base0A}";
            };
          };
          tabs = {
            bar.bg = "#${theme.colors.base01}";
            even = {
              bg = "#${theme.colors.base01}";
              fg = "#${theme.colors.base05}";
            };
            odd = {
              bg = "#${theme.colors.base01}";
              fg = "#${theme.colors.base05}";
            };
            pinned = {
              even = {
                bg = "#${theme.colors.base0B}";
                fg = "#${theme.colors.base00}";
              };
              odd = {
                bg = "#${theme.colors.base0B}";
                fg = "#${theme.colors.base00}";
              };
              selected = {
                even = {
                  bg = "#${theme.colors.base0B}";
                  fg = "#${theme.colors.base00}";
                };
                odd = {
                  bg = "#${theme.colors.base0B}";
                  fg = "#${theme.colors.base00}";
                };
              };
            };
            selected = {
              even = {
                bg = "#${theme.colors.base03}";
                fg = "#${theme.colors.base05}";
              };
              odd = {
                bg = "#${theme.colors.base03}";
                fg = "#${theme.colors.base05}";
              };
            };
          };
          webpage = {
            bg = "#${theme.colors.base05}";
            darkmode = {
              enabled = false;
              policy.images = "never";
            };
            preferred_color_scheme = "dark";
          };
        };
        hints = {
          border = "2px solid #${theme.colors.base09}";
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
